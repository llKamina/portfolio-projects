<?php include "../includes/header.php"; ?>

<link rel="stylesheet" href="../css/style.css">

<div class="content-container">
    <h1>Photo Gallery</h1>

    <?php
    $folder = "../image/";
    $images = glob($folder . "*.{jpg,jpeg,png,gif}", GLOB_BRACE);
    ?>

    <!-- Large Image Viewer -->
    <div class="large-image-box">
        <img id="largeImage" src="<?php echo $images[0]; ?>" alt="Preview">
    </div>

    <div class="gallery-buttons">
        <button id="prevBtn">Previous</button>
        <button id="nextBtn">Next</button>
    </div>

    <!-- Thumbnail Strip -->
    <div class="thumb-strip">
        <?php
        foreach ($images as $i => $img) {
            echo "<img src='$img' class='thumb' data-index='$i' alt='Historical image of jeddah'>";
        }
        ?>
    </div>
</div>

<script>
let thumbnails = document.querySelectorAll(".thumb");
let largeImage = document.getElementById("largeImage");
let currentIndex = 0;

// Highlight active
function updateHighlight() {
    thumbnails.forEach(t => t.classList.remove("active-thumb"));
    thumbnails[currentIndex].classList.add("active-thumb");
}

// Click on thumbnail
thumbnails.forEach(t => {
    t.addEventListener("click", function () {
        currentIndex = parseInt(this.dataset.index);
        largeImage.src = this.src;
        updateHighlight();
    });
});

// Next / Prev
document.getElementById("nextBtn").onclick = () => {
    currentIndex = (currentIndex + 1) % thumbnails.length;
    largeImage.src = thumbnails[currentIndex].src;
    updateHighlight();
};

document.getElementById("prevBtn").onclick = () => {
    currentIndex = (currentIndex - 1 + thumbnails.length) % thumbnails.length;
    largeImage.src = thumbnails[currentIndex].src;
    updateHighlight();
};

// Set initial highlight
updateHighlight();
</script>

<?php include "../includes/footer.php"; ?>
