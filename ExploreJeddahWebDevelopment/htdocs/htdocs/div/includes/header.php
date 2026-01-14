<?php
    // Start session for login system 
 if (!session_id()) { session_start();
                     }
?>
<!DOCTYPE html> 
<html>
    <head>
        <title><?php echo $page_title ?? "Explore Jeddah"; ?></title>
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/print.css" media="print"> 
        </head>
    <body>
        <?php include("navigation.php"); ?>