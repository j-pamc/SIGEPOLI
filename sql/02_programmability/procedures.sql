-- Procedures SQL para o SIGEPOLI

-- ==========================================================================================
-- Procedure: EnrollStudent
-- Descrição: Matricula um aluno em um curso e em uma turma específica.
-- Parâmetros:
--   p_user_id INT: O ID do usuário que será matriculado (deve ser um aluno).
--   p_course_id INT: O ID do curso no qual o aluno será matriculado.
--   p_class_schedules_id INT: O ID do agendamento da turma/disciplina na qual o aluno será matriculado.
-- ==========================================================================================
DELIMITER //
CREATE PROCEDURE EnrollStudent(
    IN p_user_id INT,
    IN p_course_id INT,
    IN p_class_schedules_id INT
)
BEGIN
    DECLARE student_id_val INT;

    -- Verifica se o ID do usuário fornecido corresponde a um aluno existente na tabela `students`.
    SELECT user_id INTO student_id_val FROM students WHERE user_id = p_user_id;

    -- Se o usuário não for encontrado como aluno, sinaliza um erro.
    IF student_id_val IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: O usuário não está registrado como aluno.';
    END IF;

    -- Insere um novo registro na tabela `student_enrollments` para matricular o aluno no curso.
    INSERT INTO student_enrollments (student_id, course_id, enrollment_date, status, conclusion_date)
    VALUES (student_id_val, p_course_id, CURDATE(), 'active', CURDATE());

    -- Insere um novo registro na tabela `class_enrollments` para matricular o aluno na turma/disciplina.
    INSERT INTO class_enrollments (student_id, class_schedules_id, enrollment_date, type_of_enrollment, status)
    VALUES (student_id_val, p_class_schedules_id, CURDATE(), 'regular', 'active');

    -- Retorna uma mensagem de sucesso.
    SELECT 'Aluno matriculado com sucesso.' AS message;
END //
DELIMITER ;

-- ==========================================================================================
-- Procedure: AllocateResourceToRoom
-- Descrição: Aloca um recurso a uma sala ou atualiza o status de um recurso já alocado.
-- Parâmetros:
--   p_room_id INT: O ID da sala.
--   p_resource_id INT: O ID do recurso.
--   p_status_resources ENUM: O novo status do recurso na sala (e.g., 'available', 'in_use', 'maintenance').
-- ==========================================================================================
DELIMITER //
CREATE PROCEDURE AllocateResourceToRoom(
    IN p_room_id INT,
    IN p_resource_id INT,
    IN p_status_resources ENUM('available', 'unavailable', 'damaged', 'maintenance', 'lost')
)
BEGIN
    -- Verifica se a sala existe.
    IF NOT EXISTS(SELECT 1 FROM rooms WHERE id = p_room_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Sala não encontrada.';
    END IF;

    -- Verifica se o recurso existe.
    IF NOT EXISTS(SELECT 1 FROM resources WHERE id = p_resource_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Recurso não encontrado.';
    END IF;

    -- Insere um novo registro de alocação ou atualiza o status de um recurso existente na sala.
    INSERT INTO room_resources (room_id, resource_id, status_resources)
    VALUES (p_room_id, p_resource_id, p_status_resources)
    ON DUPLICATE KEY UPDATE status_resources = p_status_resources;

    -- Retorna uma mensagem de sucesso.
    SELECT 'Recurso alocado/atualizado com sucesso.' AS message;
END //
DELIMITER ;

-- ==========================================================================================
-- Procedure: ProcessPayment
-- Descrição: Processa um pagamento, registrando-o na tabela principal `payments` e nas
--            tabelas específicas de pagamento (aluno, empresa, funcionário).
-- Parâmetros:
--   p_amount DECIMAL(10, 2): O valor do pagamento.
--   p_payment_method_id INT: O ID do método de pagamento.
--   p_reference_number VARCHAR(50): O número de referência do pagamento.
--   p_status ENUM: O status do pagamento (e.g., 'pending', 'completed', 'failed').
--   p_student_id INT: (Opcional) O ID do aluno, se for um pagamento de aluno.
--   p_service_id INT: (Opcional) O ID do serviço, se for um pagamento de aluno.
--   p_company_id INT: (Opcional) O ID da empresa, se for um pagamento de empresa.
--   p_department_budgets_id INT: (Opcional) O ID do orçamento do departamento, se for um pagamento de empresa.
--   p_approved_by_staff INT: (Opcional) O ID do funcionário que aprovou, se for um pagamento de empresa.
--   p_staff_id INT: (Opcional) O ID do funcionário, se for um pagamento de funcionário.
--   p_type_of_staff_payment ENUM: (Opcional) O tipo de pagamento de funcionário (e.g., 'salary', 'bonus').
-- ==========================================================================================
DELIMITER //
CREATE PROCEDURE ProcessPayment(
    IN p_amount DECIMAL(10, 2),
    IN p_payment_method_id INT,
    IN p_reference_number VARCHAR(50),
    IN p_status ENUM('pending', 'completed', 'failed', 'refunded'),
    IN p_student_id INT DEFAULT NULL,
    IN p_service_id INT DEFAULT NULL,
    IN p_company_id INT DEFAULT NULL,
    IN p_department_budgets_id INT DEFAULT NULL,
    IN p_approved_by_staff INT DEFAULT NULL,
    IN p_staff_id INT DEFAULT NULL,
    IN p_type_of_staff_payment ENUM('salary', 'bonus', 'reimbursement', 'commission', 'other') DEFAULT NULL
)
BEGIN
    DECLARE payment_id_val INT;

    -- Insere o registro principal do pagamento na tabela `payments`.
    INSERT INTO payments (amount, payment_method_id, reference_number, status)
    VALUES (p_amount, p_payment_method_id, p_reference_number, p_status);

    -- Obtém o ID do pagamento recém-inserido.
    SET payment_id_val = LAST_INSERT_ID();

    -- Associa o pagamento ao tipo específico (aluno, empresa ou funcionário) com base nos parâmetros fornecidos.
    IF p_student_id IS NOT NULL AND p_service_id IS NOT NULL THEN
        -- Se for um pagamento de aluno por serviço, insere na tabela `student_payments`.
        INSERT INTO student_payments (payment_id, service_id, student_id)
        VALUES (payment_id_val, p_service_id, p_student_id);
    ELSEIF p_company_id IS NOT NULL AND p_department_budgets_id IS NOT NULL AND p_approved_by_staff IS NOT NULL THEN
        -- Se for um pagamento de empresa, insere na tabela `company_payments`.
        INSERT INTO company_payments (payment_id, company_id, department_budgets_id, approved_by_staff)
        VALUES (payment_id_val, p_company_id, p_department_budgets_id, p_approved_by_staff);
    ELSEIF p_staff_id IS NOT NULL AND p_type_of_staff_payment IS NOT NULL THEN
        -- Se for um pagamento de funcionário, insere na tabela `staff_payments`.
        INSERT INTO staff_payments (payment_id, staff_id, type_of_payment)
        VALUES (payment_id_val, p_staff_id, p_type_of_staff_payment);
    END IF;

    -- Retorna uma mensagem de sucesso e o ID do novo pagamento.
    SELECT 'Pagamento processado com sucesso.' AS message, payment_id_val AS new_payment_id;
END //
DELIMITER ;


