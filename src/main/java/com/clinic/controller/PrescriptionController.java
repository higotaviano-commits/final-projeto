package com.clinic.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/prescriptions")
public class PrescriptionController {

    @PostMapping
    public ResponseEntity<String> create() {
        return ResponseEntity.ok("Prescription created");
    }
}