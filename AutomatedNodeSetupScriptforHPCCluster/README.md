# ⚙️ Automated Node Setup Script for HPC Cluster  
### Fully Automated Worker Node Configuration for PBS, NFS, and Shared User Synchronization

This project provides a fully automated **Bash script** designed to configure compute nodes in a **High-Performance Computing (HPC) cluster** environment.  
The script prepares a new node to properly join an existing cluster with:

- Shared home directories (NFS)
- PBS Professional MOM service
- User account synchronization
- SSH configuration
- Yum repository setup from installation media
- Hostname assignment based on IP
- Required tool installation

This automation significantly reduces manual setup time and ensures identical configuration across worker nodes.

---

## 📌 Key Features

### ✔ **1. Automatic Hostname Generation**
- Detects node IP and generates hostname using IP suffix  
- Ensures unique and consistent naming across the cluster

---

### ✔ **2. Local Media-Based Yum Repository Setup**
- Mounts `/dev/sr0` as CentOS installation media  
- Creates a local Yum repo for offline installation  
- Safely backs up and modifies existing repo files  

---

### ✔ **3. Installation of Required System Packages**
Installs essential tools required in HPC environments:

- `nano`  
- `environment-modules`  
- NFS tools  
- PBS Pro Execution package  

---

### ✔ **4. SSH Service Configuration**
- Enables and restarts the SSH daemon  
- Prepares for passwordless SSH setup (two-way) between nodes and headnode  

---

### ✔ **5. NFS Shared Directories Mounting**
Automatically configures shared filesystems:

- `/home`  
- `/ddn` (cluster-wide shared storage)

Entries are added to `/etc/fstab` to ensure persistent mounting.

---

### ✔ **6. User Account Synchronization (UID ≥ 1000)**  
Automatically pulls user accounts from headnode:

- `/etc/passwd`
- `/etc/group`
- `/etc/shadow`

Ensures compute nodes match headnode users and home directories:

- Creates missing home dirs  
- Fixes permissions  
- Rebuilds account entries only where required  

---

### ✔ **7. Cluster-Wide /etc/hosts Synchronization**
- Syncs hosts file with headnode  
- Adds node entry if missing  
- Updates headnode with new node’s hostname  
- Ensures consistent hostname resolution cluster-wide  

---

### ✔ **8. PBS MOM Configuration**
Automatically configures PBS Professional:

- Creates `/etc/pbs.conf`  
- Enables and restarts PBS MOM service  
- Sets correct PBS server  
- Prepares node to register with the headnode scheduler  

---

### ✔ **9. Node Auto-Registration (Optional)**
The script attempts to create the node inside PBS using:

```bash
qmgr -c "create node <NODE_HOSTNAME>"
```

(If the node exists, it safely continues.)

---

### 🧩 How It Works

You run the script with:

```bash
./setup-node.sh <NODE_HOSTNAME_PREFIX> <HEADNODE_IP>
```

Example:

```bash
./setup-node.sh compute 192.168.10.1
```

If the node’s IP is 192.168.10.22, its hostname becomes:

```
compute-kcn22
```

---

### 📁 Requirements

- **CentOS-based compute node**

- **SSH access to headnode**

- **PBS Professional installed on headnode**

- **NFS server exporting /home and /ddn**

- **Installation media available via /dev/sr0**

---

### 🛠️ Technologies Used

- **Bash scripting**

- **PBS Professional (PBS Pro)**

- **NFS (Network File System)**

- **SSH & SCP automation**

- **Systemd services**

- **Linux user/group management**

- **CentOS package management (Yum)**

---

### 🚀 Purpose of This Project

This script enables:

- **Rapid deployment of HPC worker nodes**

- **Uniform configuration**

- **Reduction of human error**

- **Simplified scaling of compute clusters**

It is designed for environments like:

- **University HPC clusters**

- **Research compute farms**

- **Distributed computing systems**

---