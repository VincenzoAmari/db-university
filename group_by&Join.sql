
/* 1. Contare quanti iscritti ci sono stati ogni anno */

SELECT YEAR(enrolment_date) AS anno, COUNT(*) AS numero_iscritti
FROM students
GROUP BY YEAR(enrolment_date)
ORDER BY anno;



/* 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio */

SELECT office_address AS edificio, COUNT(*) AS numero_insegnanti
FROM teachers
GROUP BY office_address
ORDER BY numero_insegnanti DESC;


/* 3. Calcolare la media dei voti di ogni appello d'esame */

SELECT AVG (vote), exam_id
FROM exam_student
GROUP BY exam_id;


/* 4. Contare quanti corsi di laurea ci sono per ogni dipartimento */

SELECT d.id AS department_id, d.name AS department_name, COUNT(deg.id) AS numero_corsi_di_laurea
FROM departments d
LEFT JOIN degrees deg ON d.id = deg.department_id
GROUP BY d.id, d.name
ORDER BY numero_corsi_di_laurea DESC;










/* 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia */

SELECT * 
FROM students
JOIN degrees ON students.degree_id = degrees.id
WHERE degrees.name = "Corso di Laurea in Economia";

/*2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze */

SELECT *
FROM degrees
JOIN departments ON degrees.department_id = departments.id
WHERE degrees.level = "Magistrale" AND departments.name = "Dipartimento di Neuroscienze";


-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)

SELECT *
FROM courses
JOIN course_teacher ON courses.id = course_teacher.course_id
JOIN teachers ON course_teacher.teacher_id = teachers.id
WHERE teachers.name = "Fulvio" AND teachers.surname = "Amato";

-- 4. Selezionare tutti gli studenti con il loro corso di laurea e dipartimento, ordinati per cognome e nome

SELECT students.name, students.surname, degrees.name AS corso_laurea, departments.name AS dipartimento
FROM students
JOIN degrees ON students.degree_id = degrees.id
JOIN departments ON degrees.department_id = departments.id
ORDER BY students.surname, students.name;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti

SELECT degrees.name AS corso_laurea, courses.name AS corso, teachers.name AS docente, teachers.surname AS cognome
FROM degrees
JOIN courses ON degrees.id = courses.degree_id
JOIN course_teacher ON courses.id = course_teacher.course_id
JOIN teachers ON course_teacher.teacher_id = teachers.id
ORDER BY degrees.name, courses.name;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (id=54)

SELECT DISTINCT teachers.name , teachers.surname
FROM teachers
JOIN course_teacher ON teachers.id = course_teacher.teacher_id
JOIN courses ON courses.id = course_teacher.courses_id
JOIN degrees ON courses.degree_id = degrees.id
JOIN departments ON degrees.department_id = departments.id
WHERE departments.name = "Dipartimento di Matematica";


-- 7. BONUS: Per ogni studente, selezionare il numero di tentativi per ogni esame e il voto massimo, filtrando quelli con voto minimo 18

SELECT students.*, courses.name, COUNT( exam_student.vote ) AS `numero tentativi`, MAX( exam_student.vote) AS `voto_massimo`
FROM students
JOIN exam_student ON students.id = exam_student.student_id
JOIN exams ON exam_student.exam_id = exams.id
JOIN courses ON exams.course_id = courses.id
GROUP BY students.id, courses.id
HAVING `voto_massimo` >= 18;