-- ==============================================================
-- SISTEMA DE GESTÃO ESCOLAR POLITÉCNICA (SIGEPOLI)
-- Constraints e Integridade Referencial
-- ==============================================================
-- 
-- OBJETIVO: Este arquivo define todas as constraints do banco de dados para garantir:
-- 1. INTEGRIDADE REFERENCIAL: Foreign Keys que mantêm relacionamentos consistentes
-- 2. INTEGRIDADE DE DOMÍNIO: Check constraints que validam dados (ex: notas 0-20)
-- 3. INTEGRIDADE DE ENTIDADE: Unique constraints que evitam duplicações
-- 4. REGRAS DE NEGÓCIO: Implementação das RN01-RN06 do projeto
-- 
-- ESTRUTURA:
-- - FOREIGN KEYS: Relacionamentos entre tabelas com regras de DELETE apropriadas
-- - CHECK CONSTRAINTS: Validações de dados (RN03: notas 0-20, percentuais 0-100, etc.)
-- - UNIQUE CONSTRAINTS: Campos únicos e chaves compostas
-- 
-- IMPORTANTE: Este arquivo deve ser executado APÓS a criação das tabelas (02_create_tables.sql)
-- ==============================================================

-- ==========================================================================================
-- CONSTRAINTS ACADÉMICAS
-- ==========================================================================================

-- CURSOS
ALTER TABLE courses 
ADD CONSTRAINT fk_courses_department 
FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT;

ALTER TABLE courses 
ADD CONSTRAINT fk_courses_coordinator_staff 
FOREIGN KEY (coordinator_staff_id) REFERENCES staff(user_id) ON DELETE RESTRICT;

ALTER TABLE courses 
ADD CONSTRAINT uq_courses_coordinator_staff UNIQUE (coordinator_staff_id);

-- DISCIPLINAS E CURSOS
ALTER TABLE course_subjects 
ADD CONSTRAINT fk_course_subjects_subject 
FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE;

ALTER TABLE course_subjects 
ADD CONSTRAINT fk_course_subjects_course 
FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE;

-- DISPONIBILIDADE DE CURSOS
ALTER TABLE course_availability 
ADD CONSTRAINT fk_course_availability_course 
FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE;

-- TURMAS
ALTER TABLE classes 
ADD CONSTRAINT fk_classes_course 
FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE;

-- HORÁRIOS DAS TURMAS
ALTER TABLE class_schedules 
ADD CONSTRAINT fk_class_schedules_class 
FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE;

ALTER TABLE class_schedules 
ADD CONSTRAINT fk_class_schedules_subject 
FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE RESTRICT;

ALTER TABLE class_schedules 
ADD CONSTRAINT fk_class_schedules_teacher 
FOREIGN KEY (teacher_id) REFERENCES teachers(staff_id) ON DELETE RESTRICT;

ALTER TABLE class_schedules 
ADD CONSTRAINT fk_class_schedules_room 
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE SET NULL;

ALTER TABLE class_schedules 
ADD CONSTRAINT fk_class_schedules_approved_by 
FOREIGN KEY (approved_by) REFERENCES staff(user_id) ON DELETE SET NULL;

-- SALAS E RECURSOS
ALTER TABLE room_resources 
ADD CONSTRAINT fk_room_resources_room 
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;

ALTER TABLE room_resources 
ADD CONSTRAINT fk_room_resources_resource 
FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE;

ALTER TABLE resources 
ADD CONSTRAINT fk_resources_department 
FOREIGN KEY (responsible_department_id) REFERENCES departments(id) ON DELETE RESTRICT;

-- RESERVAS DE SALAS
ALTER TABLE room_bookings 
ADD CONSTRAINT fk_room_bookings_room 
FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE;

ALTER TABLE room_bookings 
ADD CONSTRAINT fk_room_bookings_department 
FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE;

-- ALUNOS
ALTER TABLE students 
ADD CONSTRAINT fk_students_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE students 
ADD CONSTRAINT uq_students_student_number UNIQUE (student_number);

-- MATRÍCULAS
ALTER TABLE student_enrollments 
ADD CONSTRAINT fk_student_enrollments_student 
FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE;

ALTER TABLE student_enrollments 
ADD CONSTRAINT fk_student_enrollments_course 
FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE;

-- MATRÍCULAS EM TURMAS
ALTER TABLE class_enrollments 
ADD CONSTRAINT fk_class_enrollments_student 
FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE;

ALTER TABLE class_enrollments 
ADD CONSTRAINT fk_class_enrollments_class_schedules 
FOREIGN KEY (class_schedules_id) REFERENCES class_schedules(id) ON DELETE CASCADE;

