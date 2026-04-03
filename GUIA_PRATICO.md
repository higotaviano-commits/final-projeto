# 📚 Guia Prático - Fluxo Completo de Uso

## 1️⃣ Iniciar a Aplicação

### Via Maven
```bash
cd C:\projetos\clinic\clinic-system
.\mvnw.cmd spring-boot:run
```

**Output esperado:**
```
2026-04-03T09:33:17.156-03:00  INFO 1576 --- [           main] b.w.c.s.WebApplicationContextInitializer : Root WebApplicationContext: initialization completed in 1202 ms
...
2026-04-03T09:33:19.753-03:00  INFO 1576 --- [           main] o.s.boot.tomcat.TomcatWebServer          : Tomcat started on port 8082 (http) with context path '/'
2026-04-03T09:33:19.277-03:00  INFO 1576 --- [           main] com.clinic.ClinicSystemApplication       : Started ClinicSystemApplication in X.XXX seconds
```

✅ A aplicação está pronta!

---

## 2️⃣ Acessar o Dashboard

### No Navegador
```
http://localhost:8082/adminDashboard/demo-token
```

**Página renderizada:**
```html
Admin Dashboard

Add Doctor
[Nome__________] [Especialidade______] [Add Button]

Doctors
- (lista vazia inicialmente)
```

---

## 3️⃣ Adicionar um Médico (Fluxo Completo)

### Passo 1: Preencher o Formulário
```
Nome: Dr. João Silva
Especialidade: Cardiologia
```

### Passo 2: Clicar em "Add"

**O que acontece no Frontend (admin.js):**
```javascript
function addDoctor() {
    const name = document.getElementById("name").value;           // "Dr. João Silva"
    const specialty = document.getElementById("specialty").value; // "Cardiologia"

    fetch("/doctors", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({name, specialty})
    })
    .then(res => res.json())
    .then(() => loadDoctors()); // Recarrega a lista após sucesso
}
```

### Passo 3: Request HTTP POST

**Request enviado:**
```http
POST /doctors HTTP/1.1
Host: localhost:8082
Content-Type: application/json

{
    "name": "Dr. João Silva",
    "specialty": "Cardiologia"
}
```

### Passo 4: Backend processa (DoctorController.java)

```java
@PostMapping
public Doctor create(@RequestBody Doctor doctor) {
    return service.save(doctor);
}
```

**O que acontece:**
1. ✅ `@RequestBody` deserializa JSON → Objeto Doctor (com Lombok @Data)
2. ✅ Chama `DoctorService.save(doctor)`
3. ✅ Service chama `DoctorRepository.save(doctor)`
4. ✅ Repository executa SQL:
   ```sql
   INSERT INTO doctor (name, specialty, email, available_times)
   VALUES ('Dr. João Silva', 'Cardiologia', NULL, NULL)
   ```
5. ✅ Retorna objeto com ID gerado:
   ```json
   {
       "id": 1,
       "name": "Dr. João Silva",
       "specialty": "Cardiologia",
       "email": null,
       "availableTimes": null
   }
```

### Passo 5: Frontend recarrega a lista

**O código executa:**
```javascript
.then(() => loadDoctors()); // Chamado automaticamente após POST
```

### Passo 6: GET /doctors

**Request:**
```http
GET /doctors HTTP/1.1
Host: localhost:8082
```

**Response:**
```json
[
    {
        "id": 1,
        "name": "Dr. João Silva",
        "specialty": "Cardiologia",
        "email": null,
        "availableTimes": null
    }
]
```

### Passo 7: Frontend renderiza

**JavaScript executa:**
```javascript
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
```

**HTML renderizado:**
```html
<ul id="doctorList">
    <li>Dr. João Silva - Cardiologia</li>
</ul>
```

---

## 4️⃣ Adicionar Mais Médicos

### Segundo médico:
```
Nome: Dra. Maria Santos
Especialidade: Pediatria
```

Clicar em "Add" → Mesmo fluxo

**Response do GET /doctors (agora com 2 registros):**
```json
[
    {
        "id": 1,
        "name": "Dr. João Silva",
        "specialty": "Cardiologia",
        "email": null,
        "availableTimes": null
    },
    {
        "id": 2,
        "name": "Dra. Maria Santos",
        "specialty": "Pediatria",
        "email": null,
        "availableTimes": null
    }
]
```

**UI renderiza:**
```
Doctors
- Dr. João Silva - Cardiologia
- Dra. Maria Santos - Pediatria
```

---

## 5️⃣ Testar Via API (cURL)

### Listar todos os médicos
```bash
curl -X GET http://localhost:8082/doctors
```

