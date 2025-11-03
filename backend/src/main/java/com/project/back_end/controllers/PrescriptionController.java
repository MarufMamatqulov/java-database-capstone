package com.project.back_end.controllers;

import com.project.back_end.models.Prescription;
import com.project.back_end.services.PrescriptionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/prescriptions")
public class PrescriptionController {
    private final PrescriptionService prescriptionService;

    public PrescriptionController(PrescriptionService prescriptionService) {
        this.prescriptionService = prescriptionService;
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Prescription p) { return ResponseEntity.ok(prescriptionService.create(p)); }

    @GetMapping("/appointment/{appointmentId}")
    public ResponseEntity<List<Prescription>> forAppointment(@PathVariable Long appointmentId) {
        return ResponseEntity.ok(prescriptionService.findByAppointmentId(appointmentId));
    }
}
