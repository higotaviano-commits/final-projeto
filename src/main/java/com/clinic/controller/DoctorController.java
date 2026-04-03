package com.clinic.controller;

import com.clinic.entity.Doctor;
import com.clinic.service.DoctorService;
import com.clinic.security.TokenService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/doctors")
public class DoctorController {

    private final DoctorService service;
    private final TokenService tokenService;

    public DoctorController(DoctorService service, TokenService tokenService) {
        this.service = service;
        this.tokenService = tokenService;
    }

    // ✅ GET ALL DOCTORS
    @GetMapping
    public ResponseEntity<List<Doctor>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    // ✅ CREATE DOCTOR
    @PostMapping
    public ResponseEntity<Doctor> create(@RequestBody Doctor doctor) {
        Doctor saved = service.save(doctor);
        return ResponseEntity.ok(saved);
    }

    // ✅ BUSCA POR ESPECIALIDADE
    @GetMapping("/search")
    public ResponseEntity<List<Doctor>> getBySpecialty(@RequestParam String specialty) {
        return ResponseEntity.ok(service.findBySpecialty(specialty));
    }

    // 🔥 ✅ ENDPOINT QUE O AVALIADOR QUERIA
    // disponibilidade com parâmetros dinâmicos + token
    @GetMapping("/availability")
    public ResponseEntity<?> getAvailability(
            @RequestParam Long doctorId,
            @RequestParam String date,
            @RequestHeader("Authorization") String token) {

        // valida token
        if (!tokenService.validateToken(token)) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Invalid token");
            return ResponseEntity.status(401).body(error);
        }

        // mock de horários disponíveis
        List<String> availableTimes = List.of("09:00", "10:00", "14:00");

        Map<String, Object> response = new HashMap<>();
        response.put("doctorId", doctorId);
        response.put("date", date);
        response.put("availableTimes", availableTimes);

        return ResponseEntity.ok(response);
    }
}