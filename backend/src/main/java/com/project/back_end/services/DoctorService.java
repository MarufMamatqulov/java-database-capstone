package com.project.back_end.services;

import com.project.back_end.models.Appointment;
import com.project.back_end.models.Doctor;
import com.project.back_end.repo.AppointmentRepository;
import com.project.back_end.repo.DoctorRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
public class DoctorService {
    private final DoctorRepository doctorRepository;
    private final AppointmentRepository appointmentRepository;

    public DoctorService(DoctorRepository doctorRepository, AppointmentRepository appointmentRepository) {
        this.doctorRepository = doctorRepository;
        this.appointmentRepository = appointmentRepository;
    }

    public Doctor create(Doctor d) {
        return doctorRepository.save(d);
    }

    public Optional<Doctor> findById(Long id) { return doctorRepository.findById(id); }

    public List<Doctor> findAll() { return doctorRepository.findAll(); }

    public List<Doctor> findBySpecialty(String specialty) { return doctorRepository.findBySpecialty(specialty); }

    public List<Appointment> getDailyAppointments(Long doctorId, LocalDate date) {
        LocalDateTime start = LocalDateTime.of(date, LocalTime.MIN);
        LocalDateTime end = LocalDateTime.of(date, LocalTime.MAX);
        return appointmentRepository.findByAppointmentDateBetween(start, end).stream().filter(a->a.getDoctor().getId().equals(doctorId)).toList();
    }
}
