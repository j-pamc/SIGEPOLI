-- Views SQL para o SIGEPOLI

-- ==========================================================================================
-- View: ClassScheduleView
-- Descrição: Apresenta uma visão consolidada da grade horária das turmas, incluindo
--            informações sobre a turma, disciplina, professor, horários e sala.
-- ==========================================================================================
CREATE VIEW ClassScheduleView AS
SELECT
    cs.id AS schedule_id, -- ID do agendamento da turma
    c.name AS class_name, -- Nome da turma
    s.name AS subject_name, -- Nome da disciplina
    CONCAT(u.first_name, ' ', u.last_name) AS teacher_name, -- Nome completo do professor
    -- Concatena os horários da turma, formatando o dia da semana e o intervalo de tempo.
    GROUP_CONCAT(CONCAT(ts.day_of_week, ' ', TIME_FORMAT(ts.start_time, '%H:%i'), '-', TIME_FORMAT(ts.end_time, '%H:%i')) ORDER BY ts.day_of_week, ts.start_time SEPARATOR '; ') AS time_slots,
    r.name AS room_name, -- Nome da sala
    cs.status AS schedule_status -- Status do agendamento (e.g., draft, approved)
FROM
    class_schedules cs
JOIN
    classes c ON cs.class_id = c.id
JOIN
    subjects s ON cs.subject_id = s.id
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    users u ON t.staff_id = u.id
LEFT JOIN
    rooms r ON cs.room_id = r.id
LEFT JOIN
    time_slots ts ON JSON_CONTAINS(cs.time_slot_ids, CAST(ts.id AS JSON)) -- Junta com time_slots usando JSON_CONTAINS para IDs em formato JSON
GROUP BY
    cs.id, c.name, s.name, teacher_name, r.name, cs.status;

-- ==========================================================================================
-- View: TeacherWorkloadView
-- Descrição: Exibe a carga horária total de cada professor por disciplina.
-- ==========================================================================================
CREATE VIEW TeacherWorkloadView AS
SELECT
    t.staff_id AS teacher_id, -- ID do professor
    CONCAT(u.first_name, ' ', u.last_name) AS teacher_name, -- Nome completo do professor
    s.name AS subject_name, -- Nome da disciplina
    SUM(s.workload_hours) AS total_workload_hours -- Soma das horas de trabalho da disciplina
FROM
    class_schedules cs
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    users u ON t.staff_id = u.id
JOIN
    subjects s ON cs.subject_id = s.id
GROUP BY
    t.staff_id, teacher_name, s.name;

-- ==========================================================================================
-- View: DepartmentCostsView
-- Descrição: Fornece uma visão dos orçamentos e gastos por departamento para cada ano fiscal.
-- ==========================================================================================
CREATE VIEW DepartmentCostsView AS
SELECT
    d.name AS department_name, -- Nome do departamento
    db.fiscal_year, -- Ano fiscal
    db.budget_amount AS total_budget, -- Orçamento total do departamento
    (SELECT SUM(p.amount) FROM company_payments cp JOIN payments p ON cp.payment_id = p.id WHERE cp.department_budgets_id = db.id) AS spent_budget, -- Valor já gasto pelo departamento
    (db.budget_amount - (SELECT SUM(p.amount) FROM company_payments cp JOIN payments p ON cp.payment_id = p.id WHERE cp.department_budgets_id = db.id)) AS remaining_budget -- Valor restante do orçamento
FROM
    departments d
JOIN
    department_budgets db ON d.id = db.department_id
JOIN
    company_payments cp ON db.id = cp.department_budgets_id
JOIN
    payments p ON cp.payment_id = p.id
GROUP BY
    d.name, db.fiscal_year


-- ==========================================================================================
-- View: CompanyPaymentCostsView
-- Descrição: Detalha os pagamentos feitos a empresas, incluindo informações da empresa,
--            valor, data, tipo de pagamento e departamento responsável.
-- ==========================================================================================
CREATE VIEW CompanyPaymentCostsView AS
SELECT
    comp.name AS company_name, -- Nome da empresa
    p.amount AS payment_amount, -- Valor do pagamento
    p.payment_date, -- Data do pagamento
    pt.name AS payment_type, -- Tipo de pagamento (e.g., transferência, cheque)
    d.name AS department_name -- Nome do departamento que aprovou o pagamento
FROM
    company_payments cp
JOIN
    payments p ON cp.payment_id = p.id
JOIN
    companies comp ON cp.company_id = comp.id
JOIN
    payment_types pt ON p.payment_method_id = pt.id
JOIN
    department_budgets db ON cp.department_budgets_id = db.id
JOIN
    departments d ON db.department_id = d.id;

-- ==========================================================================================
-- View: StudentFeeCostsView
-- Descrição: Apresenta os custos de propinas dos alunos, incluindo o nome do aluno,
--            valor da propina, mês de referência, data de pagamento e status.
-- ==========================================================================================
CREATE VIEW StudentFeeCostsView AS
SELECT
    CONCAT(u.first_name, ' ', u.last_name) AS student_name, -- Nome completo do aluno
    cf.amount AS fee_amount, -- Valor da propina
    sf.reference_month, -- Mês de referência da propina
    p.payment_date, -- Data em que o pagamento foi registrado
    p.status AS payment_status -- Status do pagamento (e.g., pending, completed)
FROM
    student_fees sf
JOIN
    students s ON sf.student_id = s.user_id
JOIN
    users u ON s.user_id = u.id
JOIN
    course_fees cf ON sf.course_fee_id = cf.id
JOIN
    payments p ON sf.payment_id = p.id;


