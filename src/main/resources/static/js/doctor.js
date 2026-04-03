function loadAppointments() {
    fetch("/appointments")
        .then(res => res.json())
        .then(data => {
            const list = document.getElementById("appointments");
            list.innerHTML = "";
            data.forEach(a => {
                list.innerHTML += `<li>Patient: ${a.patient?.name} - ${a.appointmentTime}</li>`;
            });
        });
}

window.onload = loadAppointments;