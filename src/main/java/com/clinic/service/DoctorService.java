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

    public List<Doctor> findAll() {
        return repository.findAll();
    }

    public List<Doctor> findBySpecialty(String specialty) {
        return repository.findBySpecialty(specialty);
    }

    public Doctor save(Doctor doctor) {
        return repository.save(doctor);
    }


}