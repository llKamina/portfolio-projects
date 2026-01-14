<?php
$host = "sql109.infinityfree.com";      
$user = "if0_40559812";                 
$pass = "ULT102939";                    
$dbname = "if0_40559812_exploredb";     

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
