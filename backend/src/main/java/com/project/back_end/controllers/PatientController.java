package com.project.back_end.controllers;

import com.project.back_end.models.Patient;
import com.project.back_end.models.User;
import com.project.back_end.repo.UserRepository;
import com.project.back_end.services.PatientService;
import org.springframework.security.core.Authentication;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/patients")
public class PatientController {
    private final PatientService patientService;
    private final UserRepository userRepository;

    public PatientController(PatientService patientService, UserRepository userRepository) {
        this.patientService = patientService;
        this.userRepository = userRepository;
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Patient p) { return ResponseEntity.ok(patientService.create(p)); }

    @GetMapping("/search")
    public ResponseEntity<List<?>> searchDoctors(@RequestParam String q) {
        return ResponseEntity.ok(patientService.searchDoctorsByName(q));
    }

    @GetMapping("/me")
    public ResponseEntity<?> me(Authentication authentication) {
        String username = authentication.getName();
        java.util.Optional<User> u = userRepository.findByUsername(username);
        if (u.isEmpty()) return ResponseEntity.status(404).body(Map.of("error","user not found"));
        java.util.Optional<Patient> p = patientService.findByUserId(u.get().getId());
        return p.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.status(404).body(Map.of("error","patient not found")));
    }
}
