-- Seed data for Smart Clinic

INSERT INTO users (username, password, email, role) VALUES
('admin','$2a$10$admin','admin@example.com','ADMIN'),
('doctor1','$2a$10$doc','doc1@example.com','DOCTOR'),
('patient1','$2a$10$p1','patient1@example.com','PATIENT'),
('patient2','$2a$10$p2','patient2@example.com','PATIENT'),
('patient3','$2a$10$p3','patient3@example.com','PATIENT'),
('patient4','$2a$10$p4','patient4@example.com','PATIENT'),
('patient5','$2a$10$p5','patient5@example.com','PATIENT');

-- Insert doctor (user_id = 2)
INSERT INTO doctors (user_id, first_name, last_name, specialty, phone, license_number)
VALUES (2, 'John', 'Doe', 'Cardiology', '+1234567890', 'LIC-001');

-- Insert patients (user_id 3..7)
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, phone, address, medical_history)
VALUES
(3, 'Alice', 'Smith', '1990-01-01', '+1111111111', '123 Main St', 'None'),
(4, 'Bob', 'Johnson', '1985-05-12', '+2222222222', '456 Oak Ave', 'Asthma'),
(5, 'Carol', 'Williams', '1978-03-22', '+3333333333', '789 Pine Rd', 'Diabetes'),
(6, 'David', 'Brown', '1992-07-07', '+4444444444', '321 Elm St', 'None'),
(7, 'Eve', 'Davis', '1988-11-30', '+5555555555', '654 Maple Ave', 'Hypertension');

-- Insert appointments (doctor_id = 1)
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status, reason)
VALUES
(1, 1, '2025-11-03 09:00:00', 'SCHEDULED', 'Checkup'),
(2, 1, '2025-11-03 10:00:00', 'SCHEDULED', 'Follow-up'),
(3, 1, '2025-11-04 11:00:00', 'SCHEDULED', 'Consultation'),
(4, 1, '2025-10-15 14:00:00', 'COMPLETED', 'Consultation'),
(5, 1, '2024-11-03 15:00:00', 'COMPLETED', 'Checkup');

-- Optionally add a prescription
INSERT INTO prescriptions (appointment_id, medication_name, dosage, frequency, duration, instructions, prescribed_date)
VALUES (4, 'MedA', '10mg', 'Once a day', '7 days', 'After meals', '2025-10-15');
