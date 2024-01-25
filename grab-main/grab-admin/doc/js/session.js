window.onload = function() {
    console.log(localStorage)
    const user = JSON.parse(localStorage.getItem('user')); // Get the user from sessionStorage
    if (!user) {
        // User is not logged in.
        window.location.href = '../index.html'; 
    }
};