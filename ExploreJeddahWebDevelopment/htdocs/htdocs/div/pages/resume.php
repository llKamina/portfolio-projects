<?php
$page_title = "Resume - Explore Jeddah";
include __DIR__ . "/../includes/header.php";
?>

<div class="page-header">
    <h1>Resume</h1>
    <p>View the student's resume below.</p>
</div>

<div class="content-container">
    <object data="../resume/myresume.pdf" type="application/pdf" width="100%" height="700">
        <p>Your browser does not support embedded PDFs. <a href="../resume/myresume.pdf" target="_blank">Download the PDF</a>.</p>
    </object>
</div>

<?php include __DIR__ . "/../includes/footer.php"; ?>
