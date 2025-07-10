-- ==============================================================
-- VIEWS
-- ==============================================================

-- View para Grade Horária (RF05, RF10)
-- Exibe a grade horária detalhada de cada turma, incluindo disciplina, professor e sala.
CREATE VIEW vw_class_schedule AS
SELECT
    c.name AS class_name,
    c.academic_year,
    c.semester AS class_semester,
    s.name AS subject_name,
    u_teacher.first_name AS teacher_first_name,
    u_teacher.last_name AS teacher_last_name,
    GROUP_CONCAT(CONCAT(ts.day_of_week, ' ', TIME_FORMAT(ts.start_time, '%H:%i'), '-', TIME_FORMAT(ts.end_time, '%H:%i')) ORDER BY ts.day_of_week, ts.start_time SEPARATOR '; ') AS schedule_times,
    r.name AS room_name,
    r.localization AS room_localization
FROM
    class_schedules cs
JOIN
    classes c ON cs.class_id = c.id
JOIN
    subjects s ON cs.subject_id = s.id
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    users u_teacher ON t.staff_id = u_teacher.id
LEFT JOIN
    rooms r ON cs.room_id = r.id
LEFT JOIN
    time_slots ts ON JSON_CONTAINS(cs.time_slot_ids, JSON_ARRAY(ts.id))
GROUP BY
    c.name, c.academic_year, c.semester, s.name, u_teacher.first_name, u_teacher.last_name, r.name, r.localization
ORDER BY
    c.name, s.name;




-- View para Carga Horária dos Professores (RF10)
-- Exibe a carga horária total de cada professor com base nas disciplinas que leciona.
CREATE VIEW vw_teacher_workload AS
SELECT
    u.first_name AS teacher_first_name,
    u.last_name AS teacher_last_name,
    SUM(s.workload_hours) AS total_workload_hours
FROM
    class_schedules cs
JOIN
    subjects s ON cs.subject_id = s.id
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    users u ON t.staff_id = u.id
GROUP BY
    u.first_name, u.last_name
ORDER BY
    total_workload_hours DESC;




-- View para Custos (RF10)
-- Exibe um resumo dos custos relacionados às propinas dos estudantes.
CREATE VIEW vw_student_fees_summary AS
SELECT
    s.student_number,
    u.first_name AS student_first_name,
    u.last_name AS student_last_name,
    c.name AS course_name,
    cf.amount AS course_fee_amount,
    sf.reference_month,
    sf.status AS payment_status,
    p.amount AS paid_amount,
    p.payment_date AS payment_date
FROM
    studant_fees sf
JOIN
    students s ON sf.student_id = s.user_id
JOIN
    users u ON s.user_id = u.id
JOIN
    course_fees cf ON sf.course_fee_id = cf.id
JOIN
    courses c ON cf.course_id = c.id
LEFT JOIN
    payments p ON sf.payment_id = p.id
ORDER BY
    s.student_number, sf.reference_month;
