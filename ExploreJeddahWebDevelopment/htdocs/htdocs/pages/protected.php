<?php
    session_start();
$page_title = "Protected - Explore Jeddah";
include __DIR__ . "/../includes/header.php";


if (empty($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}

$fullname = $_SESSION['fullname'] ?? 'User';
$email = $_SESSION['email'] ?? 'Unknown';
?>

<div class="page-header">
    <h1>Protected Content</h1>
    <p>Welcome, <?php echo htmlspecialchars($fullname); ?>. This page is for authenticated users only.</p>
</div>

<div class="content-container">

    <h2>Your Profile Information</h2>

    <p><strong>Full Name:</strong> <?php echo htmlspecialchars($fullname); ?></p>
    <p><strong>Email:</strong> <?php echo htmlspecialchars($email); ?></p>

    <p><a href="logout.php">Log out</a></p>
</div>

<?php include __DIR__ . "/../includes/footer.php"; ?>
