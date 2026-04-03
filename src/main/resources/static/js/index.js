function login() {
    const role = document.getElementById("role").value;
    const username = document.getElementById("username").value;

    // simulação de token
    const token = btoa(username);

    if (role === "admin") {
        window.location.href = `/adminDashboard/${token}`;
    } else if (role === "doctor") {
        window.location.href = `/doctorDashboard/${token}`;
    } else {
        window.location.href = `/patientDashboard.html`;
    }
}