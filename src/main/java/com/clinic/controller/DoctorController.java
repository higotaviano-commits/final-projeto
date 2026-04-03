package com.clinic.controller;

import com.clinic.entity.Doctor;
import com.clinic.service.DoctorService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/doctors")
public class DoctorController {

    private final DoctorService service;

    public DoctorController(DoctorService service) {
        this.service = service;
    }

    @GetMapping
    public List<Doctor> getAll() {
        return service.findAll();
    }

    @PostMapping
    public Doctor create(@RequestBody Doctor doctor) {
        return service.save(doctor); // ✅ ESSENCIAL
    }

    @GetMapping("/search")
    public List<Doctor> getBySpecialty(@RequestParam String specialty) {
        return service.findBySpecialty(specialty);
    }
}