-- PROFESSORES
ALTER TABLE teachers 
ADD CONSTRAINT fk_teachers_staff 
FOREIGN KEY (staff_id) REFERENCES staff(user_id) ON DELETE CASCADE;

-- ESPECIALIZAÇÕES DE PROFESSORES
ALTER TABLE teacher_specializations 
ADD CONSTRAINT fk_teacher_specializations_teacher 
FOREIGN KEY (teacher_id) REFERENCES teachers(staff_id) ON DELETE CASCADE;

ALTER TABLE teacher_specializations 
ADD CONSTRAINT fk_teacher_specializations_subject 
FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE;

ALTER TABLE teacher_specializations 
ADD CONSTRAINT fk_teacher_specializations_qualification 
FOREIGN KEY (qualification_id) REFERENCES academic_qualifications(id) ON DELETE SET NULL;

-- HORÁRIOS DISPONÍVEIS POR PROFESSOR
ALTER TABLE teacher_availability 
ADD CONSTRAINT fk_teacher_availability_teacher 
FOREIGN KEY (teacher_id) REFERENCES teachers(staff_id) ON DELETE CASCADE;

ALTER TABLE teacher_availability 
ADD CONSTRAINT fk_teacher_availability_approved_by 
FOREIGN KEY (approved_by) REFERENCES staff(user_id) ON DELETE SET NULL;

-- NOTAS
ALTER TABLE grades 
ADD CONSTRAINT fk_grades_student 
FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE;

ALTER TABLE grades 
ADD CONSTRAINT fk_grades_class 
FOREIGN KEY (class_schedules_id) REFERENCES class_schedules(id) ON DELETE CASCADE;

ALTER TABLE grades 
ADD CONSTRAINT fk_grades_assessment_type 
FOREIGN KEY (assessment_type_id) REFERENCES assessment_types(id) ON DELETE RESTRICT;

-- FREQUÊNCIA
ALTER TABLE attendance 
ADD CONSTRAINT fk_attendance_student 
FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE;

ALTER TABLE attendance 
ADD CONSTRAINT fk_attendance_classes_attended 
FOREIGN KEY (classes_attended_id) REFERENCES classes_attended(id) ON DELETE CASCADE;

-- AULAS MINISTRADAS
ALTER TABLE classes_attended 
ADD CONSTRAINT fk_classes_attended_class 
FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE;

ALTER TABLE classes_attended 
ADD CONSTRAINT fk_classes_attended_time_slot 
FOREIGN KEY (time_slot_id) REFERENCES time_slots(id) ON DELETE RESTRICT;

-- ==========================================================================================
-- CONSTRAINTS PARA PERFORMANCE
-- ==========================================================================================

ALTER TABLE performance 
ADD CONSTRAINT fk_performance_evaluation 
FOREIGN KEY (evaluation_id) REFERENCES evaluation(id) ON DELETE CASCADE;

ALTER TABLE performance 
ADD CONSTRAINT fk_performance_evaluator 
FOREIGN KEY (evaluator_id) REFERENCES users(id) ON DELETE RESTRICT;

-- ==========================================================================================
-- CONSTRAINTS ADMINISTRATIVAS
-- ==========================================================================================

-- PAPÉIS DE USUÁRIOS
ALTER TABLE user_role_assignments 
ADD CONSTRAINT fk_user_role_assignments_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE user_role_assignments 
ADD CONSTRAINT fk_user_role_assignments_role 
FOREIGN KEY (role_id) REFERENCES user_roles(id) ON DELETE CASCADE;

ALTER TABLE user_role_assignments 
ADD CONSTRAINT fk_user_role_assignments_assigned_by 
FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL;

-- IDENTIFICAÇÃO DE USUÁRIOS
ALTER TABLE user_identification 
ADD CONSTRAINT fk_user_identification_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- SAÚDE DO USUÁRIO
ALTER TABLE user_health 
ADD CONSTRAINT fk_user_health_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- DEPARTAMENTOS
ALTER TABLE departments 
ADD CONSTRAINT fk_departments_head_staff 
FOREIGN KEY (head_staff_id) REFERENCES staff(user_id) ON DELETE RESTRICT;

ALTER TABLE departments 
ADD CONSTRAINT uq_departments_name UNIQUE (name);

ALTER TABLE departments 
ADD CONSTRAINT uq_departments_acronym UNIQUE (acronym);

-- ORÇAMENTOS POR DEPARTAMENTO
ALTER TABLE department_budgets 
ADD CONSTRAINT fk_department_budgets_department 
FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE;

