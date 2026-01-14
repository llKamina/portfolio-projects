<?php
$page_title = "Register - Explore Jeddah";
include __DIR__ . "/../includes/header.php";
require_once __DIR__ . "/../database/db_connect.php";

$errors = [];
$success = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Sanitize inputs
    $fullname = trim($_POST['fullname'] ?? '');
    $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
    $password = $_POST['password'] ?? '';
    $confirm = $_POST['confirm'] ?? '';

    // Validation
    if ($fullname === '') $errors[] = "Full name is required.";
    if (!$email) $errors[] = "Valid email is required.";
    if ($password === '') $errors[] = "Password is required.";
    if ($password !== $confirm) $errors[] = "Passwords do not match.";

    if (empty($errors)) {
        // Check if email already exists
        $check = $conn->prepare("SELECT user_id FROM users WHERE email = ?");
        $check->bind_param("s", $email);
        $check->execute();
        $check->store_result();

        if ($check->num_rows > 0) {
            $errors[] = "Email is already registered.";
        } else {
            // Insert user
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("
                INSERT INTO users (fullname, email, password_hash, created_at)
                VALUES (?, ?, ?, NOW())
            ");
            $stmt->bind_param("sss", $fullname, $email, $password_hash);

            if ($stmt->execute()) {
                // REDIRECT TO MAIN PAGE AFTER SUCCESS
                header("Location: login.php");
                exit;
            } else {
                $errors[] = "Database error: " . $stmt->error;
            }

            $stmt->close();
        }

        $check->close();
    }
}
?>

<div class="page-header">
    <h1>Create Account</h1>
    <p>Register to start using Explore Jeddah.</p>
</div>

<div class="content-container">

    <?php if (!empty($success)): ?>
        <div class="success">
            <?php echo htmlspecialchars($success); ?>
        </div>
    <?php endif; ?>

    <?php if (!empty($errors)): ?>
        <div class="error">
            <ul>
                <?php foreach ($errors as $e): ?>
                    <li><?php echo htmlspecialchars($e); ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <form method="post" action="register.php" novalidate>

        <label for="fullname">Full Name</label><br>
        <input id="fullname" name="fullname" type="text" required><br>

        <label for="email">Email</label><br>
        <input id="email" name="email" type="email" required><br>

        <label for="password">Password</label><br>
        <input id="password" name="password" type="password" required><br>

        <label for="confirm">Confirm Password</label><br>
        <input id="confirm" name="confirm" type="password" required><br>

        <button type="submit">Register</button>
    </form>
</div>

<?php include __DIR__ . "/../includes/footer.php"; ?>
