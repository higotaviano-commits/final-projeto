package com.clinic.repository;

import com.clinic.entity.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PatientRepository extends JpaRepository<Patient, Long> {

    // ✅ Buscar paciente por email (importante)
    Optional<Patient> findByEmail(String email);

    // ✅ Buscar pacientes por nome (parcial)
    List<Patient> findByNameContainingIgnoreCase(String name);

    // 🔥 Buscar por telefone (extra)
    Optional<Patient> findByPhone(String phone);
}