-- ==============================================================
-- DADOS DE TESTE (INSERTs)
-- Contexto: ISPTEC, Angola
-- ==============================================================

-- Limpeza das tabelas para evitar erros de integridade referencial
-- (Atenção: TRUNCATE remove todos os dados e reinicia auto_increment)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE grades;          -- Limpa notas (depende de class_schedules)
TRUNCATE TABLE student_fees;    -- Limpa propinas dos estudantes
TRUNCATE TABLE payments;        -- Limpa pagamentos
TRUNCATE TABLE room_resources;  -- Limpa recursos das salas
TRUNCATE TABLE services;        -- Limpa serviços
TRUNCATE TABLE class_schedules; -- Limpa horários das turmas
TRUNCATE TABLE teachers;        -- Limpa professores
TRUNCATE TABLE staff;           -- Limpa funcionários
TRUNCATE TABLE students;        -- Limpa alunos
TRUNCATE TABLE users;           -- Limpa usuários
SET FOREIGN_KEY_CHECKS = 1;

-- Inserir Usuários (Gerais)
INSERT INTO users (first_name, last_name, email, password, phone, address, date_of_birth, status, gender, is_verified)
VALUES
("João", "Silva", "joao.silva@isptec.co.ao", "hashed_password_1", "+244912345678", "Rua 1, Bairro Talatona, Luanda", "1990-05-15", "active", "M", TRUE),
("Maria", "Santos", "maria.santos@isptec.co.ao", "hashed_password_2", "+244923456789", "Av. Deolinda Rodrigues, Luanda", "1985-11-22", "active", "F", TRUE),
("Pedro", "Costa", "pedro.costa@isptec.co.ao", "hashed_password_3", "+244934567890", "Condomínio X, Viana, Luanda", "1992-03-10", "active", "M", TRUE),
("Ana", "Pereira", "ana.pereira@isptec.co.ao", "hashed_password_4", "+244945678901", "Rua Y, Morro Bento, Luanda", "1988-07-01", "active", "F", TRUE),
("Carlos", "Almeida", "carlos.almeida@isptec.co.ao", "hashed_password_5", "+244956789012", "Travessa Z, Benfica, Luanda", "1975-01-20", "active", "M", TRUE),
("Sofia", "Martins", "sofia.martins@isptec.co.ao", "hashed_password_6", "+244967890123", "Rua Principal, Kilamba, Luanda", "1995-09-05", "active", "F", TRUE),
("Ricardo", "Gomes", "ricardo.gomes@isptec.co.ao", "hashed_password_7", "+244978901234", "Av. Revolução, Cazenga, Luanda", "1980-04-12", "active", "M", TRUE),
("Helena", "Fernandes", "helena.fernandes@isptec.co.ao", "hashed_password_8", "+244989012345", "Rua Nova, Cacuaco, Luanda", "1998-12-30", "active", "F", TRUE),
("Miguel", "Rodrigues", "miguel.rodrigues@isptec.co.ao", "hashed_password_9", "+244990123456", "Bairro Popular, Luanda", "1993-06-25", "active", "M", TRUE),
("Laura", "Oliveira", "laura.oliveira@isptec.co.ao", "hashed_password_10", "+244911234567", "Rua da Paz, Camama, Luanda", "1996-02-18", "active", "F", TRUE);

-- Inserir Departamentos
INSERT INTO departments (name, acronym, description, classification)
VALUES
("Departamento de Engenharia Informática", "DEI", "Responsável pelos cursos de Engenharia Informática.", "academic"),
("Departamento de Engenharia Civil", "DEC", "Responsável pelos cursos de Engenharia Civil.", "academic"),
("Departamento de Gestão", "DG", "Responsável pelos cursos de Gestão.", "academic"),
("Secretaria Acadêmica", "SA", "Gestão de matrículas e documentos de alunos.", "administrative"),
("Tesouraria", "TES", "Gestão financeira e pagamentos.", "administrative");

