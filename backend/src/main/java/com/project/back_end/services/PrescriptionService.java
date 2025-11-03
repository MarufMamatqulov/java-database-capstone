package com.project.back_end.services;

import com.project.back_end.models.Prescription;
import com.project.back_end.repo.PrescriptionRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class PrescriptionService {
    private final PrescriptionRepository prescriptionRepository;

    public PrescriptionService(PrescriptionRepository prescriptionRepository) {
        this.prescriptionRepository = prescriptionRepository;
    }

    public Prescription create(Prescription p) {
        if (p.getPrescribedDate() == null) p.setPrescribedDate(LocalDate.now());
        return prescriptionRepository.save(p);
    }

    public Optional<Prescription> findById(Long id) { return prescriptionRepository.findById(id); }

    public List<Prescription> findByAppointmentId(Long appointmentId) { return prescriptionRepository.findByAppointmentId(appointmentId); }
}
