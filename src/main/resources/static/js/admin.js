function addDoctor() {
    const name = document.getElementById("name").value;
    const specialty = document.getElementById("specialty").value;

    fetch("/doctors", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({name, specialty})
    })
    .then(res => res.json()) // importante
    .then(() => loadDoctors()); // recarrega lista
}

function loadDoctors() {
    fetch("/doctors")
        .then(res => res.json())
        .then(data => {
            const list = document.getElementById("doctorList");
            list.innerHTML = "";

            data.forEach(d => {
                list.innerHTML += `<li>${d.name} - ${d.specialty}</li>`;
            });
        });
}

// 👉 carrega automaticamente ao abrir a página
window.onload = loadDoctors;