-- FUNCIONÁRIOS
ALTER TABLE staff 
ADD CONSTRAINT fk_staff_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE staff 
ADD CONSTRAINT fk_staff_department 
FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL;

-- QUALIFICAÇÕES ACADÉMICAS
ALTER TABLE academic_qualifications 
ADD CONSTRAINT fk_academic_qualifications_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- CARGOS DOS FUNCIONÁRIOS
ALTER TABLE staff_positions 
ADD CONSTRAINT fk_staff_positions_user 
FOREIGN KEY (user_id) REFERENCES staff(user_id) ON DELETE CASCADE;

ALTER TABLE staff_positions 
ADD CONSTRAINT fk_staff_positions_position 
FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE CASCADE;

-- FÉRIAS E LICENÇAS
ALTER TABLE staff_leaves 
ADD CONSTRAINT fk_staff_leaves_staff 
FOREIGN KEY (staff_id) REFERENCES staff(user_id) ON DELETE CASCADE;

ALTER TABLE staff_leaves 
ADD CONSTRAINT fk_staff_leaves_replacement 
FOREIGN KEY (replacement_staff_id) REFERENCES staff(user_id) ON DELETE SET NULL;

-- AVALIAÇÕES
ALTER TABLE evaluation 
ADD CONSTRAINT fk_evaluation_initiator 
FOREIGN KEY (iniciator_staff_id) REFERENCES staff(user_id) ON DELETE RESTRICT;

-- AVALIAÇÕES DE FUNCIONÁRIOS
ALTER TABLE staff_evaluation 
ADD CONSTRAINT fk_staff_evaluation_evaluation 
FOREIGN KEY (evaluation_id) REFERENCES evaluation(id) ON DELETE CASCADE;

ALTER TABLE staff_evaluation 
ADD CONSTRAINT fk_staff_evaluation_staff 
FOREIGN KEY (staff_id) REFERENCES staff(user_id) ON DELETE CASCADE;

-- AVALIAÇÕES DE CURSOS
ALTER TABLE course_evaluation 
ADD CONSTRAINT fk_course_evaluation_evaluation 
FOREIGN KEY (evaluation_id) REFERENCES evaluation(id) ON DELETE CASCADE;

ALTER TABLE course_evaluation 
ADD CONSTRAINT fk_course_evaluation_course 
FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE;

-- TIPOS DE AVALIAÇÃO
ALTER TABLE assessment_types 
ADD CONSTRAINT uq_assessment_types_code UNIQUE (code);

-- ==========================================================================================
-- CONSTRAINTS FINANCEIRAS
-- ==========================================================================================

-- PAGAMENTOS
ALTER TABLE payments 
ADD CONSTRAINT fk_payments_method 
FOREIGN KEY (payment_method_id) REFERENCES payment_types(id) ON DELETE RESTRICT;

-- PAGAMENTOS DE ALUNOS
ALTER TABLE student_payments 
ADD CONSTRAINT fk_student_payments_payment 
FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE;

ALTER TABLE student_payments 
ADD CONSTRAINT fk_student_payments_service 
FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT;

ALTER TABLE student_payments 
ADD CONSTRAINT fk_student_payments_student 
FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE CASCADE;

-- PAGAMENTOS A EMPRESAS
ALTER TABLE company_payments 
ADD CONSTRAINT fk_company_payments_payment 
FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE;

ALTER TABLE company_payments 
ADD CONSTRAINT fk_company_payments_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE company_payments 
ADD CONSTRAINT fk_company_payments_budget 
FOREIGN KEY (department_budgets_id) REFERENCES department_budgets(id) ON DELETE RESTRICT;

ALTER TABLE company_payments 
ADD CONSTRAINT fk_company_payments_approver 
FOREIGN KEY (approved_by_staff) REFERENCES users(id) ON DELETE RESTRICT;

-- PAGAMENTOS A FUNCIONÁRIOS
ALTER TABLE staff_payments 
ADD CONSTRAINT fk_staff_payments_payment 
FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE;

ALTER TABLE staff_payments 
ADD CONSTRAINT fk_staff_payments_staff 
FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE CASCADE;

-- MULTAS
ALTER TABLE fines 
ADD CONSTRAINT fk_fines_payment 
FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE;

-- ==========================================================================================
-- CONSTRAINTS OPERACIONAIS
-- ==========================================================================================

-- EMPRESAS POR DEPARTAMENTO
ALTER TABLE companies_departments 
ADD CONSTRAINT fk_companies_departments_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE companies_departments 
ADD CONSTRAINT fk_companies_departments_department 
FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE;

