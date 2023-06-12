-- Patient

-- Show all Patient in the table
SELECT * FROM Patient;

-- Add a new Patient
INSERT INTO Patient (
    last_name, 
    first_name, 
    social_security, 
    date_of_birth, 
    address, 
    insurance, 
    phone_number, 
    primary_doctor)
VALUES (
    :last_name_input, 
    :first_name_input, 
    :social_security_input, 
    :date_of_birth_input, :address_input, 
    :insurance_input, 
    :phone_number_input, 
    :primary_doctor_input);

-- Edit a selected Patient
UPDATE Patient
SET last_name = :last_name_input, 
first_name = :first_name_input,
social_security = :social_security_input,
date_of_birth = :date_of_birth_input,
insurance = :insurance_input,
phone_numer = :phone_number_input,
primary_doctor = :primary_doctor_input,
WHERE patient_id = :patient_id_selected;

-- Delete a selected Patient
DELETE FROM Patient WHERE patient_id = :patient_id_selected;

-- Nurse

-- Show all Nurse in the table
SELECT * FROM Nurse;

-- Add a new Nurse
INSERT INTO Nurse (
    last_name, 
    first_name, 
    department_name,
    phone_number)
VALUES (
    :last_name_input, 
    :first_name_input,
    :department_name_input,
    :phone_number_input);

-- Show Departments in dropdown menu
SELECT department_name FROM Department;

-- Doctor

-- Show all Doctor in the table
SELECT * FROM Doctor;

-- Add a new Doctor
INSERT INTO Doctor (
    last_name, 
    first_name,
    specialty,
    department_name,
    phone_number)
VALUES (
    :last_name_input, 
    :first_name_input,
    :specialty_input,
    :department_name_input,
    :phone_number_input);

-- Show Departments in dropdown menu
SELECT department_name FROM Department;

-- Room

-- Show all Room in the table
SELECT * FROM Room;

-- Add a new Room
INSERT INTO Room (
    floor, 
    department_name)
VALUES (
    :floor_input,
    :department_name_input,
    :phone_number_input);

-- Show Departments in dropdown menu
SELECT department_name FROM Department;

-- Department

-- Show all Department in the table
SELECT * FROM Department;

-- Add a new Department
INSERT INTO Department ( 
    department_name,
    phone_number)
VALUES (
    :department_name_input,
    :phone_number_input);

-- Requisition

-- Show all Requisition in the table
SELECT * FROM Requisition;

-- Add a new Requisition
INSERT INTO Requisition ( 
    order,
    result)
VALUES (
    :order_input,
    :result_input);

-- Visit

-- Show all Visit in the table
SELECT * FROM Visit;

-- Show names, id from relationships for dropdown menus
SELECT first_name FROM Patient;
SELECT patient_id FROM Patient;
SELECT doctor_id FROM Doctor;
SELECT room_id FROM Room; 
SELECT requisition_id FROM Requisition;

-- Add a new Visit
INSERT INTO Visit ( 
    date,
    room_id,
    doctor_id,
    patient_id,
    height,
    weight,
    chief_complaint,
    vital_sign,
    physical_exam,
    requisition_id,
    treatment,
    diagnosis)
VALUES (
    :date_input,
    :room_id_input,
    :doctor_id_input,
    :patient_id_input,
    :height_input,
    :weight_input,
    :chief_complaint_input,
    :vital_sign_input,
    :physical_exam_input,
    :requisition_id_input,
    :treatment_input,
    :diagnosis_input);

-- Show Patient first names in dynamically populated dropdown menus
SELECT * FROM Visit WHERE 
                (SELECT Patient.patient_id FROM Patient 
                INNER JOIN Visit 
                ON Patient.patient_id = Visit.patient_id WHERE "${req.query.patient_name}" = first_name LIMIT 1) = patient_id;

-- Nurse_Visit

-- Show all Nurse_Visit in the table
SELECT * FROM Nurse_Visit;

-- Add a new Nurse_Visit
INSERT INTO Nurse_Visit ( 
    record_id,
    nurse_id)
VALUES (
    :record_id_input,
    :nurse_id_input);

-- Delete a selected Nurse_Visit
DELETE FROM Nurse_Visit WHERE nurse_id = :nurse_id_selected AND record_id = :record_id_selected;