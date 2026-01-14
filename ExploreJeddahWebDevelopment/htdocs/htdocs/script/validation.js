// script/validation.js
document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('feedbackForm');
    if (!form) return;

    form.addEventListener('submit', function (e) {
        const name = form.querySelector('#name').value.trim();
        const email = form.querySelector('#email').value.trim();
        const gender = form.querySelector('input[name="gender"]:checked');
        const visit = form.querySelector('#visit_type').value;
        const interests = form.querySelectorAll('input[name="interests[]"]:checked');

        let errors = [];

        if (!name) errors.push('Name is required.');
        if (!email || !/^\S+@\S+\.\S+$/.test(email)) errors.push('Valid email is required.');
        if (!gender) errors.push('Gender is required.');
        if (!visit) errors.push('Visit type is required.');
        if (interests.length === 0) errors.push('Select at least one interest.');

        if (errors.length > 0) {
            e.preventDefault();
            alert('Please fix the following errors:\n- ' + errors.join('\n- '));
        }
    }, false);
});
