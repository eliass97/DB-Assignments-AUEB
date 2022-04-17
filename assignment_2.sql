FROM all_data
WHERE appointment IS NOT NULL;

INSERT INTO appointmentrelations(appointment_id,medicine_id,datefrom,equipment_id,employee_id,main_doctor)
SELECT DISTINCT appointment,IFNULL(medicine_id,'0'),IFNULL(medicine_price_datefrom,'1980/01/01'),IFNULL(equipment_id,'0'),doctor_id,main_doctor
FROM all_data
WHERE appointment IS NOT NULL AND doctor_id IS NOT NULL;

SELECT id,employee_name AS name,employee_surname AS surname,salary
FROM employee
ORDER BY salary DESC
LIMIT 10

SELECT DISTINCT id,employee_name AS name,employee_surname AS surname,COUNT(appointmentrelations.employee_id) AS total
FROM employee,appointmentrelations
WHERE employee.id = appointmentrelations.employee_id
GROUP BY employee.id
ORDER BY COUNT(appointmentrelations.employee_id) DESC
LIMIT 1

SELECT id,serialno AS serial_number,model,check_date
FROM equipment
WHERE check_date <= LAST_DAY(CURDATE())

SELECT id,medicine_name,company_name,COUNT(id) AS total
FROM medicine,appointmentrelations
WHERE medicine.id = appointmentrelations.medicine_id AND id != 0
GROUP BY id
ORDER BY COUNT(id) DESC
LIMIT 1

SELECT equipment.id,equipment.model,equipment.serialno AS serial_number,(COUNT(DISTINCT appointment_id))/(DATEDIFF(CURDATE(),(equipment.release_date))) AS ratio
FROM equipment,appointmentrelations
WHERE equipment.id = appointmentrelations.equipment_id AND equipment_id != 0
GROUP BY equipment_id
ORDER BY ratio DESC
LIMIT 1

SELECT id,name,surname,appointment_id,MAX(cost) AS cost
FROM (
SELECT pa.*,appointment_id,IFNULL(SUM(DISTINCT mepr.price),0)+IFNULL(SUM(DISTINCT eq.usage_cost),0) AS cost
FROM patient AS pa,appointment AS ap, appointmentrelations AS apre,medicineprice AS mepr,equipment AS eq
WHERE pa.id = ap.patient_id AND ap.id = apre.appointment_id AND apre.medicine_id = mepr.medicine_id AND apre.equipment_id = eq.id AND apre.datefrom = mepr.datefrom
GROUP BY appointment_id
ORDER BY cost DESC
) AS AllCostsPerPatient
GROUP BY id
ORDER BY cost DESC
LIMIT 20

SELECT patient.id,patient.name,patient.surname,SUM(cost) AS cost
FROM patient,(
SELECT pa.*,appointment_id,IFNULL(SUM(DISTINCT mepr.price),0)+IFNULL(SUM(DISTINCT eq.usage_cost),0) AS cost
FROM patient AS pa,appointment AS ap, appointmentrelations AS apre,medicineprice AS mepr,equipment AS eq
WHERE pa.id = ap.patient_id AND ap.id = apre.appointment_id AND apre.medicine_id = mepr.medicine_id AND apre.equipment_id = eq.id AND apre.datefrom = mepr.datefrom
GROUP BY appointment_id
ORDER BY cost DESC
) AS AllCostsPerPatient
WHERE patient.id = AllCostsPerPatient.id
GROUP BY id
ORDER BY cost DESC
LIMIT 20
