#!/bin/bash
# Exit on error
set -e

### === ARGUMENTS === ###
if [ $# -ne 2 ]; then
    echo "Usage: $0 <NODE_HOSTNAME> <HEADNODE_IP>"
    exit 1
fi

USER_HOSTNAME="$1"
HEADNODE_IP="$2"
HEADNODE_HOSTNAME="server1"   # PBS server hostname
HOME_DIR="/home"               # Shared home directory
NFS_DIR="/ddn"                 # Shared NFS directory
CDROM_DIR="/cdrom"

### === 1. Set Hostname using node's own IP ===
# Get node's first non-loopback IP
NODE_IP=$(hostname -I | awk '{print $1}')
IP_SUFFIX="${NODE_IP##*.}"
NODE_HOSTNAME="${USER_HOSTNAME}-kcn${IP_SUFFIX}"

echo "[1/9] Setting hostname to $NODE_HOSTNAME (IP: $NODE_IP)"
hostnamectl set-hostname "$NODE_HOSTNAME"

### === 2. Mount CDROM and configure repo ===
echo "[2/9] Mounting /dev/sr0 to $CDROM_DIR and configuring CentOS Media repo..."
mkdir -p $CDROM_DIR
mount /dev/sr0 $CDROM_DIR

mkdir -p /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/ 2>/dev/null || true

cat > /etc/yum.repos.d/CentOS-Media.repo <<EOF
[InstallMedia]
name=CentOS-\$releasever - Media
baseurl=file://$CDROM_DIR
enabled=1
gpgcheck=0
EOF

# Modify only CentOS-Base.repo to add enabled=0 after gpgcheck
BASE_REPO="/etc/yum.repos.d/backup/CentOS-Base.repo"
if [[ -f "$BASE_REPO" ]]; then
    sed -i '/^gpgcheck=/ {
        N
        /\nenabled=/ {
            s/\(gpgcheck=.*\)\nenabled=.*/\1\nenabled=0/
            b
        }
        /\nenabled=/! {
            s/$/\nenabled=0/
        }
    }' "$BASE_REPO"
else
    echo "Warning: $BASE_REPO not found, skipping enabled=0 modification"
fi

### === 3. Yum cache rebuild ===
echo "[3/9] Cleaning yum cache and rebuilding..."
yum clean all
yum makecache

### === 4. Install required tools ===
echo "[4/9] Installing required tools..."
yum install -y nano 
yum install -y libnfsidmap.x86_64 nfs-utils.x86_64 nfs4-acl-tools.x86_64
yum install -y pbspro-execution-19.1.3-0.x86_64.rpm
yum install -y environment-modules 


### === 5. Enable SSH service ===
echo "[5/9] Enabling SSH service..."
systemctl enable sshd
systemctl restart sshd

### === 6. Configure shared mounts ===
echo "[6/9] Configuring shared mounts for /home and $NFS_DIR"
mkdir -p "$HOME_DIR" "$NFS_DIR"

grep -q "$HEADNODE_IP:$HOME_DIR" /etc/fstab || echo "$HEADNODE_IP:$HOME_DIR $HOME_DIR nfs defaults 0 0" >> /etc/fstab
grep -q "$HEADNODE_IP:$NFS_DIR" /etc/fstab || echo "$HEADNODE_IP:$NFS_DIR $NFS_DIR nfs defaults 0 0" >> /etc/fstab
 

### === Sync users from server (UID ≥ 1000) ===
echo "[7/9] Syncing user accounts with UID ≥ 1000 from server..."

TMP_DIR="/tmp/hpc_user_sync"
REMOTE_USER="root"  # This can be any user with SSH access to the server
LOCAL_USER="root"    # The local user performing the operation
LOCAL_HOME="/home"

# On the server: extract users with UID ≥ 1000
ssh $REMOTE_USER@$HEADNODE_IP "mkdir -p $TMP_DIR && \
    awk -F: '\$3 >= 1000 {print}' /etc/passwd > $TMP_DIR/passwd.users && \
    awk -F: '\$3 >= 1000 {print}' /etc/group > $TMP_DIR/group.users && \
    awk -F: 'NR==FNR{uids[\$1]; next} \$1 in uids' $TMP_DIR/passwd.users /etc/shadow > $TMP_DIR/shadow.users"

# Copy files to the node
scp $REMOTE_USER@$HEADNODE_IP:$TMP_DIR/passwd.users /tmp/passwd.users
scp $REMOTE_USER@$HEADNODE_IP:$TMP_DIR/group.users /tmp/group.users
scp $REMOTE_USER@$HEADNODE_IP:$TMP_DIR/shadow.users /tmp/shadow.users

echo "[+] Appending users to local files if missing..."

# Only append if user/group doesn't exist
while read line; do 
	uid=`echo "$line" | awk -F: '{print $3}'`
	j=`echo "$line" | awk -F: '{print $1}'`
	if [ "$uid" -ge 1000 ]; then
		sed -i "/^$j:/d" /etc/passwd
		echo "$line" >> /etc/passwd
	fi