-- Inserir Staff (Funcionários Administrativos e Coordenadores)
INSERT INTO staff (user_id, staff_number, hire_date, employment_type, employment_status, department_id, staff_category)
VALUES
(1, "STAFF001", "2018-01-10", "full_time", "active", 4, "administrative"), -- João Silva - Secretaria Acadêmica
(2, "STAFF002", "2017-03-15", "full_time", "active", 5, "administrative"), -- Maria Santos - Tesouraria
(3, "STAFF003", "2019-09-01", "full_time", "active", 1, "academic"), -- Pedro Costa - Coordenador DEI
(4, "STAFF004", "2020-02-20", "full_time", "active", 2, "academic"), -- Ana Pereira - Coordenadora DEC
(5, "STAFF005", "2016-08-12", "full_time", "active", 1, "academic"), -- Carlos Almeida - Professor DEI
(6, "STAFF006", "2018-09-25", "full_time", "active", 1, "academic"); -- Sofia Martins - Professora DEI

-- Inserir Professores
INSERT INTO teachers (staff_id, academic_rank, tenure_status, is_thesis_advisor)
VALUES
(3, "associate_professor", "tenured", TRUE), -- Pedro Costa
(4, "assistant_professor", "tenure_track", FALSE), -- Ana Pereira
(5, "full_professor", "tenured", TRUE), -- Carlos Almeida
(6, "instructor", "adjunct", FALSE); -- Sofia Martins

-- Inserir Cursos
INSERT INTO courses (name, description, duration_semesters, department_id, coordinator_staff_id, level, status)
VALUES
("Engenharia Informática", "Curso de graduação em Engenharia Informática.", 10, 1, 3, "graduate", "active"),
("Engenharia Civil", "Curso de graduação em Engenharia Civil.", 10, 2, 4, "graduate", "active"),
("Gestão de Empresas", "Curso de graduação em Gestão de Empresas.", 8, 3, 1, "graduate", "active"); -- Coordenador João Silva (STAFF001)

-- Inserir Disciplinas
INSERT INTO subjects (name, code, description, workload_hours)
VALUES
("Programação I", "INF101", "Introdução à programação.", 60),
("Cálculo I", "MAT101", "Cálculo diferencial e integral.", 90),
("Estruturas de Dados", "INF201", "Estruturas de dados e algoritmos.", 60),
("Física I", "FIS101", "Fundamentos de física.", 75),
("Contabilidade Geral", "GES101", "Princípios de contabilidade.", 60);

-- Inserir course_subjects (disciplinas por curso)
INSERT INTO course_subjects (subject_id, course_id, semester, is_mandatory)
VALUES
(1, 1, 1, TRUE), -- Programação I em Eng. Informática
(2, 1, 1, TRUE), -- Cálculo I em Eng. Informática
(3, 1, 2, TRUE), -- Estruturas de Dados em Eng. Informática
(2, 2, 1, TRUE), -- Cálculo I em Eng. Civil
(4, 2, 1, TRUE), -- Física I em Eng. Civil
(5, 3, 1, TRUE); -- Contabilidade Geral em Gestão de Empresas

-- Inserir time_slots (horários)
INSERT INTO time_slots (day_of_week, shift, start_time, end_time, hours)
VALUES
("monday", "morning", "08:00:00", "10:00:00", 2),
("monday", "morning", "10:00:00", "12:00:00", 2),
("tuesday", "afternoon", "14:00:00", "16:00:00", 2),
("wednesday", "morning", "09:00:00", "11:00:00", 2),
("thursday", "evening", "18:00:00", "20:00:00", 2);

-- Inserir Rooms (Salas)
INSERT INTO rooms (name, description, localization, capacity, type_of_room, acessibility, is_available)
VALUES
("Sala A101", "Sala de aula padrão", "Edifício A, 1º Andar", 40, "classroom", FALSE, TRUE),
("Laboratório de Informática 1", "Laboratório com computadores", "Edifício B, R/C", 30, "laboratory", TRUE, TRUE),
("Auditório Principal", "Auditório para grandes eventos", "Edifício C, 2º Andar", 150, "auditorium", TRUE, TRUE);

