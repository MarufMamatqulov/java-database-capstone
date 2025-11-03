package com.project.back_end.services;

import com.project.back_end.models.Appointment;
import com.project.back_end.models.Appointment.Status;
import com.project.back_end.repo.AppointmentRepository;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Service
public class AppointmentService {
    private final AppointmentRepository appointmentRepository;

    public AppointmentService(AppointmentRepository appointmentRepository) {
        this.appointmentRepository = appointmentRepository;
    }

    public Appointment book(Appointment appointment) {
        appointment.setStatus(Status.SCHEDULED);
        appointment.setCreatedAt(Instant.now());
        return appointmentRepository.save(appointment);
    }

    public Optional<Appointment> findById(Long id) { return appointmentRepository.findById(id); }

    public List<Appointment> findByPatientId(Long patientId) { return appointmentRepository.findByPatientId(patientId); }

    public List<Appointment> findByDoctorId(Long doctorId) { return appointmentRepository.findByDoctorId(doctorId); }

    public Appointment updateStatus(Long appointmentId, Status newStatus) {
        java.util.Optional<Appointment> opt = appointmentRepository.findById(appointmentId);
        if (opt.isEmpty()) throw new RuntimeException("Appointment not found");
        Appointment a = opt.get();
        a.setStatus(newStatus);
        return appointmentRepository.save(a);
    }

    public void cancel(Long appointmentId) {
        updateStatus(appointmentId, Status.CANCELLED);
    }

    public Appointment complete(Long appointmentId) { return updateStatus(appointmentId, Status.COMPLETED); }
}
