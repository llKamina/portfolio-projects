<nav>
    <div class="nav-container">
        <a href="/index.php">
            <img id="logo" src="/logo/logo.png" alt="Explore Jeddah logo">
        </a>

        <ul class="nav-menu">
            <li><a href="/index.php">Home</a></li>

            <li class="dropdown">
                <a href="#" class="dropbtn">Explore ▼</a>
                <div class="dropdown-content">
                    <a href="/pages/attractions.php">Attractions</a>
                    <a href="/pages/food.php">Food</a>
                    <a href="/pages/events.php">Events</a>
                </div>
            </li>

            <li class="dropdown">
                <a href="#" class="dropbtn">Plan Your Visit ▼</a>
                <div class="dropdown-content">
                    <a href="/pages/services.php">Services</a>
                    <a href="/pages/schedule.php">Schedule</a>
                    <a href="/pages/contact.php">Contact</a>
                </div>
            </li>

            <li class="dropdown">
                <a href="#" class="dropbtn">Media ▼</a>
                <div class="dropdown-content">
                    <a href="/pages/gallery.php">Gallery</a>
                    <a href="/pages/video.php">Video</a>
                </div>
            </li>

            <li><a href="/pages/feedback.php">Feedback</a></li>
            <li><a href="/pages/resume.php">Resume</a></li>

            <?php if (!isset($_SESSION['user_id'])): ?>
                <li><a href="/pages/login.php">Login</a></li>
                <li><a href="/pages/register.php">Register</a></li>
            <?php else: ?>
   				<li class="dropdown">
                <a href="#" class="dropbtn">Account▼</a>
                <div class="dropdown-content">
                    <a href="/pages/protected.php">Info</a>
                    <a href="/pages/logout.php">logout</a>
           
                </div>
            </li>
				
            <?php endif; ?>
        </ul>
    </div>
</nav>
