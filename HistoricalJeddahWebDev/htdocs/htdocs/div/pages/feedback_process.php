<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// pages/feedback_process.php
require_once __DIR__ . "/../database/db_connect.php";

function clean($v) {
    return trim($v);
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: feedback.php');
    exit;
}

// Collect and sanitize
$name = clean($_POST['name'] ?? '');
$email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
$gender = clean($_POST['gender'] ?? '');
$visit_type = clean($_POST['visit_type'] ?? '');
$interests_arr = $_POST['interests'] ?? [];
$rating = isset($_POST['rating']) ? (int) $_POST['rating'] : null;
$comments = clean($_POST['comments'] ?? '');

// Basic server-side validation
$errors = [];
if ($name === '') $errors[] = "Name is required.";
if (!$email) $errors[] = "A valid email is required.";
if ($gender === '') $errors[] = "Gender is required.";
if ($visit_type === '') $errors[] = "Visit type is required.";
if (!is_array($interests_arr) || count($interests_arr) === 0) $errors[] = "Select at least one interest.";

if (!empty($errors)) {
    // Could show errors on page; for simplicity redirect back with a session message
    session_start();
    $_SESSION['feedback_errors'] = $errors;
    header('Location: feedback.php');
    exit;
}

// Prepare interests as CSV
$interests = implode(", ", array_map('trim', $interests_arr));

// Check for existing email (must be unique)
$stmt = $conn->prepare("SELECT feedback_id FROM feedback WHERE email = ?");
$stmt->bind_param('s', $email);
$stmt->execute();
$stmt->store_result();
if ($stmt->num_rows > 0) {
    $stmt->close();
    session_start();
    $_SESSION['feedback_errors'] = ["This email has already submitted feedback."];
    header('Location: feedback.php');
    exit;
}
$stmt->close();

// Insert record
$insert = $conn->prepare("INSERT INTO feedback (name, email, gender, visit_type, interests, rating, comments) VALUES (?, ?, ?, ?, ?, ?, ?)");
$insert->bind_param('sssssis', $name, $email, $gender, $visit_type, $interests, $rating, $comments);

if ($insert->execute()) {
    session_start();
    $_SESSION['feedback_success'] = "Thank you — your feedback has been submitted.";
    $insert->close();
    header('Location: feedback.php');
    exit;
} else {
    // DB error
    session_start();
    $_SESSION['feedback_errors'] = ["Database error: " . $conn->error];
    $insert->close();
    header('Location: feedback.php');
    exit;
}
