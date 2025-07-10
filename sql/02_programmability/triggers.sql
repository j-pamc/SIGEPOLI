-- ==============================================================
-- TRIGGERS
-- ==============================================================

DELIMITER //

-- Trigger para Auditoria de Alterações na Tabela `users` (RF11)
-- Registra INSERTs, UPDATEs e DELETEs na tabela `audit_logs`.
CREATE TRIGGER trg_audit_users_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (user_id, table_name, operation_type, record_id, new_values, ip_address, user_agent, session_id, description, severity, status)
    VALUES (
        NEW.id, 
        'users',
        'INSERT',
        NEW.id,
        JSON_OBJECT(
            'first_name', NEW.first_name,
            'last_name', NEW.last_name,
            'email', NEW.email,
            'status', NEW.status
        ),
        '127.0.0.1', 
        'Application',
        'SESSION_ID_EXAMPLE',
        'Novo usuário cadastrado',
        'LOW',
        'SUCCESS'
    );
END //

CREATE TRIGGER trg_audit_users_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (user_id, table_name, operation_type, record_id, old_values, new_values, ip_address, user_agent, session_id, description, severity, status)
    VALUES (
        NEW.id, 
        'users',
        'UPDATE',
        NEW.id,
        JSON_OBJECT(
            'first_name', OLD.first_name,
            'last_name', OLD.last_name,
            'email', OLD.email,
            'status', OLD.status
        ),
        JSON_OBJECT(
            'first_name', NEW.first_name,
            'last_name', NEW.last_name,
            'email', NEW.email,
            'status', NEW.status
        ),
        '127.0.0.1',
        'Application',
        'SESSION_ID_EXAMPLE',
        'Usuário atualizado',
        'LOW',
        'SUCCESS'
    );
END //

CREATE TRIGGER trg_audit_users_delete
AFTER DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (user_id, table_name, operation_type, record_id, old_values, ip_address, user_agent, session_id, description, severity, status)
    VALUES (
        OLD.id, 
        'users',
        'DELETE',
        OLD.id,
        JSON_OBJECT(
            'first_name', OLD.first_name,
            'last_name', OLD.last_name,
            'email', OLD.email,
            'status', OLD.status
        ),
        '127.0.0.1',
        'Application',
        'SESSION_ID_EXAMPLE',
        'Usuário excluído',
        'MEDIUM',
        'SUCCESS'
    );
END //

DELIMITER ;

DELIMITER //

-- Trigger para Multa Automática se SLA Inferior a 90% (RN05)
-- Aplica uma multa na tabela `fines` se o percentual de SLA for inferior a 90%.
CREATE TRIGGER trg_apply_sla_fine
AFTER INSERT ON companies_sla_evaluation
FOR EACH ROW
BEGIN
    DECLARE v_penalty_percentage DECIMAL(8, 2);
    DECLARE v_contract_amount DECIMAL(10, 2);
    DECLARE v_fine_amount DECIMAL(10, 2);
    DECLARE v_payment_id INT;

    IF NEW.achieved_percentage < 90.00 THEN
        SELECT penalty_percentage INTO v_penalty_percentage
        FROM companies_sla
        WHERE id = NEW.sla_id;

        SELECT amount INTO v_contract_amount
        FROM payments p
        JOIN company_payments cp ON p.id = cp.payment_id
        WHERE cp.company_id = NEW.company_id
        ORDER BY p.payment_date DESC
        LIMIT 1;

        SET v_fine_amount = v_contract_amount * (v_penalty_percentage / 100);

        INSERT INTO payments (amount, payment_method_id, status)
        VALUES (v_fine_amount, (SELECT id FROM payment_types WHERE name = 'Fine Payment' LIMIT 1), 'pending');

        SET v_payment_id = LAST_INSERT_ID();

        INSERT INTO fines (payment_id, fined, amount, reason)
        VALUES (v_payment_id, 'company', v_fine_amount, CONCAT('Multa por SLA abaixo do esperado (', NEW.achieved_percentage, '%) para SLA ID ', NEW.sla_id));

        UPDATE companies_sla_evaluation
        SET penalty_applied = TRUE, penalty_amount = v_fine_amount
        WHERE id = NEW.id;
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Trigger para Aprovação da Carga Horária dos Professores pelo Coordenador (RN06)
-- Garante que a aprovação da carga horária de um professor seja feita por um coordenador de curso.
CREATE TRIGGER trg_approve_teacher_availability
BEFORE UPDATE ON teacher_availability
FOR EACH ROW
BEGIN
    DECLARE v_is_coordinator_of_teacher_course BOOLEAN DEFAULT FALSE;

    IF NEW.approved = TRUE AND OLD.approved = FALSE THEN
        SELECT EXISTS (
            SELECT 1
            FROM courses c
            JOIN course_subjects cs ON c.id = cs.course_id
            JOIN teacher_specializations ts ON cs.subject_id = ts.subject_id
            WHERE c.coordinator_staff_id = NEW.approved_by
              AND ts.teacher_id = NEW.teacher_id
        ) INTO v_is_coordinator_of_teacher_course;

        IF NOT v_is_coordinator_of_teacher_course THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: A carga horária do professor deve ser aprovada por um coordenador de um curso ao qual o professor está associado.';
        END IF;
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Trigger para validação de INSERT em course_fees
CREATE TRIGGER trg_course_fees_before_insert
BEFORE INSERT ON course_fees
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O valor da taxa do curso deve ser maior que zero.';
    END IF;

    IF NEW.fine_percentual < 0 OR NEW.fine_percentual > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual de multa deve estar entre 0 e 100.';
    END IF;

    IF NEW.start_at IS NOT NULL AND NEW.end_at IS NOT NULL AND NEW.start_at >= NEW.end_at THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de início deve ser anterior à data de término.';
    END IF;
