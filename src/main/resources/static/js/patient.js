function search() {
    const name = document.getElementById("search").value;

    fetch("/doctors")
        .then(res => res.json())
        .then(data => {
            const list = document.getElementById("results");
            list.innerHTML = "";

            data
                .filter(d => d.name.toLowerCase().includes(name.toLowerCase()))
                .forEach(d => {
                    list.innerHTML += `<li>${d.name} - ${d.specialty}</li>`;
                });
        });
}