-- Inserir Classes (Turmas)
INSERT INTO classes (name, code, course_id, academic_year, semester)
VALUES
("EI2025T1", "EI-T1", 1, 2025, 1), -- Turma de Eng. Informática, 1º Semestre
("EC2025T1", "EC-T1", 2, 2025, 1); -- Turma de Eng. Civil, 1º Semestre

-- Inserir class_schedules (horários das turmas)
INSERT INTO class_schedules (class_id, subject_id, teacher_id, time_slot_ids, room_id, status)
VALUES
(1, 1, 5, JSON_ARRAY(1, 2), 2, "approved"), -- EI2025T1 - Programação I (Carlos Almeida) - Seg 08-12h - Lab Info 1
(1, 2, 3, JSON_ARRAY(3), 1, "approved"), -- EI2025T1 - Cálculo I (Pedro Costa) - Ter 14-16h - Sala A101
(2, 2, 4, JSON_ARRAY(4), 1, "approved"); -- EC2025T1 - Cálculo I (Ana Pereira) - Qua 09-11h - Sala A101

-- Inserir Students (Alunos)
INSERT INTO students (user_id, student_number, studying, searching)
VALUES
(7, "STU2025001", TRUE, FALSE), -- Ricardo Gomes
(8, "STU2025002", TRUE, TRUE), -- Helena Fernandes
(9, "STU2025003", TRUE, FALSE), -- Miguel Rodrigues
(10, "STU2025004", TRUE, FALSE); -- Laura Oliveira

-- Inserir Resources (Recursos)
INSERT INTO resources (name, description, responsible_department_id)
VALUES
("Projetor", "Projetor multimídia para apresentações", 1),
("Ar Condicionado", "Sistema de ar condicionado", 4),
("Computador", "Computador para laboratório", 1);

-- Inserir Service Types (Tipos de Serviços)
INSERT INTO service_types (name, description)
VALUES
("Acadêmico", "Serviços relacionados ao processo acadêmico"),
("Administrativo", "Serviços administrativos gerais");

-- Inserir Services (Serviços)
INSERT INTO services (name, description, service_types_id, value, department_id, status)
VALUES
("Emissão de Certificado", "Emissão de certificado de conclusão", (SELECT id FROM service_types WHERE name = 'Acadêmico'), 5000.00, 4, "active"),
("Carteira de Estudante", "Emissão de carteira de estudante", (SELECT id FROM service_types WHERE name = 'Acadêmico'), 2000.00, 4, "active");

-- Inserir Department Budgets (Orçamentos dos Departamentos)
INSERT INTO department_budgets (department_id, fiscal_year, budget_amount, spent_amount, remaining_amount, on_account)
VALUES
(1, 2025, 5000000.00, 0.00, 5000000.00, FALSE), -- DEI
(2, 2025, 4000000.00, 0.00, 4000000.00, FALSE), -- DEC
(3, 2025, 3000000.00, 0.00, 3000000.00, FALSE), -- DG
(4, 2025, 2000000.00, 0.00, 2000000.00, FALSE), -- SA
(5, 2025, 1500000.00, 0.00, 1500000.00, FALSE); -- TES

-- Inserir student_enrollments (matrículas de alunos em cursos)
INSERT INTO student_enrollments (student_id, course_id, enrollment_date, status)
VALUES
(7, 1, "2025-02-01", "active"), -- Ricardo Gomes em Eng. Informática
(8, 1, "2025-02-01", "active"), -- Helena Fernandes em Eng. Informática
(9, 2, "2025-02-01", "active"); -- Miguel Rodrigues em Eng. Civil

