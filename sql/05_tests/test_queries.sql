-- ==============================================================
-- CONSULTAS DE TESTE
-- ==============================================================

-- 1. Selecionar todos os usuários
SELECT * FROM users;

-- 2. Selecionar todos os departamentos e seus chefes
-- ATENÇÃO: Se não houver staff vinculado como chefe, u.first_name será NULL (isso é esperado)
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

-- 10. Testar a View ClassScheduleView
SELECT * FROM ClassScheduleView;

-- 11. Testar a View TeacherWorkloadView
SELECT * FROM TeacherWorkloadView;

-- 12. Testar a View StudentFeeCostsView
SELECT * FROM StudentFeeCostsView;

-- 13. Testar a View DepartmentCostsView
SELECT * FROM DepartmentCostsView;

-- 14. Testar a View CompanyPaymentCostsView
SELECT * FROM CompanyPaymentCostsView;

-- 15. Selecionar notas de um aluno em uma disciplina
SELECT u.first_name, u.last_name, sub.name AS subject_name, g.score
FROM grades g
JOIN students st ON g.student_id = st.user_id
JOIN users u ON st.user_id = u.id
JOIN class_schedules cs ON g.class_schedules_id = cs.id
JOIN subjects sub ON cs.subject_id = sub.id
WHERE u.first_name = "Ricardo" AND sub.name = "Programação I";

-- 16. Selecionar todos os professores e seus cargos
-- ATENÇÃO: Se não houver staff vinculado, u.first_name será NULL (isso é esperado)
SELECT u.first_name, u.last_name, p.name AS position_name
FROM teachers t
JOIN staff s ON t.staff_id = s.user_id
JOIN users u ON s.user_id = u.id
JOIN staff_positions sp ON s.user_id = sp.user_id
JOIN positions p ON sp.position_id = p.id;

-- 17. Selecionar todos os pagamentos e seus métodos
SELECT p.amount, pt.name AS payment_method, p.status
FROM payments p
JOIN payment_types pt ON p.payment_method_id = pt.id;

-- 18. Selecionar todos os logs de auditoria
SELECT * FROM audit_logs;

-- 19. Selecionar alunos com propinas pendentes ou atrasadas
SELECT u.first_name, u.last_name, sf.reference_month, sf.status
FROM student_fees sf
JOIN students s ON sf.student_id = s.user_id
JOIN users u ON s.user_id = u.id
WHERE sf.status IN ("pending", "late");

-- 20. Selecionar cursos com pagamento mensal e seus valores
SELECT c.name AS course_name, cf.amount
FROM course_fees cf
JOIN courses c ON cf.course_id = c.id
WHERE cf.type_payment = "monthly_installment";

-- 21. Selecionar salas com capacidade superior a 50
SELECT name, capacity FROM rooms WHERE capacity > 50;

-- 22. Selecionar disciplinas com carga horária superior a 70 horas
SELECT name, workload_hours FROM subjects WHERE workload_hours > 70;

-- ==============================================================
-- TESTES DE FUNCTIONS
-- ==============================================================

-- 23. Testar Function ValidateGrade - Nota válida (15.00)
SELECT ValidateGrade(15.00) AS is_valid_grade;

-- 24. Testar Function ValidateGrade - Nota inválida (25.00)
SELECT ValidateGrade(25.00) AS is_valid_grade;

-- 25. Testar Function ValidateGrade - Nota limite inferior (0.00)
SELECT ValidateGrade(0.00) AS is_valid_grade;

-- 26. Testar Function ValidateGrade - Nota limite superior (20.00)
SELECT ValidateGrade(20.00) AS is_valid_grade;

-- 27. Testar Function CalculateWeightedAverage - Média ponderada do Ricardo Gomes em Programação I
SELECT CalculateWeightedAverage(7, 1) AS weighted_average;

-- 28. Testar Function CalculateSLAPercentage - Percentual SLA da Limpeza Total em Março 2025
SELECT CalculateSLAPercentage(1, 1, '2025-03-01') AS sla_percentage;

-- ==============================================================
-- TESTES DE PROCEDURES
-- ==============================================================

-- 29. Testar Procedure EnrollStudent - Matricular um novo aluno (Laura Oliveira) em Eng. Informática
CALL EnrollStudent(10, 1, 1);

-- 30. Testar Procedure AllocateResourceToRoom - Alocar recurso à sala
CALL AllocateResourceToRoom(1, 1, 'available');

-- 31. Testar Procedure ProcessPayment - Pagamento de aluno
CALL ProcessPayment(50000.00, 1, 'REF2025001', 'completed', 7, 1, NULL, NULL, NULL, NULL, NULL);

-- 32. Testar Procedure ProcessPayment - Pagamento de empresa
CALL ProcessPayment(100000.00, 1, 'REF2025002', 'completed', NULL, NULL, 1, 1, 1, NULL, NULL);

-- 33. Testar Procedure ProcessPayment - Pagamento de funcionário
CALL ProcessPayment(75000.00, 1, 'REF2025003', 'completed', NULL, NULL, NULL, NULL, NULL, 1, 'salary');

-- ==============================================================
-- TESTES ADICIONAIS DE VALIDAÇÃO
-- ==============================================================

-- 34. Verificar se todas as notas estão dentro do intervalo válido (0-20)
SELECT g.id, g.score, ValidateGrade(g.score) AS is_valid
FROM grades g
WHERE ValidateGrade(g.score) = FALSE;

-- 35. Calcular média ponderada para todos os alunos em todas as disciplinas
SELECT 
    u.first_name, 
    u.last_name, 
    sub.name AS subject_name,
    CalculateWeightedAverage(s.user_id, cs.id) AS weighted_average
FROM students s
JOIN users u ON s.user_id = u.id
JOIN class_enrollments ce ON s.user_id = ce.student_id
JOIN class_schedules cs ON ce.class_schedules_id = cs.id
JOIN subjects sub ON cs.subject_id = sub.id
WHERE CalculateWeightedAverage(s.user_id, cs.id) IS NOT NULL;

-- 36. Verificar percentual SLA de todas as empresas
SELECT 
    comp.name AS company_name,
    cs.sla_name,
    CalculateSLAPercentage(comp.id, cs.id, '2025-03-01') AS sla_percentage
FROM companies comp
JOIN companies_sla cs ON comp.id = cs.company_id;