END //

-- Trigger para validação de UPDATE em course_fees
CREATE TRIGGER trg_course_fees_before_update
BEFORE UPDATE ON course_fees
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O valor da taxa do curso deve ser maior que zero.';
    END IF;

    IF NEW.fine_percentual < 0 OR NEW.fine_percentual > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual de multa deve estar entre 0 e 100.';
    END IF;

    IF NEW.start_at IS NOT NULL AND NEW.end_at IS NOT NULL AND NEW.start_at >= NEW.end_at THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de início deve ser anterior à data de término.';
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Trigger para validação de INSERT em student_fees
CREATE TRIGGER trg_student_fees_before_insert
BEFORE INSERT ON student_fees
FOR EACH ROW
BEGIN
    IF NEW.reference_month < 1 OR NEW.reference_month > 12 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O mês de referência deve ser entre 1 e 12.';
    END IF;
END //

-- Trigger para validação de UPDATE em student_fees
CREATE TRIGGER trg_student_fees_before_update
BEFORE UPDATE ON student_fees
FOR EACH ROW
BEGIN
    IF NEW.reference_month < 1 OR NEW.reference_month > 12 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O mês de referência deve ser entre 1 e 12.';
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Trigger para validação de INSERT em users
CREATE TRIGGER trg_users_before_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.email IS NULL OR NEW.email = '' OR NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O email deve ser válido.';
    END IF;

    IF NEW.status NOT IN ('active', 'inactive', 'suspended') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status de usuário inválido.';
    END IF;
END //

