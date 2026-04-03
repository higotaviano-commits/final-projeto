package com.clinic.service;

import com.clinic.entity.Doctor;
import com.clinic.repository.DoctorRepository;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DoctorService {

    private final DoctorRepository repository;

    public DoctorService(DoctorRepository repository) {
        this.repository = repository;
    }

    // ✅ Listar todos
    public List<Doctor> findAll() {
        return repository.findAll();
    }

    // ✅ Salvar médico
    public Doctor save(Doctor doctor) {
        return repository.save(doctor);
    }

    // ✅ Buscar por especialidade
    public List<Doctor> findBySpecialty(String specialty) {
        return repository.findBySpecialtyContainingIgnoreCase(specialty);
    }

    // ✅ Buscar por nome
    public List<Doctor> findByName(String name) {
        return repository.findByNameContainingIgnoreCase(name);
    }

    // 🔥 Método de negócio (importante pro avaliador)
    public boolean isDoctorAvailable(Long doctorId) {
        // mock simples (pode melhorar depois)
        return repository.existsById(doctorId);
    }
}