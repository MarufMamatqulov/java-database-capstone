# Schema design and stored procedures

This document outlines tables and stored procedures for the Smart Clinic Management System.

Tables (JPA entities map to these tables):
- users
- doctors
- patients
- appointments
- prescriptions

Stored procedures (MySQL):

1) GetDailyAppointmentsByDoctor

DELIMITER $$
CREATE PROCEDURE GetDailyAppointmentsByDoctor(IN doctorId BIGINT, IN refDate DATE)
BEGIN
  SELECT * FROM appointments
  WHERE doctor_id = doctorId
    AND DATE(appointment_date) = refDate;
END$$
DELIMITER ;

2) GetDoctorWithMostPatientsByMonth

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

3) GetDoctorWithMostPatientsByYear

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


Notes:
- Run these scripts in the MySQL database connected to the application.
- Consider creating indexes on appointment_date, doctor_id, patient_id for performance.
