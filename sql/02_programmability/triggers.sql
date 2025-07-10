-- ==============================================================
-- TRIGGERS
-- ==============================================================

DELIMITER //

-- Trigger para Auditoria de Alterações na Tabela `users` (RF11)
-- Registra INSERTs, UPDATEs e DELETEs na tabela `audit_logs`.
CREATE TRIGGER trg_audit_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (user_id, table_name, operation_type, record_id, new_values, ip_address, user_agent, session_id, description, severity, status)
    VALUES (
        NEW.id, -- Assumindo que o user_id do auditor é o próprio ID do usuário que está sendo alterado, ou pode ser ajustado para o ID do usuário logado se disponível.
        'users',
        'INSERT',
        NEW.id,
        JSON_OBJECT(
            'first_name', NEW.first_name,
            'last_name', NEW.last_name,
            'email', NEW.email,
            'status', NEW.status
        ),
        '127.0.0.1', -- IP de exemplo, deve ser capturado do contexto da aplicação
        'Application', -- User Agent de exemplo
        'SESSION_ID_EXAMPLE', -- Session ID de exemplo
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
        NEW.id, -- Assumindo que o user_id do auditor é o próprio ID do usuário que está sendo alterado
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
        OLD.id, -- Assumindo que o user_id do auditor é o próprio ID do usuário que está sendo excluído
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

    -- Verifica se o SLA está abaixo de 90%
    IF NEW.achieved_percentage < 90.00 THEN
        -- Obter o percentual de penalidade do SLA
        SELECT penalty_percentage INTO v_penalty_percentage
        FROM companies_sla
        WHERE id = NEW.sla_id;

        -- Obter o valor do contrato mais recente para a empresa (simplificado, pode precisar de mais lógica)
        SELECT amount INTO v_contract_amount
        FROM payments p
        JOIN company_payments cp ON p.id = cp.payment_id
        WHERE cp.company_id = NEW.company_id
        ORDER BY p.payment_date DESC
        LIMIT 1;

        -- Calcular o valor da multa
        SET v_fine_amount = v_contract_amount * (v_penalty_percentage / 100);

        -- Inserir o pagamento da multa na tabela payments
        INSERT INTO payments (amount, payment_method_id, status)
        VALUES (v_fine_amount, (SELECT id FROM payment_types WHERE name = 'Fine Payment' LIMIT 1), 'pending'); -- Assumindo um tipo de pagamento 'Fine Payment'

        SET v_payment_id = LAST_INSERT_ID();

        -- Registrar a multa na tabela fines
        INSERT INTO fines (payment_id, fined, amount, reason)
        VALUES (v_payment_id, 'company', v_fine_amount, CONCAT('Multa por SLA abaixo do esperado (', NEW.achieved_percentage, '%) para SLA ID ', NEW.sla_id));

        -- Atualizar o status da avaliação do SLA para indicar que a penalidade foi aplicada
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

    -- Se o status de aprovação está sendo alterado para TRUE
    IF NEW.approved = TRUE AND OLD.approved = FALSE THEN
        -- Verificar se o aprovador (NEW.approved_by) é um coordenador de curso
        -- e se esse curso está associado a alguma disciplina que o professor leciona
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