-- Inserir course_fees (preços dos cursos)
INSERT INTO course_fees (course_id, type_payment, day_limit_fines, start_at, end_at, amount, grace_period_days, fine_percentual)
VALUES
(1, "monthly_installment", 10, "2025-01-01 00:00:00", "2025-12-31 23:59:59", 45000.00, 5, 0.02), -- Eng. Informática: 45.000 Kz/mês, 2% multa após 5 dias de tolerância
(2, "monthly_installment", 10, "2025-01-01 00:00:00", "2025-12-31 23:59:59", 40000.00, 5, 0.02), -- Eng. Civil: 40.000 Kz/mês, 2% multa após 5 dias de tolerância
(3, "full_payment", NULL, "2025-01-01 00:00:00", "2025-12-31 23:59:59", 350000.00, NULL, NULL); -- Gestão de Empresas: 350.000 Kz (pagamento único)

-- Inserir payment_types
INSERT INTO payment_types (name, description)
VALUES
("Transferência Bancária", "Pagamento via transferência bancária."),
("Multicaixa", "Pagamento via terminal Multicaixa."),
("Fine Payment", "Pagamento de multa.");

-- Inserir payments (pagamentos)
INSERT INTO payments (amount, payment_method_id, status)
VALUES
(45000.00, 1, "completed"), -- Pagamento de propina - Ricardo Gomes (Março)
(45000.00, 2, "completed"), -- Pagamento de propina - Helena Fernandes (Março)
(40000.00, 1, "completed"), -- Pagamento de propina - Miguel Rodrigues (Março)
(45000.00, 1, "pending"), -- Pagamento de propina - Ricardo Gomes (Abril) - Pendente
(45000.00, 2, "failed"); -- Pagamento de propina - Helena Fernandes (Abril) - Falhou

-- Inserir student_fees (propinas dos estudantes)
INSERT INTO student_fees (student_id, course_fee_id, payment_id, reference_month, status)
VALUES
(7, 1, 1, 3, "paid"), -- Ricardo Gomes - Eng. Informática - Março - Pago
(8, 1, 2, 3, "paid"), -- Helena Fernandes - Eng. Informática - Março - Pago
(9, 2, 3, 3, "paid"), -- Miguel Rodrigues - Eng. Civil - Março - Pago
(7, 1, 4, 4, "pending"), -- Ricardo Gomes - Eng. Informática - Abril - Pendente
(8, 1, 5, 4, "late"); -- Helena Fernandes - Eng. Informática - Abril - Atrasado (pagamento falhou)

-- Inserir Companies (Empresas Terceirizadas)
INSERT INTO companies (name, nif, address, phone, email)
VALUES
("Limpeza Total Lda.", "500012345", "Rua da Limpeza, Luanda", "+244222111222", "contacto@limpezatotal.co.ao"),
("Segurança Ativa SA", "500067890", "Av. da Segurança, Luanda", "+244222333444", "geral@segurancaativa.co.ao");

-- Inserir companies_contracts
INSERT INTO companies_contracts (company_id, contract_details, started_at, ended_at, status, signed_by_staff)
VALUES
(1, "Contrato de prestação de serviços de limpeza para 2025.", "2025-01-01", "2025-12-31", "active", 1), -- Limpeza Total - Assinado por João Silva
(2, "Contrato de prestação de serviços de segurança para 2025.", "2025-01-01", "2025-12-31", "active", 1); -- Segurança Ativa - Assinado por João Silva

-- Inserir companies_sla
INSERT INTO companies_sla (company_id, sla_name, description, sla_type, target_percentage, penalty_percentage, sla_details)
VALUES
(1, "Limpeza Diária", "Manutenção da limpeza das instalações diariamente.", "quality", 95.00, 5.00, "Limpeza de todas as áreas comuns e salas de aula."),
(2, "Tempo de Resposta a Incidentes", "Tempo máximo para resposta a alertas de segurança.", "response_time", 98.00, 10.00, "Resposta em até 15 minutos para incidentes críticos.");