-- CONTRATOS DE EMPRESAS
ALTER TABLE companies_contracts 
ADD CONSTRAINT fk_companies_contracts_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE companies_contracts 
ADD CONSTRAINT fk_companies_contracts_signer 
FOREIGN KEY (signed_by_staff) REFERENCES users(id) ON DELETE RESTRICT;

-- SLA
ALTER TABLE companies_sla 
ADD CONSTRAINT fk_companies_sla_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE companies_sla 
ADD CONSTRAINT fk_companies_sla_evaluation_company 
FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE companies_sla_evaluation 
ADD CONSTRAINT fk_companies_sla_evaluation_sla 
FOREIGN KEY (sla_id) REFERENCES companies_sla(id) ON DELETE CASCADE;

ALTER TABLE companies_sla_evaluation 
ADD CONSTRAINT fk_companies_sla_evaluation_evaluator 
FOREIGN KEY (evaluator_id) REFERENCES users(id) ON DELETE RESTRICT;

-- ==========================================================================================
-- CONSTRAINTS DE AUDITORIA
-- ==========================================================================================

-- LOGS DE AUDITORIA
ALTER TABLE audit_logs 
ADD CONSTRAINT fk_audit_logs_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- ==========================================================================================
-- CONSTRAINTS DA BIBLIOTECA
-- ==========================================================================================

-- EMPRÉSTIMOS DA BIBLIOTECA
ALTER TABLE library_loans 
ADD CONSTRAINT fk_library_loans_item 
FOREIGN KEY (library_item_id) REFERENCES library_items(id) ON DELETE CASCADE;

ALTER TABLE library_loans 
ADD CONSTRAINT fk_library_loans_borrower 
FOREIGN KEY (borrower_id) REFERENCES users(id) ON DELETE CASCADE;

-- ==========================================================================================
-- CONSTRAINTS DE NOTIFICAÇÕES
-- ==========================================================================================

-- NOTIFICAÇÕES
ALTER TABLE notifications 
ADD CONSTRAINT fk_notifications_user 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- ==========================================================================================
-- CHECK CONSTRAINTS
-- ==========================================================================================

-- VALIDAÇÃO DE NOTAS (RN03)
ALTER TABLE grades 
ADD CONSTRAINT check_grades_score_range 
CHECK (score >= 0 AND score <= 20);

-- VALIDAÇÃO DE AVALIAÇÕES DE SLA
ALTER TABLE companies_sla_evaluation 
ADD CONSTRAINT check_sla_evaluation_percentage 
CHECK (achieved_percentage >= 0 AND achieved_percentage <= 100);

-- VALIDAÇÃO DE SLA
ALTER TABLE companies_sla 
ADD CONSTRAINT check_sla_target_percentage 
CHECK (target_percentage >= 0 AND target_percentage <= 100);

ALTER TABLE companies_sla 
ADD CONSTRAINT check_sla_penalty_percentage 
CHECK (penalty_percentage >= 0 AND penalty_percentage <= 100);

-- VALIDAÇÃO DE DATAS
ALTER TABLE student_enrollments 
ADD CONSTRAINT check_enrollment_dates 
CHECK (enrollment_date <= conclusion_date);

ALTER TABLE staff_leaves 
ADD CONSTRAINT check_leave_dates 
CHECK (start_date <= end_date);

-- VALIDAÇÃO DE VALORES MONETÁRIOS
ALTER TABLE payments 
ADD CONSTRAINT check_payment_amount 
CHECK (amount > 0);

ALTER TABLE fines 
ADD CONSTRAINT check_fine_amount 
CHECK (amount > 0);

-- VALIDAÇÃO DE CAPACIDADE DE SALAS
ALTER TABLE rooms 
ADD CONSTRAINT check_room_capacity 
CHECK (capacity > 0);

-- VALIDAÇÃO DE CARGA HORÁRIA
ALTER TABLE subjects 
ADD CONSTRAINT check_subject_workload 
CHECK (workload_hours > 0);

-- VALIDAÇÃO DE DURAÇÃO DE CURSOS
ALTER TABLE courses 
ADD CONSTRAINT check_course_duration 
CHECK (duration_semesters > 0);

-- ==========================================================================================
-- UNIQUE CONSTRAINTS
-- ==========================================================================================

-- CHAVES ÚNICAS COMPOSTAS
ALTER TABLE course_availability 
ADD CONSTRAINT unique_course_academic_year 
UNIQUE (course_id, academic_year);

