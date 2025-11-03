package com.project.back_end.controllers;

import com.project.back_end.models.Patient;
import com.project.back_end.services.PatientService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/patients")
public class PatientController {
    private final PatientService patientService;

    public PatientController(PatientService patientService) {
        this.patientService = patientService;
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Patient p) { return ResponseEntity.ok(patientService.create(p)); }

    @GetMapping("/search")
    public ResponseEntity<List<?>> searchDoctors(@RequestParam String q) {
        return ResponseEntity.ok(patientService.searchDoctorsByName(q));
    }
}
