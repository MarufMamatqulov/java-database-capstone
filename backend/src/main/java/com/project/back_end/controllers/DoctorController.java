package com.project.back_end.controllers;

import com.project.back_end.models.Doctor;
import com.project.back_end.models.Appointment;
import com.project.back_end.services.DoctorService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/doctors")
public class DoctorController {
    private final DoctorService doctorService;

    public DoctorController(DoctorService doctorService) {
        this.doctorService = doctorService;
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Doctor d) { return ResponseEntity.ok(doctorService.create(d)); }

    @GetMapping
    public ResponseEntity<List<Doctor>> list() { return ResponseEntity.ok(doctorService.findAll()); }

    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@PathVariable Long id) {
        return doctorService.findById(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/appointments")
    public ResponseEntity<List<Appointment>> getDailyAppointments(@PathVariable Long id,
                                                                  @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        java.util.List<Appointment> appts = doctorService.getDailyAppointments(id, date);
        return ResponseEntity.ok(appts);
    }
}