-- Trigger para validação de UPDATE em users
CREATE TRIGGER trg_users_before_update_validation
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.email IS NULL OR NEW.email = '' OR NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O email deve ser válido.';
    END IF;

    IF NEW.status NOT IN ('active', 'inactive', 'suspended') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status de usuário inválido.';
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Trigger para gerar taxas de semestre na matrícula do estudante
-- Este trigger é acionado após a inserção de um registro em `student_enrollments`.
-- Ele calcula e insere as taxas de propina (`student_fees`) para o semestre do curso matriculado.
CREATE TRIGGER trg_generate_semester_fees
AFTER INSERT ON student_enrollments
FOR EACH ROW
BEGIN
    DECLARE v_course_id INT;
    DECLARE v_semester INT;
    DECLARE v_course_fee_id INT;
    DECLARE v_amount DECIMAL(10, 2);
    DECLARE v_start_month_semester INT;
    DECLARE v_end_month_semester INT;
    DECLARE v_current_year INT;
    DECLARE i INT;

    -- Obter o ID do curso e o semestre da matrícula
    SELECT course_id INTO v_course_id
    FROM student_enrollments
    WHERE id = NEW.id;

    -- Assumindo que o semestre é determinado pelo `enrollment_date` e a configuração do curso
    -- Para simplificar, vamos assumir que o semestre é o 1 ou 2 com base no mês de matrícula
    SET v_current_year = YEAR(NEW.enrollment_date);
    IF MONTH(NEW.enrollment_date) >= 2 AND MONTH(NEW.enrollment_date) <= 7 THEN
        SET v_semester = 1; -- Semestre 1: Fev-Jul
    ELSE
        SET v_semester = 2; -- Semestre 2: Ago-Jan
    END IF;

    -- Obter a taxa do curso para o semestre (assumindo que existe uma taxa por curso/semestre ou uma taxa padrão)
    -- Prioriza a taxa mais recente e ativa para o curso
    SELECT id, amount INTO v_course_fee_id, v_amount
    FROM course_fees
    WHERE course_id = v_course_id
      AND (end_at IS NULL OR end_at >= CURDATE())
    ORDER BY created_at DESC
    LIMIT 1;

    -- Se não houver uma taxa de curso definida, não gerar taxas de estudante
    IF v_course_fee_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhuma taxa de curso ativa encontrada para o curso matriculado.';
    END IF;

    -- Definir os meses de início e fim do semestre (ex: Semestre 1: Fev-Jul, Semestre 2: Ago-Jan)
    IF v_semester = 1 THEN
        SET v_start_month_semester = 2; -- Fevereiro
        SET v_end_month_semester = 7;   -- Julho
    ELSEIF v_semester = 2 THEN
        SET v_start_month_semester = 8; -- Agosto
        SET v_end_month_semester = 1;   -- Janeiro (do próximo ano)
    ELSE
        -- Lidar com semestres não definidos ou outros casos
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Semestre inválido para geração de taxas.';
    END IF;

    -- Loop para gerar as taxas para os meses do semestre
    SET i = v_start_month_semester;
    WHILE TRUE DO
        -- Ajustar o ano para os meses que caem no próximo ano (ex: Semestre 2: Jan)
        IF v_semester = 2 AND i < v_start_month_semester THEN
            SET v_current_year = YEAR(NEW.enrollment_date) + 1;
        ELSE
            SET v_current_year = YEAR(NEW.enrollment_date);
        END IF;

        INSERT INTO student_fees (student_id, course_fee_id, payment_id, reference_month, reference_year, status)
        VALUES (
            NEW.student_id,
            v_course_fee_id,
            NULL, -- payment_id será atualizado quando o pagamento for efetuado
            i,
            v_current_year,
            'pending'
        );

        IF i = v_end_month_semester THEN
            LEAVE; -- Sair do loop quando o mês final do semestre for atingido
        END IF;

        SET i = i + 1;
        IF i > 12 THEN
            SET i = 1; -- Reiniciar para Janeiro se passar de Dezembro
        END IF;
    END WHILE;
END //

DELIMITER ;

-- NOTA: A implementação de triggers para TODAS as tabelas com validações abrangentes pode ser muito extensa.
-- As triggers acima são exemplos para as tabelas course_fees, student_fees e users.
-- Para uma solução completa, seria necessário analisar cada tabela e suas regras de negócio específicas.




DELIMITER //

-- Trigger para validação de INSERT em departments
CREATE TRIGGER trg_departments_before_insert
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do departamento não pode ser vazio.';
    END IF;
    IF NEW.acronym IS NULL OR NEW.acronym = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O acrônimo do departamento não pode ser vazio.';
    END IF;
    IF NEW.budget_amount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O orçamento anual não pode ser negativo.';
    END IF;
END //

-- Trigger para validação de UPDATE em departments
CREATE TRIGGER trg_departments_before_update
BEFORE UPDATE ON departments
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do departamento não pode ser vazio.';
    END IF;
    IF NEW.acronym IS NULL OR NEW.acronym = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O acrônimo do departamento não pode ser vazio.';
    END IF;
    IF NEW.budget_amount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O orçamento anual não pode ser negativo.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em students
