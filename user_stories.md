# User Stories for Smart Clinic Management System

## Admin
- As an Admin, I can log in and view a dashboard with system statistics (total doctors, patients, appointments).
- As an Admin, I can add a doctor (name, specialty, email, phone, license number).
- As an Admin, I can view, edit, and delete users (doctors and patients).
- As an Admin, I can view all appointments and filter by doctor, patient, date, and status.

## Doctor
- As a Doctor, I can log in and see today's appointments.
- As a Doctor, I can view patient profiles and medical history.
- As a Doctor, I can create prescriptions tied to an appointment.
- As a Doctor, I can mark appointments as completed and add notes.
- As a Doctor, I can search my patient list.

## Patient
- As a Patient, I can register and log in.
- As a Patient, I can search doctors by name or specialty.
- As a Patient, I can book an appointment with a doctor for a selected date/time and reason.
- As a Patient, I can view upcoming and past appointments.
- As a Patient, I can view prescriptions issued to me.


All roles:
- Authentication via JWT, role-based routes and UI.
- Profile management (view/edit basic profile information).
- Validation and friendly error messages.
