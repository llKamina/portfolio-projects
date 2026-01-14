<?php
$page_title = "Schedule - Explore Jeddah";
include __DIR__ . "/../includes/header.php";
require_once __DIR__ . "/../database/db_connect.php";
?>

<div class="page-header">
    <h1>Guided Tours Schedule</h1>
    <p>Dynamic schedule pulled from the database. Use print option to print only the table.</p>
</div>

<div class="content-container">
    <?php
    // Fetch schedule data ordered by day
    $res = $conn->query("SELECT schedule_id, day, time_slot, event, guide_name FROM schedule ORDER BY FIELD(day,'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'), time_slot");
    $rows = $res->fetch_all(MYSQLI_ASSOC);
    if (!$rows) {
        echo "<p>No schedule available.</p>";
    } else {
        // Group by day to compute rowspan
        $grouped = [];
        foreach ($rows as $r) {
            $grouped[$r['day']][] = $r;
        }

        echo '<table id="schedule-table">';
        // example header with colspan across two columns
        echo '<caption>Weekly Guided Tours</caption>';
        echo '<thead>';
        echo '<tr><th>Day</th><th colspan="2">Details (Time & Event)</th><th>Guide</th></tr>';
        echo '</thead><tbody>';

        foreach ($grouped as $day => $items) {
            $rowspan = count($items);
            $first = true;
            foreach ($items as $it) {
                echo '<tr>';
                if ($first) {
                    // Day cell with rowspan
                    echo '<td rowspan="' . $rowspan . '">' . htmlspecialchars($day) . '</td>';
                    $first = false;
                }
                // Time and event in a single cell (colspan demonstration)
                echo '<td>' . htmlspecialchars($it['time_slot']) . '</td>';
                echo '<td>' . htmlspecialchars($it['event']) . '</td>';
                echo '<td>' . htmlspecialchars($it['guide_name']) . '</td>';
                echo '</tr>';
            }
        }

        echo '</tbody></table>';
        echo '<p><button id="printBtn" onclick="window.print()">Print Table</button></p>';
    }
    ?>
</div>

<?php include __DIR__ . "/../includes/footer.php"; ?>
