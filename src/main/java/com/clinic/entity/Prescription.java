package com.clinic.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import jakarta.validation.constraints.*;

@Document(collection = "prescriptions")
public class Prescription {

    @Id
    private String id;

    @NotNull
    private String patientName;

    @NotNull
    private Long appointmentId;

    private String medication;

    private String doctorNotes;

    // getters e setters
}