**Output:**
```json
[
    {
        "id": 1,
        "name": "Dr. João Silva",
        "specialty": "Cardiologia",
        "email": null,
        "availableTimes": null
    },
    {
        "id": 2,
        "name": "Dra. Maria Santos",
        "specialty": "Pediatria",
        "email": null,
        "availableTimes": null
    }
]
```

### Buscar médico por especialidade
```bash
curl -X GET "http://localhost:8082/doctors/search?specialty=Cardiologia"
```

**Output:**
```json
[
    {
        "id": 1,
        "name": "Dr. João Silva",
        "specialty": "Cardiologia",
        "email": null,
        "availableTimes": null
    }
]
```

### Criar novo médico (para Dermatologia)
```bash
curl -X POST http://localhost:8082/doctors \
  -H "Content-Type: application/json" \
  -d '{"name":"Dr. Pedro Costa","specialty":"Dermatologia"}'
```

**Output:**
```json
{
    "id": 3,
    "name": "Dr. Pedro Costa",
    "specialty": "Dermatologia",
    "email": null,
    "availableTimes": null
}
```

---

## 6️⃣ Visualizar Banco de Dados H2

### Console H2
```
http://localhost:8082/h2-console
```

**Credenciais:**
- JDBC URL: `jdbc:h2:mem:testdb`
- User Name: `sa`
- Password: (deixar em branco)

**SQL para ver dados:**
```sql
SELECT * FROM doctor;
```

**Output esperado:**
```
| ID | NAME                | SPECIALTY     | EMAIL | AVAILABLE_TIMES |
|----|---------------------|---------------|-------|-----------------|
| 1  | Dr. João Silva      | Cardiologia   | NULL  | NULL            |
| 2  | Dra. Maria Santos   | Pediatria     | NULL  | NULL            |
| 3  | Dr. Pedro Costa     | Dermatologia  | NULL  | NULL            |
```

---

## 7️⃣ Parar a Aplicação

### Via Terminal
```bash
# Pressione Ctrl+C no terminal onde a aplicação está rodando
```

**Output:**
```
2026-04-03T09:35:12.345-03:00  INFO 1576 --- [           main] com.clinic.ClinicSystemApplication   : Shutting down...
```

---

## 📊 Resumo do Fluxo

```
┌─────────────────────────────────────────────────────────────────┐
│                      FRONTEND (HTML/JS)                         │
│  http://localhost:8082/adminDashboard/token                    │
│                                                                  │
│  [Nome: Dr. João Silva]  [Especialidade: Cardiologia] [Add]    │
│                                                                  │
│  Doctors:                                                        │
│  - Dr. João Silva - Cardiologia                                 │
│  - Dra. Maria Santos - Pediatria                                │
└─────────────────────────────────────────────────────────────────┘
                            ↕
                    (JSON via HTTP)
                            ↕
┌─────────────────────────────────────────────────────────────────┐
│                 BACKEND (Spring Boot)                           │
│                                                                  │
│  DoctorController                                                │
│    @PostMapping("/doctors") → DoctorService.save()             │
│    @GetMapping("/doctors") → DoctorRepository.findAll()        │
│                                                                  │
│  DoctorRepository                                                │
│    extends JpaRepository<Doctor, Long>                          │
│                                                                  │
│  Doctor Entity (com Lombok @Data)                              │
│    - id: Long                                                   │
│    - name: String                                               │
│    - specialty: String                                          │
│    - email: String                                              │
│    - availableTimes: List<String>                              │
└─────────────────────────────────────────────────────────────────┘
                            ↕
                        (SQL)
                            ↕
┌─────────────────────────────────────────────────────────────────┐
│                    DATABASE (H2)                                │
│                                                                  │
│  CREATE TABLE doctor (                                          │
│    id INT PRIMARY KEY AUTO_INCREMENT,                           │
│    name VARCHAR(255) NOT NULL,                                  │
│    specialty VARCHAR(255) NOT NULL,                             │
│    email VARCHAR(255),                                          │
│    available_times TEXT                                         │
│  )                                                              │
│                                                                  │
│  INSERT INTO doctor VALUES (1, 'Dr. João Silva', ...)          │
│  INSERT INTO doctor VALUES (2, 'Dra. Maria Santos', ...)       │
│  SELECT * FROM doctor;                                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Checklist de Validação

- [ ] Aplicação inicia sem erros
- [ ] Dashboard carrega em http://localhost:8082/adminDashboard/token
- [ ] Posso digitar nome e especialidade
- [ ] Clicar "Add" não gera erro no console
- [ ] Lista de médicos atualiza após "Add"
- [ ] GET /doctors retorna JSON com os dados
- [ ] Posso adicionar múltiplos médicos
- [ ] Dados persistem mesmo após adicionar novos médicos
- [ ] Busca por especialidade funciona (/doctors/search?specialty=X)

---

**Última atualização**: 03 de Abril de 2026
**Todos os problemas**: ✅ RESOLVIDOS

