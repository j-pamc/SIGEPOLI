-- ==============================================================
-- CONSULTAS DE TESTE
-- ==============================================================

-- 1. Selecionar todos os usuários
SELECT * FROM users;

-- 2. Selecionar todos os departamentos e seus chefes
SELECT d.name AS department_name, u.first_name, u.last_name
FROM departments d
LEFT JOIN staff s ON d.head_staff_id = s.user_id
LEFT JOIN users u ON s.user_id = u.id;

-- 3. Selecionar todos os cursos e seus coordenadores
SELECT c.name AS course_name, u.first_name, u.last_name
FROM courses c
JOIN staff s ON c.coordinator_staff_id = s.user_id
JOIN users u ON s.user_id = u.id;

-- 4. Selecionar disciplinas de um curso específico (Engenharia Informática)
SELECT s.name AS subject_name, cs.semester
FROM course_subjects cs
JOIN subjects s ON cs.subject_id = s.id
JOIN courses c ON cs.course_id = c.id
WHERE c.name = "Engenharia Informática";

-- 5. Selecionar turmas e suas salas
SELECT cl.name AS class_name, r.name AS room_name
FROM classes cl
LEFT JOIN class_schedules cs ON cl.id = cs.class_id
LEFT JOIN rooms r ON cs.room_id = r.id;

-- 6. Selecionar alunos matriculados em um curso (Engenharia Informática)
SELECT u.first_name, u.last_name, c.name AS course_name
FROM student_enrollments se
JOIN students s ON se.student_id = s.user_id
JOIN users u ON s.user_id = u.id
JOIN courses c ON se.course_id = c.id
WHERE c.name = "Engenharia Informática";

-- 7. Selecionar pagamentos de propinas e seus status
SELECT u.first_name, u.last_name, sf.reference_month, sf.status, p.amount
FROM student_fees sf
JOIN students s ON sf.student_id = s.user_id
JOIN users u ON s.user_id = u.id
JOIN payments p ON sf.payment_id = p.id;

-- 8. Selecionar empresas terceirizadas e seus contratos
SELECT comp.name AS company_name, cc.contract_details, cc.status
FROM companies comp
JOIN companies_contracts cc ON comp.id = cc.company_id;

-- 9. Selecionar avaliações de SLA e percentual alcançado
SELECT comp.name AS company_name, cse.achieved_percentage, cse.penalty_applied
FROM companies_sla_evaluation cse
JOIN companies comp ON cse.company_id = comp.id;

-- 10. Testar a View vw_class_schedule
SELECT * FROM vw_class_schedule;

-- 11. Testar a View vw_teacher_workload
SELECT * FROM vw_teacher_workload;

-- 12. Testar a View vw_student_fees_summary
SELECT * FROM vw_student_fees_summary;

-- 13. Selecionar notas de um aluno em uma disciplina
SELECT u.first_name, u.last_name, sub.name AS subject_name, g.score
FROM grades g
JOIN students st ON g.student_id = st.user_id
JOIN users u ON st.user_id = u.id
JOIN class_schedules cs ON g.class_schedules_id = cs.id
JOIN subjects sub ON cs.subject_id = sub.id
WHERE u.first_name = "Ricardo" AND sub.name = "Programação I";

-- 14. Selecionar todos os professores e seus cargos
SELECT u.first_name, u.last_name, p.name AS position_name
FROM teachers t
JOIN staff s ON t.staff_id = s.user_id
JOIN users u ON s.user_id = u.id
JOIN staff_positions sp ON s.user_id = sp.user_id
JOIN positions p ON sp.position_id = p.id;

-- 15. Selecionar todos os pagamentos e seus métodos
SELECT p.amount, pt.name AS payment_method, p.status
FROM payments p
JOIN payment_types pt ON p.payment_method_id = pt.id;

-- 16. Selecionar todos os logs de auditoria
SELECT * FROM audit_logs;

-- 17. Selecionar alunos com propinas pendentes ou atrasadas
SELECT u.first_name, u.last_name, sf.reference_month, sf.status
FROM student_fees sf
JOIN students s ON sf.student_id = s.user_id
JOIN users u ON s.user_id = u.id
WHERE sf.status IN ("pending", "late");

-- 18. Selecionar cursos com pagamento mensal e seus valores
SELECT c.name AS course_name, cf.amount
FROM course_fees cf
JOIN courses c ON cf.course_id = c.id
WHERE cf.type_payment = "monthly_installment";

-- 19. Selecionar salas com capacidade superior a 50
SELECT name, capacity FROM rooms WHERE capacity > 50;

-- 20. Selecionar disciplinas com carga horária superior a 70 horas
SELECT name, workload_hours FROM subjects WHERE workload_hours > 70;




