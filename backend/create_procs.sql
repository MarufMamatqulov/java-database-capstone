DELIMITER $$
CREATE PROCEDURE GetDailyAppointmentReportByDoctor(IN refDate DATE)
BEGIN
  SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
         TIME(a.appointment_date) AS appointment_time,
         a.status,
         CONCAT(p.first_name,' ',p.last_name) AS patient_name,
         p.phone AS patient_phone
  FROM appointments a
  JOIN doctors d ON a.doctor_id = d.id
  JOIN patients p ON a.patient_id = p.id
  WHERE DATE(a.appointment_date) = refDate
  ORDER BY d.last_name, d.first_name, appointment_time;
END$$
DELIMITER ;
