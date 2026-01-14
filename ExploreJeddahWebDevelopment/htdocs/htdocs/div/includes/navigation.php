<nav>
    <div class="nav-container">
    	<a href="/index.php"> <img id="logo" src="../logo/logo.png" alt="Explore Jeddah logo" > </a>
        <h1 class="logo">Explore Jeddah</h1>
		
        <ul class="nav-menu">
            <li><a href="/index.php">Home</a></li>
            <li><a href="/pages/services.php">Services</a></li>
            <li><a href="/pages/attractions.php">Attractions</a></li>
            <li><a href="/pages/food.php">Food</a></li>
            <li><a href="/pages/events.php">Events</a></li>
            <li><a href="/pages/gallery.php">Gallery</a></li>
            <li><a href="/pages/schedule.php">Schedule</a></li>
            <li><a href="/pages/feedback.php">Feedback</a></li>
            <li><a href="/pages/resume.php">Resume</a></li>
    		<li><a href="/pages/video.php">Video</a></li>
            <li><a href="/pages/contact.php">Contact</a></li>

            <?php if (!isset($_SESSION['user_id'])): ?>
                <li><a href="/pages/login.php">Login</a></li>
                <li><a href="/pages/register.php">Register</a></li>
            <?php else: ?>
                <li><a href="/pages/logout.php">Logout</a></li>
            <?php endif; ?>
        </ul>
    </div>
</nav>