CREATE TRIGGER trg_students_before_insert
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.student_number IS NULL OR NEW.student_number = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O número de estudante não pode ser vazio.';
    END IF;
END //

-- Trigger para validação de UPDATE em students
CREATE TRIGGER trg_students_before_update
BEFORE UPDATE ON students
FOR EACH ROW
BEGIN
    IF NEW.student_number IS NULL OR NEW.student_number = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O número de estudante não pode ser vazio.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em staff
CREATE TRIGGER trg_staff_before_insert
BEFORE INSERT ON staff
FOR EACH ROW
BEGIN
    IF NEW.staff_number IS NULL OR NEW.staff_number = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O número de funcionário não pode ser vazio.';
    END IF;
END //

-- Trigger para validação de UPDATE em staff
CREATE TRIGGER trg_staff_before_update
BEFORE UPDATE ON staff
FOR EACH ROW
BEGIN
    IF NEW.staff_number IS NULL OR NEW.staff_number = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O número de funcionário não pode ser vazio.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em courses
CREATE TRIGGER trg_courses_before_insert
BEFORE INSERT ON courses
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do curso não pode ser vazio.';
    END IF;
    IF NEW.duration_semesters <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A duração do curso em semestres deve ser maior que zero.';
    END IF;
END //

-- Trigger para validação de UPDATE em courses
CREATE TRIGGER trg_courses_before_update
BEFORE UPDATE ON courses
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do curso não pode ser vazio.';
    END IF;
    IF NEW.duration_semesters <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A duração do curso em semestres deve ser maior que zero.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em subjects
CREATE TRIGGER trg_subjects_before_insert
BEFORE INSERT ON subjects
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da disciplina não pode ser vazio.';
    END IF;
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código da disciplina não pode ser vazio.';
    END IF;
    IF NEW.workload_hours <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A carga horária da disciplina deve ser maior que zero.';
    END IF;
END //

-- Trigger para validação de UPDATE em subjects
CREATE TRIGGER trg_subjects_before_update
BEFORE UPDATE ON subjects
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da disciplina não pode ser vazio.';
    END IF;
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código da disciplina não pode ser vazio.';
    END IF;
    IF NEW.workload_hours <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A carga horária da disciplina deve ser maior que zero.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em classes
CREATE TRIGGER trg_classes_before_insert
BEFORE INSERT ON classes
FOR EACH ROW
BEGIN
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código da turma não pode ser vazio.';
    END IF;
    IF NEW.semester <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O semestre da turma deve ser maior que zero.';
    END IF;
END //

-- Trigger para validação de UPDATE em classes
CREATE TRIGGER trg_classes_before_update
BEFORE UPDATE ON classes
FOR EACH ROW
BEGIN
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código da turma não pode ser vazio.';
    END IF;
    IF NEW.semester <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O semestre da turma deve ser maior que zero.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em rooms
CREATE TRIGGER trg_rooms_before_insert
BEFORE INSERT ON rooms
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da sala não pode ser vazio.';
    END IF;
    IF NEW.capacity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A capacidade da sala deve ser maior que zero.';
    END IF;
END //

-- Trigger para validação de UPDATE em rooms
CREATE TRIGGER trg_rooms_before_update
BEFORE UPDATE ON rooms
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da sala não pode ser vazio.';
    END IF;
    IF NEW.capacity <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A capacidade da sala deve ser maior que zero.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em course_subjects
CREATE TRIGGER trg_course_subjects_before_insert
BEFORE INSERT ON course_subjects
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

-- Trigger para validação de UPDATE em course_subjects
CREATE TRIGGER trg_course_subjects_before_update
BEFORE UPDATE ON course_subjects
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em course_availability
CREATE TRIGGER trg_course_availability_before_insert
BEFORE INSERT ON course_availability
FOR EACH ROW
BEGIN
    IF NEW.academic_year IS NULL OR NEW.academic_year = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O ano acadêmico não pode ser vazio.';
    END IF;
END //

-- Trigger para validação de UPDATE em course_availability
CREATE TRIGGER trg_course_availability_before_update
BEFORE UPDATE ON course_availability
FOR EACH ROW
BEGIN
    IF NEW.academic_year IS NULL OR NEW.academic_year = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O ano acadêmico não pode ser vazio.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em class_schedules
