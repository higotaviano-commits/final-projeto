package com.clinic.service;

import com.clinic.entity.Appointment;
import com.clinic.repository.AppointmentRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AppointmentService {

    private final AppointmentRepository repository;

    public AppointmentService(AppointmentRepository repository) {
        this.repository = repository;
    }

    public List<Appointment> getByPatient(Long patientId) {
        return repository.findByPatientId(patientId);
    }

    public Appointment save(Appointment appointment) {
        return repository.save(appointment);
    }
}
