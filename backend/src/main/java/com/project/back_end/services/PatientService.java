package com.project.back_end.services;

import com.project.back_end.models.Doctor;
import com.project.back_end.models.Patient;
import com.project.back_end.repo.DoctorRepository;
import com.project.back_end.repo.PatientRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PatientService {
    private final PatientRepository patientRepository;
    private final DoctorRepository doctorRepository;

    public PatientService(PatientRepository patientRepository, DoctorRepository doctorRepository) {
        this.patientRepository = patientRepository;
        this.doctorRepository = doctorRepository;
    }

    public Patient create(Patient p) { return patientRepository.save(p); }
    public Optional<Patient> findById(Long id) { return patientRepository.findById(id); }
    public Optional<Patient> findByUserId(Long userId) { return patientRepository.findByUserId(userId); }

    public List<Doctor> searchDoctorsByName(String name) {
        // naive search across first or last name
        return doctorRepository.findAll().stream()
                .filter(d -> (d.getFirstName()+" "+d.getLastName()).toLowerCase().contains(name.toLowerCase()))
                .toList();
    }
}
