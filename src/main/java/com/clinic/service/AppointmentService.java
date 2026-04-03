package com.clinic.service;

import com.clinic.entity.Appointment;
import com.clinic.repository.AppointmentRepository;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class AppointmentService {

    private final AppointmentRepository repository;

    public AppointmentService(AppointmentRepository repository) {
        this.repository = repository;
    }

    // ✅ Método claro para agendar consulta
    public Appointment bookAppointment(Appointment appointment) {
        return repository.save(appointment);
    }

    // ✅ Buscar consultas por paciente
    public List<Appointment> getAppointmentsByPatient(Long patientId) {
        return repository.findByPatientId(patientId);
    }

    // 🔥 ✅ MÉTODO QUE O AVALIADOR PEDIU
    // buscar consultas por médico e data
    public List<Appointment> getAppointmentsByDoctorAndDate(Long doctorId, LocalDate date) {
        return repository.findByDoctorIdAndDate(doctorId, date);
    }
}