CREATE TRIGGER trg_class_schedules_before_insert
BEFORE INSERT ON class_schedules
FOR EACH ROW
BEGIN
    IF NEW.start_time IS NULL OR NEW.end_time IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O horário de início e fim da aula não pode ser vazio.';
    END IF;
    IF NEW.start_time >= NEW.end_time THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O horário de início deve ser anterior ao horário de fim.';
    END IF;
END //

-- Trigger para validação de UPDATE em class_schedules
CREATE TRIGGER trg_class_schedules_before_update
BEFORE UPDATE ON class_schedules
FOR EACH ROW
BEGIN
    IF NEW.start_time IS NULL OR NEW.end_time IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O horário de início e fim da aula não pode ser vazio.';
    END IF;
    IF NEW.start_time >= NEW.end_time THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O horário de início deve ser anterior ao horário de fim.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em student_enrollments
CREATE TRIGGER trg_student_enrollments_before_insert
BEFORE INSERT ON student_enrollments
FOR EACH ROW
BEGIN
    IF NEW.enrollment_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de matrícula não pode ser vazia.';
    END IF;
    IF NEW.conclusion_date IS NOT NULL AND NEW.enrollment_date >= NEW.conclusion_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de matrícula deve ser anterior à data de conclusão.';
    END IF;
END //

-- Trigger para validação de UPDATE em student_enrollments
CREATE TRIGGER trg_student_enrollments_before_update
BEFORE UPDATE ON student_enrollments
FOR EACH ROW
BEGIN
    IF NEW.enrollment_date IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de matrícula não pode ser vazia.';
    END IF;
    IF NEW.conclusion_date IS NOT NULL AND NEW.enrollment_date >= NEW.conclusion_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de matrícula deve ser anterior à data de conclusão.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em teachers
CREATE TRIGGER trg_teachers_before_insert
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

-- Trigger para validação de UPDATE em teachers
CREATE TRIGGER trg_teachers_before_update
BEFORE UPDATE ON teachers
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em teacher_specializations
CREATE TRIGGER trg_teacher_specializations_before_insert
BEFORE INSERT ON teacher_specializations
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

-- Trigger para validação de UPDATE em teacher_specializations
CREATE TRIGGER trg_teacher_specializations_before_update
BEFORE UPDATE ON teacher_specializations
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em grades
CREATE TRIGGER trg_grades_before_insert
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    IF NEW.score < 0 OR NEW.score > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A nota deve estar entre 0 e 20.';
    END IF;
END //

-- Trigger para validação de UPDATE em grades
CREATE TRIGGER trg_grades_before_update
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
    IF NEW.score < 0 OR NEW.score > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A nota deve estar entre 0 e 20.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em payments
CREATE TRIGGER trg_payments_before_insert
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O valor do pagamento deve ser maior que zero.';
    END IF;
    IF NEW.status NOT IN ('pending', 'completed', 'failed', 'refunded') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status de pagamento inválido.';
    END IF;
END //

-- Trigger para validação de UPDATE em payments
CREATE TRIGGER trg_payments_before_update
BEFORE UPDATE ON payments
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O valor do pagamento deve ser maior que zero.';
    END IF;
    IF NEW.status NOT IN ('pending', 'completed', 'failed', 'refunded') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status de pagamento inválido.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em payment_types
CREATE TRIGGER trg_payment_types_before_insert
BEFORE INSERT ON payment_types
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do tipo de pagamento não pode ser vazio.';
    END IF;
END //

-- Trigger para validação de UPDATE em payment_types
CREATE TRIGGER trg_payment_types_before_update
BEFORE UPDATE ON payment_types
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do tipo de pagamento não pode ser vazio.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em companies
CREATE TRIGGER trg_companies_before_insert
BEFORE INSERT ON companies
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da empresa não pode ser vazio.';
    END IF;
    IF NEW.contact_person IS NULL OR NEW.contact_person = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da pessoa de contato não pode ser vazio.';
    END IF;
    IF NEW.phone IS NULL OR NEW.phone = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O telefone da empresa não pode ser vazio.';
    END IF;
