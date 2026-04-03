# Database Schema Design - Smart Clinic Management System

## 🗄️ MySQL Database Design

The relational database is used to store structured data such as users, doctors, patients, and appointments.

---

### 👨‍⚕️ Table: doctor

| Column Name | Data Type       | Constraints          |
|------------|----------------|----------------------|
| id         | BIGINT         | PRIMARY KEY, AUTO_INCREMENT |
| name       | VARCHAR(100)   | NOT NULL             |
| specialty  | VARCHAR(100)   | NOT NULL             |
| email      | VARCHAR(100)   | UNIQUE               |

---

### 🧑 Table: patient

| Column Name | Data Type       | Constraints          |
|------------|----------------|----------------------|
| id         | BIGINT         | PRIMARY KEY, AUTO_INCREMENT |
| name       | VARCHAR(100)   | NOT NULL             |
| email      | VARCHAR(100)   | UNIQUE               |
| phone      | VARCHAR(20)    |                      |

---

### 📅 Table: appointment

| Column Name       | Data Type       | Constraints                      |
|------------------|----------------|----------------------------------|
| id               | BIGINT         | PRIMARY KEY, AUTO_INCREMENT      |
| doctor_id        | BIGINT         | FOREIGN KEY REFERENCES doctor(id) |
| patient_id       | BIGINT         | FOREIGN KEY REFERENCES patient(id)|
| appointment_time | DATETIME       | NOT NULL                         |

---

### 👨‍💼 Table: admin

| Column Name | Data Type       | Constraints          |
|------------|----------------|----------------------|
| id         | BIGINT         | PRIMARY KEY, AUTO_INCREMENT |
| username   | VARCHAR(50)    | NOT NULL             |
| password   | VARCHAR(100)   | NOT NULL             |

---

## 📌 Relationships

- A doctor can have many appointments (1:N)
- A patient can have many appointments (1:N)
- Each appointment is linked to one doctor and one patient

---

## 🍃 MongoDB Collection Design

MongoDB is used for storing flexible document-based data such as prescriptions.

---

### 📄 Collection: prescriptions

#### Example Document:

```json
{
  "id": "presc_001",
  "patientName": "Maria",
  "doctorName": "Dr João",
  "medications": [
    {
      "name": "Paracetamol",
      "dosage": "500mg",
      "frequency": "Twice a day"
    },
    {
      "name": "Ibuprofen",
      "dosage": "200mg",
      "frequency": "Once a day"
    }
  ],
  "appointmentId": 1,
  "date": "2026-04-03"
}