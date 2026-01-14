<?php
   // session_start();
$page_title = "Login - Explore Jeddah";
include __DIR__ . "/../includes/header.php";
require_once __DIR__ . "/../database/db_connect.php";

$errors = [];
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
    $password = $_POST['password'] ?? '';

    if (!$email) $errors[] = "Valid email required.";
    if ($password === '') $errors[] = "Password required.";

    if (empty($errors)) {
        $stmt = $conn->prepare("SELECT user_id, email, fullname, password_hash FROM users WHERE email = ?");
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $stmt->store_result();
        if ($stmt->num_rows === 1) {
		$stmt->bind_result($user_id, $email_db, $fullname, $password_hash);
            $stmt->fetch();
            if (password_verify($password, $password_hash)) {
                // login success
                session_start();
                $_SESSION['user_id'] = $user_id;
                $_SESSION['fullname'] = $fullname;
				$_SESSION['email']=$email_db;
                
                header('Location: /index.php');
                exit;
            } else {
                $errors[] = "Invalid credentials.";
            }
        } else {
            $errors[] = "Invalid credentials.";
        }
        $stmt->close();
    }
}
?>

<div class="page-header">
    <h1>Login</h1>
    <p>Sign in to access protected pages.</p>
</div>

<div class="content-container">
    <?php if (!empty($errors)): ?>
        <div class="error">
            <ul>
                <?php foreach ($errors as $e): ?>
                    <li><?php echo htmlspecialchars($e); ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form method="post" action="login.php" novalidate>
        <label for="email">Email</label><br>
        <input id="email" name="email" type="email" required><br>

        <label for="password">Password</label><br>
        <input id="password" name="password" type="password" required><br>

        <button type="submit">Log In</button>
    </form>
</div>

<?php include __DIR__ . "/../includes/footer.php"; ?>
