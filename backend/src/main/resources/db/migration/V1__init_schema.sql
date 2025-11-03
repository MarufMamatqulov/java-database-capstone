-- Initial schema for Smart Clinic Management System

CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(200) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  role ENUM('ADMIN','DOCTOR','PATIENT') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE doctors (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(150) NOT NULL,
  phone VARCHAR(50),
  license_number VARCHAR(100) UNIQUE,
  CONSTRAINT fk_doctor_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE patients (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  phone VARCHAR(50),
  address TEXT,
  medical_history TEXT,
  CONSTRAINT fk_patient_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE appointments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  patient_id BIGINT NOT NULL,
  doctor_id BIGINT NOT NULL,
  appointment_date DATETIME NOT NULL,
  status ENUM('SCHEDULED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
  reason TEXT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
  CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE prescriptions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  appointment_id BIGINT NOT NULL,
  medication_name VARCHAR(200) NOT NULL,
  dosage VARCHAR(100),
  frequency VARCHAR(100),
  duration VARCHAR(100),
  instructions TEXT,
  prescribed_date DATE,
  CONSTRAINT fk_prescription_appointment FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Indexes
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);

-- Stored Procedures
DELIMITER $$
CREATE PROCEDURE GetDailyAppointmentsByDoctor(IN doctorId BIGINT, IN refDate DATE)
BEGIN
  SELECT * FROM appointments
  WHERE doctor_id = doctorId
    AND DATE(appointment_date) = refDate;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE GetDoctorWithMostPatientsByMonth(IN inMonth INT, IN inYear INT)
BEGIN
  SELECT d.id as doctor_id, d.first_name, d.last_name, COUNT(DISTINCT a.patient_id) as unique_patients
  FROM appointments a
  JOIN doctors d ON a.doctor_id = d.id
  WHERE MONTH(a.appointment_date) = inMonth AND YEAR(a.appointment_date) = inYear
  GROUP BY d.id
  ORDER BY unique_patients DESC
  LIMIT 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE GetDoctorWithMostPatientsByYear(IN inYear INT)
BEGIN
  SELECT d.id as doctor_id, d.first_name, d.last_name, COUNT(DISTINCT a.patient_id) as unique_patients
  FROM appointments a
  JOIN doctors d ON a.doctor_id = d.id
  WHERE YEAR(a.appointment_date) = inYear
  GROUP BY d.id
  ORDER BY unique_patients DESC
  LIMIT 1;
END$$
DELIMITER ;