done < /tmp/passwd.users

while read line; do
        gid=`echo "$line" | awk -F: '{print $3}'`
        j=`echo "$line" | awk -F: '{print $1}'`
        if [ "$gid" -ge 1000 ]; then
                sed -i "/^$j:/d" /etc/group
                echo "$line" >> /etc/group
        fi
done < /tmp/group.users

while read line; do
        u2=`echo "$line" | awk -F: '{print $1}'`
        uid=$(grep "^$u2:" /etc/passwd | awk -F: '{print $3}')
        if [ "$uid" -ge 1000 ]; then
                sed -i "/^$uid:/d" /etc/shadow
                echo "$line" >> /etc/shadow
        fi
done < /tmp/shadow.users

# Set correct permissions
chmod 644 /etc/passwd /etc/group
chmod 400 /etc/shadow

# Ensure all home directories exist and are owned correctly
cut -d: -f1,6 /tmp/passwd.users | while IFS=: read -r name homedir; do
    mkdir -p "$homedir"
    chown "$name" "$homedir"
done

echo "[✓] Users synced from headnode!"


# Get latest /etc/hosts from headnode
scp root@$HEADNODE_IP:/etc/hosts /etc/hosts

# Add headnode entry if missing
grep -q "$HEADNODE_IP" /etc/hosts || echo "$HEADNODE_IP $HEADNODE_HOSTNAME" >> /etc/hosts

# Add this node to /etc/hosts if missing
grep -q "$NODE_IP" /etc/hosts || echo "$NODE_IP $NODE_HOSTNAME" >> /etc/hosts

# Send updated /etc/hosts back to headnode
scp /etc/hosts root@$HEADNODE_IP:/etc/hosts

mount -a

### === 7. Passwordless SSH setup for non-root user ===
SSH_USER="user1"   # Replace with your actual user

echo "[7/9] Setting up passwordless SSH for $SSH_USER"

# On the server:
#ssh -o StrictHostKeyChecking=no $SSH_USER@$HEADNODE_IP "
#    echo "1"
#    mkdir -p ~/.ssh &&
#    chmod 700 ~/.ssh &&
#    [ ! -f ~/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N '' -q || true
#"
#echo "2"
# Append server's public key to node's authorized_keys
#ssh -o StrictHostKeyChecking=no $SSH_USER@$HEADNODE_IP "cat ~/.ssh/id_rsa.pub" >> /home/$SSH_USER/.ssh/authorized_keys

# Append node's public key to server's authorized_keys
#cat /home/$SSH_USER/.ssh/id_rsa.pub | ssh -o StrictHostKeyChecking=no $SSH_USER@$HEADNODE_IP \
#    "cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

#chown -R $SSH_USER:$SSH_USER /home/$SSH_USER/.ssh

echo "[+] 2-way passwordless SSH for $SSH_USER setup complete"




### === 8. Configure PBS MOM ===
echo "[8/9] Configuring PBS MOM to connect to $HEADNODE_HOSTNAME ($HEADNODE_IP)"
### === 8. Configure PBS MOM and sync /etc/hosts ===
echo "[8/9] Configuring PBS MOM and syncing /etc/hosts..."

# Get latest /etc/hosts from headnode
scp root@$HEADNODE_IP:/etc/hosts /etc/hosts

# Add headnode entry if missing
grep -q "$HEADNODE_IP" /etc/hosts || echo "$HEADNODE_IP $HEADNODE_HOSTNAME" >> /etc/hosts

# Add this node to /etc/hosts if missing
grep -q "$NODE_IP" /etc/hosts || echo "$NODE_IP $NODE_HOSTNAME" >> /etc/hosts

# Send updated /etc/hosts back to headnode
scp /etc/hosts root@$HEADNODE_IP:/etc/hosts


cat > /etc/pbs.conf <<EOF
PBS_EXEC=/opt/pbs
PBS_SERVER=$HEADNODE_HOSTNAME
PBS_START_SERVER=0
PBS_START_SCHED=0
PBS_START_COMM=0
PBS_START_MOM=1
PBS_HOME=/var/spool/pbs
PBS_CORE_LIMIT=unlimited
PBS_SCP=/bin/scp
EOF

echo "\$clienthost $HEADNODE_HOSTNAME" > /var/spool/pbs/mom_priv/config

systemctl enable pbs
systemctl restart pbs

### === 9. Auto-register node on PBS server ===
echo "[9/9] Registering node $NODE_HOSTNAME on PBS server..."
#ssh root@$HEADNODE_IP "qmgr -c 'create node $NODE_HOSTNAME'" || echo "[!] Node might already exist on server"



echo "[+] Node $NODE_HOSTNAME setup complete with shared /home, PBS MOM, and passwordless SSH!"
echo "Verify from headnode using: pbsnodes -aS"