END //

-- Trigger para validação de UPDATE em companies
CREATE TRIGGER trg_companies_before_update
BEFORE UPDATE ON companies
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da empresa não pode ser vazio.';
    END IF;
    IF NEW.contact_person IS NULL OR NEW.contact_person = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da pessoa de contato não pode ser vazio.';
    END IF;
    IF NEW.phone IS NULL OR NEW.phone = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O telefone da empresa não pode ser vazio.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em contracts
CREATE TRIGGER trg_contracts_before_insert
BEFORE INSERT ON contracts
FOR EACH ROW
BEGIN
    IF NEW.start_date IS NULL THEN
        SIGNAL SQLSTATE (
            '45000'
        ) SET MESSAGE_TEXT = 'A data de início do contrato não pode ser vazia.';
    END IF;
    IF NEW.end_date IS NOT NULL AND NEW.start_date >= NEW.end_date THEN
        SIGNAL SQLSTATE (
            '45000'
        ) SET MESSAGE_TEXT = 'A data de início deve ser anterior à data de término.';
    END IF;
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE (
            '45000'
        ) SET MESSAGE_TEXT = 'O valor do contrato deve ser maior que zero.';
    END IF;
END //

-- Trigger para validação de UPDATE em contracts
CREATE TRIGGER trg_contracts_before_update
BEFORE UPDATE ON contracts
FOR EACH ROW
BEGIN
    IF NEW.start_date IS NULL THEN
        SIGNAL SQLSTATE (
            '45000'
        ) SET MESSAGE_TEXT = 'A data de início do contrato não pode ser vazia.';
    END IF;
    IF NEW.end_date IS NOT NULL AND NEW.start_date >= NEW.end_date THEN
        SIGNAL SQLSTATE (
            '45000'
        ) SET MESSAGE_TEXT = 'A data de início deve ser anterior à data de término.';
    END IF;
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE (
            '45000'
        ) SET MESSAGE_TEXT = 'O valor do contrato deve ser maior que zero.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em companies_contracts
CREATE TRIGGER trg_companies_contracts_before_insert
BEFORE INSERT ON companies_contracts
FOR EACH ROW
BEGIN
    IF NEW.contract_details IS NULL OR NEW.contract_details = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Os detalhes do contrato não podem ser vazios.';
    END IF;
    IF NEW.started_at IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de início do contrato não pode ser vazia.';
    END IF;
    IF NEW.ended_at IS NOT NULL AND NEW.started_at >= NEW.ended_at THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de início deve ser anterior à data de término.';
    END IF;
END //

-- Trigger para validação de UPDATE em companies_contracts
CREATE TRIGGER trg_companies_contracts_before_update
BEFORE UPDATE ON companies_contracts
FOR EACH ROW
BEGIN
    IF NEW.contract_details IS NULL OR NEW.contract_details = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Os detalhes do contrato não podem ser vazios.';
    END IF;
    IF NEW.started_at IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de início do contrato não pode ser vazia.';
    END IF;
    IF NEW.ended_at IS NOT NULL AND NEW.started_at >= NEW.ended_at THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de início deve ser anterior à data de término.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em companies_sla
CREATE TRIGGER trg_companies_sla_before_insert
BEFORE INSERT ON companies_sla
FOR EACH ROW
BEGIN
    IF NEW.sla_name IS NULL OR NEW.sla_name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do SLA não pode ser vazio.';
    END IF;
    IF NEW.target_percentage < 0 OR NEW.target_percentage > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual alvo do SLA deve estar entre 0 e 100.';
    END IF;
    IF NEW.penalty_percentage < 0 OR NEW.penalty_percentage > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual de multa do SLA deve estar entre 0 e 100.';
    END IF;
END //

-- Trigger para validação de UPDATE em companies_sla
CREATE TRIGGER trg_companies_sla_before_update
BEFORE UPDATE ON companies_sla
FOR EACH ROW
BEGIN
    IF NEW.sla_name IS NULL OR NEW.sla_name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do SLA não pode ser vazio.';
    END IF;
    IF NEW.target_percentage < 0 OR NEW.target_percentage > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual alvo do SLA deve estar entre 0 e 100.';
    END IF;
    IF NEW.penalty_percentage < 0 OR NEW.penalty_percentage > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual de multa do SLA deve estar entre 0 e 100.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em companies_sla_evaluation