ALTER TABLE class_schedules 
ADD CONSTRAINT unique_class_subject_teacher 
UNIQUE (class_id, subject_id, teacher_id);

ALTER TABLE room_resources 
ADD CONSTRAINT unique_room_resource 
UNIQUE (room_id, resource_id);

ALTER TABLE user_role_assignments 
ADD CONSTRAINT unique_user_role 
UNIQUE (user_id, role_id);

ALTER TABLE companies_departments 
ADD CONSTRAINT unique_company_department 
UNIQUE (company_id, department_id);

-- Cursos
ALTER TABLE courses ADD CONSTRAINT unique_course_name UNIQUE (name);
-- Disciplinas
ALTER TABLE subjects ADD CONSTRAINT unique_subject_code UNIQUE (code);
-- Turmas
ALTER TABLE classes ADD CONSTRAINT unique_class_code UNIQUE (code);
-- Salas
ALTER TABLE rooms ADD CONSTRAINT unique_room_name UNIQUE (name);
ALTER TABLE rooms ADD CONSTRAINT unique_room_localization UNIQUE (localization(255));
-- Recursos
ALTER TABLE resources ADD CONSTRAINT unique_resource_name UNIQUE (name);
-- Alunos
ALTER TABLE students ADD CONSTRAINT unique_student_number UNIQUE (student_number);
-- Tipos de avaliação
ALTER TABLE assessment_types ADD CONSTRAINT unique_assessment_type_code UNIQUE (code);
-- Usuários
ALTER TABLE users ADD CONSTRAINT unique_user_email UNIQUE (email);
-- Papéis
ALTER TABLE user_roles ADD CONSTRAINT unique_user_role_code UNIQUE (code);
-- Documentos
ALTER TABLE user_identification ADD CONSTRAINT unique_document_number UNIQUE (document_number);
-- Departamentos
ALTER TABLE departments ADD CONSTRAINT unique_department_name UNIQUE (name);
ALTER TABLE departments ADD CONSTRAINT unique_department_acronym UNIQUE (acronym);
-- Funcionários
ALTER TABLE staff ADD CONSTRAINT unique_staff_number UNIQUE (staff_number);
-- Cargos
ALTER TABLE positions ADD CONSTRAINT unique_position_name UNIQUE (name);
-- Serviços
ALTER TABLE services ADD CONSTRAINT unique_service_name UNIQUE (name);
-- Categorias de serviço
ALTER TABLE service_types ADD CONSTRAINT unique_service_type_name UNIQUE (name);
-- Tipos de pagamento
ALTER TABLE payment_types ADD CONSTRAINT unique_payment_type_name UNIQUE (name);
-- Empresas
ALTER TABLE companies ADD CONSTRAINT unique_company_nif UNIQUE (nif);
-- Itens da biblioteca
ALTER TABLE library_items ADD CONSTRAINT unique_library_item_barcode UNIQUE (barcode);
-- Pagamentos
ALTER TABLE payments ADD CONSTRAINT unique_payment_reference_number UNIQUE (reference_number);

ALTER TABLE course_access
ADD CONSTRAINT fk_course_access_user
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE course_access
ADD CONSTRAINT fk_course_access_course_availability
FOREIGN KEY (course_availability_id) REFERENCES course_availability(id) ON DELETE CASCADE;

ALTER TABLE service_evaluation
ADD CONSTRAINT fk_service_evaluation_evaluation
FOREIGN KEY (evaluation_id) REFERENCES evaluation(id) ON DELETE CASCADE;

ALTER TABLE service_evaluation
ADD CONSTRAINT fk_service_evaluation_service
FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE;

ALTER TABLE services
ADD CONSTRAINT fk_services_service_types
FOREIGN KEY (service_types_id) REFERENCES service_types(id) ON DELETE RESTRICT;

ALTER TABLE services
ADD CONSTRAINT fk_services_department
FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT; 

-- CONSTRAINTS PARA course_fees
ALTER TABLE course_fees
ADD CONSTRAINT fk_course_fees_course
FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE RESTRICT;

-- CONSTRAINTS PARA student_fees
ALTER TABLE student_fees
ADD CONSTRAINT fk_student_fees_student
FOREIGN KEY (student_id) REFERENCES students(user_id) ON DELETE RESTRICT;

ALTER TABLE student_fees
ADD CONSTRAINT fk_student_fees_course_fee
FOREIGN KEY (course_fee_id) REFERENCES course_fees(id) ON DELETE SET NULL;

ALTER TABLE student_fees
ADD CONSTRAINT fk_student_fees_payment
FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE RESTRICT;
