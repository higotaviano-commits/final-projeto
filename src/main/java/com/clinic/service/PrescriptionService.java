package com.clinic.service;

import com.clinic.entity.Prescription;
import com.clinic.repository.PrescriptionRepository;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PrescriptionService {

    private final PrescriptionRepository repository;

    public PrescriptionService(PrescriptionRepository repository) {
        this.repository = repository;
    }

    // ✅ Criar prescrição
    public Prescription createPrescription(Prescription prescription) {
        return repository.save(prescription);
    }

    // ✅ Buscar por paciente
    public List<Prescription> getPrescriptionsByPatient(String patientName) {
        return repository.findByPatientName(patientName);
    }

    // 🔥 Buscar por consulta (importante)
    public List<Prescription> getPrescriptionsByAppointment(Long appointmentId) {
        return repository.findByAppointmentId(appointmentId);
    }

    // ✅ Listar todas
    public List<Prescription> getAll() {
        return repository.findAll();
    }
}