CREATE TRIGGER trg_companies_sla_evaluation_before_insert
BEFORE INSERT ON companies_sla_evaluation
FOR EACH ROW
BEGIN
    IF NEW.achieved_percentage < 0 OR NEW.achieved_percentage > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual alcançado do SLA deve estar entre 0 e 100.';
    END IF;
END //

-- Trigger para validação de UPDATE em companies_sla_evaluation
CREATE TRIGGER trg_companies_sla_evaluation_before_update
BEFORE UPDATE ON companies_sla_evaluation
FOR EACH ROW
BEGIN
    IF NEW.achieved_percentage < 0 OR NEW.achieved_percentage > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O percentual alcançado do SLA deve estar entre 0 e 100.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em assessment_types
CREATE TRIGGER trg_assessment_types_before_insert
BEFORE INSERT ON assessment_types
FOR EACH ROW
BEGIN
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código do tipo de avaliação não pode ser vazio.';
    END IF;
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do tipo de avaliação não pode ser vazio.';
    END IF;
    IF NEW.weight < 0 OR NEW.weight > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O peso da avaliação deve estar entre 0 e 1.';
    END IF;
END //

-- Trigger para validação de UPDATE em assessment_types
CREATE TRIGGER trg_assessment_types_before_update
BEFORE UPDATE ON assessment_types
FOR EACH ROW
BEGIN
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código do tipo de avaliação não pode ser vazio.';
    END IF;
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do tipo de avaliação não pode ser vazio.';
    END IF;
    IF NEW.weight < 0 OR NEW.weight > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O peso da avaliação deve estar entre 0 e 1.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em user_roles
CREATE TRIGGER trg_user_roles_before_insert
BEFORE INSERT ON user_roles
FOR EACH ROW
BEGIN
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código do papel do usuário não pode ser vazio.';
    END IF;
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do papel do usuário não pode ser vazio.';
    END IF;
    IF NEW.hierarchy_level < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nível de hierarquia do papel do usuário não pode ser negativo.';
    END IF;
END //

-- Trigger para validação de UPDATE em user_roles
CREATE TRIGGER trg_user_roles_before_update
BEFORE UPDATE ON user_roles
FOR EACH ROW
BEGIN
    IF NEW.code IS NULL OR NEW.code = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O código do papel do usuário não pode ser vazio.';
    END IF;
    IF NEW.name IS NULL OR NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do papel do usuário não pode ser vazio.';
    END IF;
    IF NEW.hierarchy_level < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nível de hierarquia do papel do usuário não pode ser negativo.';
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em user_role_assignments
CREATE TRIGGER trg_user_role_assignments_before_insert
BEFORE INSERT ON user_role_assignments
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

-- Trigger para validação de UPDATE em user_role_assignments
CREATE TRIGGER trg_user_role_assignments_before_update
BEFORE UPDATE ON user_role_assignments
FOR EACH ROW
BEGIN
    -- Nenhuma validação específica além das FKs, mas pode ser adicionada aqui se necessário.
END //

DELIMITER ;




DELIMITER //

-- Trigger para validação de INSERT em audit_logs
CREATE TRIGGER trg_audit_logs_before_insert
BEFORE INSERT ON audit_logs
FOR EACH ROW
BEGIN
    IF NEW.table_name IS NULL OR NEW.table_name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da tabela não pode ser vazio.';
    END IF;
    IF NEW.operation_type IS NULL OR NEW.operation_type = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O tipo de operação não pode ser vazio.';
    END IF;
END //

-- Trigger para validação de UPDATE em audit_logs
CREATE TRIGGER trg_audit_logs_before_update
BEFORE UPDATE ON audit_logs
FOR EACH ROW
BEGIN
    IF NEW.table_name IS NULL OR NEW.table_name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da tabela não pode ser vazio.';
    END IF;
    IF NEW.operation_type IS NULL OR NEW.operation_type = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O tipo de operação não pode ser vazio.';
    END IF;
END //

DELIMITER ;