-- Inserir companies_sla_evaluation
INSERT INTO companies_sla_evaluation (company_id, sla_id, evaluation_period, achieved_percentage, evaluator_id)
VALUES
(1, 1, "2025-03-01", 96.00, 1), -- Limpeza Total - Março - 96% (acima do target)
(2, 2, "2025-03-01", 88.00, 1); -- Segurança Ativa - Março - 88% (abaixo do target, deve gerar multa)

-- Inserir assessment_types
INSERT INTO assessment_types (code, name, description, weight, is_active)
VALUES
("PP1", "Primeira Prova", "Primeira avaliação parcial.", 0.30, TRUE),
("PP2", "Segunda Prova", "Segunda avaliação parcial.", 0.30, TRUE),
("EXF", "Exame Final", "Exame final da disciplina.", 0.40, TRUE);

-- Inserir grades (notas)
INSERT INTO grades (student_id, class_schedules_id, assessment_type_id, score)
VALUES
(7, 1, 1, 15.00), -- Ricardo Gomes - Programação I - PP1 - 15
(7, 1, 2, 12.00), -- Ricardo Gomes - Programação I - PP2 - 12
(8, 1, 1, 10.00), -- Helena Fernandes - Programação I - PP1 - 10
(8, 1, 2, 8.00); -- Helena Fernandes - Programação I - PP2 - 8

-- Inserir user_roles
INSERT INTO user_roles (code, name, description, hierarchy_level)
VALUES
("ADMIN", "Administrador", "Acesso total ao sistema.", 10),
("STUDENT", "Estudante", "Acesso a informações acadêmicas e financeiras.", 1),
("TEACHER", "Professor", "Gestão de turmas e notas.", 5),
("COORDINATOR", "Coordenador de Curso", "Gestão de cursos e aprovações.", 7);

-- Inserir user_role_assignments
INSERT INTO user_role_assignments (user_id, role_id, assigned_by)
VALUES
(1, (SELECT id FROM user_roles WHERE code = "ADMIN"), 1), -- João Silva como Admin
(3, (SELECT id FROM user_roles WHERE code = "COORDINATOR"), 1), -- Pedro Costa como Coordenador
(4, (SELECT id FROM user_roles WHERE code = "COORDINATOR"), 1), -- Ana Pereira como Coordenadora
(5, (SELECT id FROM user_roles WHERE code = "TEACHER"), 1), -- Carlos Almeida como Professor
(6, (SELECT id FROM user_roles WHERE code = "TEACHER"), 1), -- Sofia Martins como Professora
(7, (SELECT id FROM user_roles WHERE code = "STUDENT"), 1), -- Ricardo Gomes como Estudante
(8, (SELECT id FROM user_roles WHERE code = "STUDENT"), 1), -- Helena Fernandes como Estudante
(9, (SELECT id FROM user_roles WHERE code = "STUDENT"), 1); -- Miguel Rodrigues como Estudante

-- Inserir Disponibilidade de Cursos
-- Tabela correta: course_availability (coluna: student_limit)
INSERT INTO course_availability (course_id, academic_year, student_limit, prerequisites)
VALUES
(1, 2025, 50, JSON_ARRAY("Ensino Médio Completo", "Aptidão para Matemática")),
(2, 2025, 40, JSON_ARRAY("Ensino Médio Completo", "Aptidão para Física")),
(3, 2025, 30, JSON_ARRAY("Ensino Médio Completo"));



-- Inserir Logs de Auditoria
INSERT INTO audit_logs (user_id, table_name, operation_type, record_id, new_values, ip_address, user_agent, session_id, description, severity, status)
VALUES
(1, "users", "INSERT", 10, 
    JSON_OBJECT(
        "first_name", "Teste",
        "last_name", "Auditoria",
        "email", "teste.auditoria@isptec.co.ao",
        "status", "active"
    ),
    "192.168.1.1", "Mozilla/5.0", "AUDIT_SESSION_1", "Criação de usuário para teste de auditoria", "LOW", "SUCCESS");
