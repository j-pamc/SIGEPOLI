-- ==============================================================
-- PROCEDURES
-- ==============================================================

DELIMITER //

-- Procedure para Matricular Alunos em Turmas (RF06)
-- Verifica a disponibilidade de vagas e o status de pagamento da propina antes de matricular.
CREATE PROCEDURE EnrollStudentInClass (
    IN p_student_id INT,
    IN p_class_schedules_id INT
)
BEGIN
    DECLARE v_course_id INT;
    DECLARE v_student_enrolled_course BOOLEAN DEFAULT FALSE;
    DECLARE v_has_paid_fee BOOLEAN DEFAULT FALSE;
    DECLARE v_class_capacity INT;
    DECLARE v_current_enrollments INT;
    DECLARE v_enrollment_status VARCHAR(20);

    -- Obter o ID do curso da turma
    SELECT c.course_id INTO v_course_id
    FROM class_schedules cs
    JOIN classes c ON cs.class_id = c.id
    WHERE cs.id = p_class_schedules_id;

    -- Verificar se o aluno já está matriculado no curso associado à turma
    SELECT TRUE INTO v_student_enrolled_course
    FROM student_enrollments
    WHERE student_id = p_student_id AND course_id = v_course_id AND status = 'active'
    LIMIT 1;

    -- Verificar se a propina está paga (RN02)
    -- Esta verificação é simplificada. Em um sistema real, envolveria a tabela studant_fees e payments.
    SELECT TRUE INTO v_has_paid_fee
    FROM studant_fees sf
    JOIN payments p ON sf.payment_id = p.id
    WHERE sf.student_id = p_student_id
      AND sf.course_fee_id IN (SELECT id FROM course_fees WHERE course_id = v_course_id)
      AND sf.status = 'paid'
    LIMIT 1;

    -- Obter a capacidade da sala e o número atual de matrículas na turma
    SELECT r.capacity, COUNT(ce.id)
    INTO v_class_capacity, v_current_enrollments
    FROM class_schedules cs
    JOIN rooms r ON cs.room_id = r.id
    LEFT JOIN class_enrollments ce ON cs.id = ce.class_schedules_id
    WHERE cs.id = p_class_schedules_id
    GROUP BY r.capacity;

    -- Verificar se há vaga (RN02)
    IF v_current_enrollments >= v_class_capacity THEN
        SET v_enrollment_status = 'no_vacancy';
    ELSEIF NOT v_student_enrolled_course THEN
        SET v_enrollment_status = 'not_enrolled_in_course';
    ELSEIF NOT v_has_paid_fee THEN
        SET v_enrollment_status = 'fee_not_paid';
    ELSE
        -- Realizar a matrícula
        INSERT INTO class_enrollments (student_id, class_schedules_id, enrollment_date, type_of_enrollment, status)
        VALUES (p_student_id, p_class_schedules_id, CURDATE(), 'regular', 'active');
        SET v_enrollment_status = 'success';
    END IF;

    SELECT v_enrollment_status AS enrollment_status;
END //

DELIMITER ;



DELIMITER //

-- Procedure para Alocar Professor em Turma (RF05)
-- Garante que um professor não tenha horários sobrepostos (RN01).
CREATE PROCEDURE AllocateTeacherToClass (
    IN p_class_schedules_id INT,
    IN p_teacher_id INT
)
BEGIN
    DECLARE v_time_slot_ids JSON;
    DECLARE v_overlap_exists BOOLEAN DEFAULT FALSE;

    -- Obter os time_slot_ids da class_schedules que será alocada
    SELECT time_slot_ids INTO v_time_slot_ids
    FROM class_schedules
    WHERE id = p_class_schedules_id;

    -- Verificar sobreposição de horários para o professor (RN01)
    -- Percorrer os time_slot_ids da nova alocação e comparar com os existentes para o professor
    SELECT EXISTS (
        SELECT 1
        FROM class_schedules cs_existing
        WHERE cs_existing.teacher_id = p_teacher_id
          AND cs_existing.id != p_class_schedules_id -- Excluir a própria entrada se for uma atualização
          AND JSON_OVERLAPS(cs_existing.time_slot_ids, v_time_slot_ids)
    ) INTO v_overlap_exists;

    IF v_overlap_exists THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: O professor já possui um horário sobreposto.';
    ELSE
        -- Atualizar o professor na class_schedules
        UPDATE class_schedules
        SET teacher_id = p_teacher_id
        WHERE id = p_class_schedules_id;
    END IF;

END //

DELIMITER ;




DELIMITER //

-- Procedure para Processar Pagamento de Propina (RF09)
-- Registra um pagamento e atualiza o status da propina do estudante.
CREATE PROCEDURE ProcessStudentPayment (
    IN p_student_id INT,
    IN p_course_fee_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_payment_method_id INT
)
BEGIN
    DECLARE v_payment_id INT;
    DECLARE v_current_status ENUM("pending", "paid", "late", "waived");

    -- Inserir o pagamento na tabela payments
    INSERT INTO payments (amount, payment_method_id, status)
    VALUES (p_amount, p_payment_method_id, 'completed');

    SET v_payment_id = LAST_INSERT_ID();

    -- Atualizar o status na tabela studant_fees
    UPDATE studant_fees
    SET
        payment_id = v_payment_id,
        status = 'paid'
    WHERE
        student_id = p_student_id AND course_fee_id = p_course_fee_id AND status IN ('pending', 'late');

    -- Se não houver registro em studant_fees para atualizar, pode-se inserir um novo
    -- ou tratar como erro, dependendo da regra de negócio.
    -- Por simplicidade, aqui assumimos que o registro já existe e está pendente/atrasado.

END //

DELIMITER ;


