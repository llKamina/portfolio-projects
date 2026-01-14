<?php
// Start session for login system 
if (!session_id()) { 
    session_start();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><?php echo $page_title ?? "Explore Jeddah"; ?></title>

    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/print.css" media="print">
</head>

<body>
    <?php include __DIR__ . "/navigation.php"; ?>
