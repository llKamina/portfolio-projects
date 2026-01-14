<?php
$page_title = "Protected - Explore Jeddah";
include __DIR__ . "/../includes/header.php";

session_start();
if (empty($_SESSION['user_id'])) {
    // not logged in
    header('Location: login.php');
    exit;
}

$fullname = $_SESSION['fullname'] ?? 'User';
?>

<div class="page-header">
    <h1>Protected Content</h1>
    <p>Welcome, <?php echo htmlspecialchars($fullname); ?>. This page is for authenticated users only.</p>
</div>

<div class="content-container">
    <p>Here you can show exclusive information (for demo purposes).</p>

    <p><a href="logout.php">Log out</a></p>
</div>

<?php include __DIR__ . "/../includes/footer.php"; ?>
