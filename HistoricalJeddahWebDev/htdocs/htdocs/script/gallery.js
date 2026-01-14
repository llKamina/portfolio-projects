// script/gallery.js
document.addEventListener('DOMContentLoaded', function () {
    const thumbs = document.querySelectorAll('.thumb');
    const large = document.getElementById('largeImage');

    thumbs.forEach(t => {
        t.addEventListener('click', function () {
            const src = this.getAttribute('data-large');
            if (src) {
                large.src = src;
                large.alt = this.alt || 'Large image';
            }
        });
    });
});
