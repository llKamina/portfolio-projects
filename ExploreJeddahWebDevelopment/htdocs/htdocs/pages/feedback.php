<?php
session_start();
$page_title = "Feedback - Explore Jeddah";
include __DIR__ . "/../includes/header.php";

$errors = $_SESSION['feedback_errors'] ?? [];
$success = $_SESSION['feedback_success'] ?? '';
unset($_SESSION['feedback_errors']);
unset($_SESSION['feedback_success']);

// Get the error/success message as a JavaScript variable
$errorMessage = !empty($errors) ? implode("\\n", $errors) : '';
$successMessage = $success ? $success : '';
?>

<div class="page-header">
    <h1>Feedback</h1>
    <p>We appreciate your feedback — please fill the form below.</p>
</div>

<div class="content-container">
    <form id="feedbackForm" action="feedback_process.php" method="post" novalidate>
        <fieldset>
            <legend>Personal Info</legend>
            <label for="name">Full Name <span>*</span></label><br>
            <input type="text" id="name" name="name" required><br>
            <label for="email">Email <span>*</span></label><br>
            <input type="email" id="email" name="email" required><br>
            <label>Gender <span>*</span></label><br>
            <input type="radio" id="gender_m" name="gender" value="Male" required>
            <label for="gender_m">Male</label>
            <input type="radio" id="gender_f" name="gender" value="Female">
            <label for="gender_f">Female</label><br>
        </fieldset>
        <fieldset>
            <legend>Visit Info</legend>
            <label for="visit_type">Type of Visit <span>*</span></label><br>
            <select id="visit_type" name="visit_type" required>
                <option value="">-- Choose --</option>
                <option value="Tourist">Tourist</option>
                <option value="Business">Business</option>
                <option value="Resident">Resident</option>
            </select><br>
            <label>Interests (select at least one) <span>*</span></label><br>
            <input type="checkbox" id="int_food" name="interests[]" value="Food">
            <label for="int_food">Food</label>
            <input type="checkbox" id="int_culture" name="interests[]" value="Culture">
            <label for="int_culture">Culture</label>
            <input type="checkbox" id="int_beach" name="interests[]" value="Beaches">
            <label for="int_beach">Beaches</label><br>
            <label for="rating">Rate our site (1-5)</label><br>
            <input type="number" id="rating" name="rating" min="1" max="5"><br>
            <label for="comments">Comments</label><br>
            <textarea id="comments" name="comments" rows="5"></textarea><br>
        </fieldset>
        <button type="submit">Submit Feedback</button>
    </form>
</div>

<script src="../script/validation.js"></script>

<script>
// Show server-side error/success messages on page load
window.addEventListener('DOMContentLoaded', function() {
    <?php if ($errorMessage): ?>
        alert(<?php echo json_encode($errorMessage); ?>);
    <?php endif; ?>
    
    <?php if ($successMessage): ?>
        alert(<?php echo json_encode($successMessage); ?>);
    <?php endif; ?>
});
</script>

<?php include __DIR__ . "/../includes/footer.php"; ?>