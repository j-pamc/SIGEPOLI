-- ==============================================================
-- VALIDAÇÃO DE REGRAS DE NEGÓCIO
-- ==============================================================

-- RN01 – Um professor não pode ter aulas em turmas com horários sobrepostos.
-- Esta consulta deve retornar VAZIO se a regra estiver a ser cumprida.
SELECT
    u.first_name, u.last_name,
    cs1.id AS class_schedule_id_1,
    cs2.id AS class_schedule_id_2,
    cs1.time_slot_ids AS time_slots_1,
    cs2.time_slot_ids AS time_slots_2
FROM
    class_schedules cs1
JOIN
    class_schedules cs2 ON cs1.teacher_id = cs2.teacher_id
    AND cs1.id < cs2.id -- Para evitar duplicações e comparar com si mesmo
WHERE
    JSON_OVERLAPS(cs1.time_slot_ids, cs2.time_slot_ids) = 1;

-- RN02 – Só é permitida matrícula se houver vaga e propina paga.
-- Teste de cenário: Tentar matricular um aluno sem propina paga (deve falhar)
-- CALL EnrollStudentInClass(8, 1); -- Helena Fernandes (ID 8) tem propina de Abril atrasada para Eng. Informática (course_id 1)
-- SELECT * FROM class_enrollments WHERE student_id = 8 AND class_schedules_id = 1;

-- Teste de cenário: Tentar matricular um aluno em turma sem vaga (requer dados de teste específicos para lotar a turma)
-- SELECT r.capacity, COUNT(ce.id) FROM class_schedules cs JOIN rooms r ON cs.room_id = r.id LEFT JOIN class_enrollments ce ON cs.id = ce.class_schedules_id WHERE cs.id = 1 GROUP BY r.capacity;

-- RN03 – Notas devem estar entre 0–20.
-- Esta consulta deve retornar VAZIO se a regra estiver a ser cumprida.
SELECT * FROM grades WHERE score < 0 OR score > 20;

-- RN04 – Empresas precisam apresentar garantia válida antes do pagamento.
-- Esta regra exige uma tabela `company_guarantees` (não implementada no schema atual).
-- A validação deve ser feita na aplicação ou em procedure específica.

-- RN05 – SLA inferior a 90% gera multa automática.
-- Esta consulta deve retornar VAZIO se a regra estiver a ser cumprida (ou seja, todas as multas foram aplicadas).
SELECT
    cse.id AS sla_evaluation_id,
    c.name AS company_name,
    cse.achieved_percentage,
    cse.penalty_applied
FROM
    companies_sla_evaluation cse
JOIN
    companies c ON cse.company_id = c.id
WHERE
    cse.achieved_percentage < 90.00
    AND cse.penalty_applied = FALSE;

-- RN06 – Coordenador deve aprovar carga horária dos professores do curso.
-- Esta consulta deve retornar VAZIO se a regra estiver a ser cumprida.
SELECT
    ta.id AS teacher_availability_id,
    u_teacher.first_name AS teacher_first_name,
    u_teacher.last_name AS teacher_last_name,
    u_approver.first_name AS approver_first_name,
    u_approver.last_name AS approver_last_name
FROM
    teacher_availability ta
JOIN
    users u_teacher ON ta.teacher_id = u_teacher.id
LEFT JOIN
    users u_approver ON ta.approved_by = u_approver.id
WHERE
    ta.approved = TRUE
    AND NOT EXISTS (
        SELECT 1
        FROM courses c
        JOIN course_subjects cs ON c.id = cs.course_id
        JOIN teacher_specializations ts ON cs.subject_id = ts.subject_id
        WHERE c.coordinator_staff_id = ta.approved_by
          AND ts.teacher_id = ta.teacher_id
    );
