-- ==============================================================
-- SISTEMA DE GESTÃO ESCOLAR POLITÉCNICA (SIGEPOLI)
-- Índices para Otimização de Consultas
-- ==============================================================
-- 
-- OBJETIVO: Este arquivo define índices para melhorar o desempenho das consultas
-- e operações de busca no banco de dados. Os índices são criados com base em:
-- 1. Colunas frequentemente usadas em cláusulas WHERE, JOIN, ORDER BY e GROUP BY.
-- 2. Chaves estrangeiras (FOREIGN KEYs) para acelerar operações de JOIN.
-- 3. Colunas que garantem unicidade e integridade dos dados.
-- 
-- IMPORTANTE: Este arquivo deve ser executado APÓS a criação das tabelas e constraints.
-- ==============================================================

-- ==========================================================================================
-- ÍNDICES ACADÉMICOS
-- ==========================================================================================

-- Tabela: users
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_status ON users (status);

-- Tabela: students
CREATE INDEX idx_students_student_number ON students (student_number);
CREATE INDEX idx_students_user_id ON students (user_id);

-- Tabela: teachers
CREATE INDEX idx_teachers_staff_id ON teachers (staff_id);

-- Tabela: staff
CREATE INDEX idx_staff_user_id ON staff (user_id);
CREATE INDEX idx_staff_department_id ON staff (department_id);
CREATE INDEX idx_staff_staff_number ON staff (staff_number);

-- Tabela: departments
CREATE INDEX idx_departments_head_staff_id ON departments (head_staff_id);
CREATE INDEX idx_departments_name ON departments (name);
CREATE INDEX idx_departments_acronym ON departments (acronym);

-- Tabela: courses
CREATE INDEX idx_courses_department_id ON courses (department_id);
CREATE INDEX idx_courses_coordinator_staff_id ON courses (coordinator_staff_id);
CREATE INDEX idx_courses_name ON courses (name);

-- Tabela: subjects
CREATE INDEX idx_subjects_code ON subjects (code);
CREATE INDEX idx_subjects_name ON subjects (name);

-- Tabela: classes
CREATE INDEX idx_classes_course_id ON classes (course_id);
CREATE INDEX idx_classes_code ON classes (code);

-- Tabela: class_schedules
CREATE INDEX idx_class_schedules_class_id ON class_schedules (class_id);
CREATE INDEX idx_class_schedules_subject_id ON class_schedules (subject_id);
CREATE INDEX idx_class_schedules_teacher_id ON class_schedules (teacher_id);
CREATE INDEX idx_class_schedules_room_id ON class_schedules (room_id);
CREATE INDEX idx_class_schedules_approved_by ON class_schedules (approved_by);

-- Tabela: student_enrollments
CREATE INDEX idx_student_enrollments_student_id ON student_enrollments (student_id);
CREATE INDEX idx_student_enrollments_course_id ON student_enrollments (course_id);

-- Tabela: class_enrollments
CREATE INDEX idx_class_enrollments_student_id ON class_enrollments (student_id);
CREATE INDEX idx_class_enrollments_class_schedules_id ON class_enrollments (class_schedules_id);

-- Tabela: grades
CREATE INDEX idx_grades_student_id ON grades (student_id);
CREATE INDEX idx_grades_class_schedules_id ON grades (class_schedules_id);
CREATE INDEX idx_grades_assessment_type_id ON grades (assessment_type_id);

-- Tabela: attendance
CREATE INDEX idx_attendance_student_id ON attendance (student_id);
CREATE INDEX idx_attendance_classes_attended_id ON attendance (classes_attended_id);

-- Tabela: course_fees
CREATE INDEX idx_course_fees_course_id ON course_fees (course_id);
CREATE INDEX idx_course_fees_type_payment ON course_fees (type_payment);

-- Tabela: student_fees
CREATE INDEX idx_student_fees_student_id ON student_fees (student_id);
CREATE INDEX idx_student_fees_course_fee_id ON student_fees (course_fee_id);
CREATE INDEX idx_student_fees_payment_id ON student_fees (payment_id);
CREATE INDEX idx_student_fees_status ON student_fees (status);

-- ==========================================================================================
-- ÍNDICES FINANCEIROS
-- ==========================================================================================

-- Tabela: payments
CREATE INDEX idx_payments_payment_method_id ON payments (payment_method_id);
CREATE INDEX idx_payments_reference_number ON payments (reference_number);
CREATE INDEX idx_payments_status ON payments (status);

-- Tabela: student_payments
CREATE INDEX idx_student_payments_payment_id ON student_payments (payment_id);
CREATE INDEX idx_student_payments_student_id ON student_payments (student_id);
CREATE INDEX idx_student_payments_service_id ON student_payments (service_id);

-- Tabela: company_payments
CREATE INDEX idx_company_payments_payment_id ON company_payments (payment_id);
CREATE INDEX idx_company_payments_company_id ON company_payments (company_id);
CREATE INDEX idx_company_payments_budget_id ON company_payments (department_budgets_id);
CREATE INDEX idx_company_payments_approved_by ON company_payments (approved_by_staff);

-- Tabela: staff_payments
CREATE INDEX idx_staff_payments_payment_id ON staff_payments (payment_id);
CREATE INDEX idx_staff_payments_staff_id ON staff_payments (staff_id);

-- Tabela: fines
CREATE INDEX idx_fines_payment_id ON fines (payment_id);
CREATE INDEX idx_fines_fined ON fines (fined);

-- ==========================================================================================
-- ÍNDICES OPERACIONAIS
-- ==========================================================================================

-- Tabela: companies
CREATE INDEX idx_companies_nif ON companies (nif);
CREATE INDEX idx_companies_name ON companies (name);

-- Tabela: companies_contracts
CREATE INDEX idx_companies_contracts_company_id ON companies_contracts (company_id);
CREATE INDEX idx_companies_contracts_signer ON companies_contracts (signed_by_staff);

-- Tabela: companies_sla
CREATE INDEX idx_companies_sla_company_id ON companies_sla (company_id);

-- Tabela: companies_sla_evaluation
CREATE INDEX idx_companies_sla_evaluation_sla_id ON companies_sla_evaluation (sla_id);
CREATE INDEX idx_companies_sla_evaluation_evaluator_id ON companies_sla_evaluation (evaluator_id);

-- ==========================================================================================
-- ÍNDICES DE AUDITORIA
-- ==========================================================================================

-- Tabela: audit_logs
CREATE INDEX idx_audit_logs_user_id ON audit_logs (user_id);
CREATE INDEX idx_audit_logs_table_name ON audit_logs (table_name);
CREATE INDEX idx_audit_logs_operation_type ON audit_logs (operation_type);
CREATE INDEX idx_audit_logs_record_id ON audit_logs (record_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs (created_at);

-- ==========================================================================================
-- ÍNDICES DA BIBLIOTECA
-- ==========================================================================================

-- Tabela: library_loans
-- CREATE INDEX idx_library_loans_item_id ON library_loans (library_item_id);
-- CREATE INDEX idx_library_loans_borrower_id ON library_loans (borrower_id);
-- CREATE INDEX idx_library_loans_loan_date ON library_loans (loan_date);
-- CREATE INDEX idx_library_loans_return_date ON library_loans (return_date);

-- Tabela: library_items
-- CREATE INDEX idx_library_items_barcode ON library_items (barcode);
-- CREATE INDEX idx_library_items_title ON library_items (title);

-- ==========================================================================================
-- ÍNDICES DE NOTIFICAÇÕES
-- ==========================================================================================

-- Tabela: notifications
CREATE INDEX idx_notifications_user_id ON notifications (user_id);
CREATE INDEX idx_notifications_status ON notifications (status);
CREATE INDEX idx_notifications_created_at ON notifications (created_at);

-- ==========================================================================================
-- ÍNDICES DE BUSCA E FILTRAGEM COMUNS
-- ==========================================================================================

-- Tabela: users
CREATE INDEX idx_users_full_name ON users (first_name, last_name);

-- Tabela: academic_qualifications
CREATE INDEX idx_academic_qualifications_user_id ON academic_qualifications (user_id);

-- Tabela: user_identification
CREATE INDEX idx_user_identification_user_id ON user_identification (user_id);
CREATE INDEX idx_user_identification_document_type ON user_identification (document_type);
CREATE INDEX idx_user_identification_document_number ON user_identification (document_number);

-- Tabela: user_health
CREATE INDEX idx_user_health_user_id ON user_health (user_id);

-- Tabela: user_role_assignments
CREATE INDEX idx_user_role_assignments_user_id ON user_role_assignments (user_id);
CREATE INDEX idx_user_role_assignments_role_id ON user_role_assignments (role_id);

-- Tabela: department_budgets
CREATE INDEX idx_department_budgets_department_id ON department_budgets (department_id);
CREATE INDEX idx_department_budgets_fiscal_year ON department_budgets (fiscal_year);

-- Tabela: staff_positions
CREATE INDEX idx_staff_positions_user_id ON staff_positions (user_id);
CREATE INDEX idx_staff_positions_position_id ON staff_positions (position_id);

-- Tabela: staff_leaves
CREATE INDEX idx_staff_leaves_staff_id ON staff_leaves (staff_id);
CREATE INDEX idx_staff_leaves_replacement_staff_id ON staff_leaves (replacement_staff_id);

-- Tabela: evaluation
CREATE INDEX idx_evaluation_initiator_staff_id ON evaluation (iniciator_staff_id);

-- Tabela: staff_evaluation
CREATE INDEX idx_staff_evaluation_evaluation_id ON staff_evaluation (evaluation_id);
CREATE INDEX idx_staff_evaluation_staff_id ON staff_evaluation (staff_id);

-- Tabela: course_evaluation
CREATE INDEX idx_course_evaluation_evaluation_id ON course_evaluation (evaluation_id);
CREATE INDEX idx_course_evaluation_course_id ON course_evaluation (course_id);

-- Tabela: assessment_types
CREATE INDEX idx_assessment_types_code ON assessment_types (code);

-- Tabela: services
CREATE INDEX idx_services_service_types_id ON services (service_types_id);
CREATE INDEX idx_services_department_id ON services (department_id);

-- Tabela: service_evaluation
CREATE INDEX idx_service_evaluation_evaluation_id ON service_evaluation (evaluation_id);
CREATE INDEX idx_service_evaluation_service_id ON service_evaluation (service_id);

-- Tabela: companies_departments
CREATE INDEX idx_companies_departments_company_id ON companies_departments (company_id);
CREATE INDEX idx_companies_departments_department_id ON companies_departments (department_id);

-- Tabela: course_access
CREATE INDEX idx_course_access_user_id ON course_access (user_id);
CREATE INDEX idx_course_access_course_availability_id ON course_access (course_availability_id);

-- Tabela: room_resources
CREATE INDEX idx_room_resources_room_id ON room_resources (room_id);
CREATE INDEX idx_room_resources_resource_id ON room_resources (resource_id);

-- Tabela: room_bookings
CREATE INDEX idx_room_bookings_room_id ON room_bookings (room_id);
CREATE INDEX idx_room_bookings_department_id ON room_bookings (department_id);

-- Tabela: classes_attended
CREATE INDEX idx_classes_attended_class_id ON classes_attended (class_id);
CREATE INDEX idx_classes_attended_time_slot_id ON classes_attended (time_slot_id);

-- Tabela: teacher_specializations
CREATE INDEX idx_teacher_specializations_teacher_id ON teacher_specializations (teacher_id);
CREATE INDEX idx_teacher_specializations_subject_id ON teacher_specializations (subject_id);
CREATE INDEX idx_teacher_specializations_qualification_id ON teacher_specializations (qualification_id);

-- Tabela: teacher_availability
CREATE INDEX idx_teacher_availability_teacher_id ON teacher_availability (teacher_id);
CREATE INDEX idx_teacher_availability_approved_by ON teacher_availability (approved_by);

-- Tabela: time_slots
CREATE INDEX idx_time_slots_start_time ON time_slots (start_time);
CREATE INDEX idx_time_slots_end_time ON time_slots (end_time);

-- Tabela: positions
CREATE INDEX idx_positions_name ON positions (name);

-- Tabela: user_roles
CREATE INDEX idx_user_roles_code ON user_roles (code);

-- Tabela: payment_types
CREATE INDEX idx_payment_types_name ON payment_types (name);

-- Tabela: service_types
CREATE INDEX idx_service_types_name ON service_types (name);

-- Tabela: resources
CREATE INDEX idx_resources_responsible_department_id ON resources (responsible_department_id);

-- Tabela: rooms
CREATE INDEX idx_rooms_name ON rooms (name);
CREATE INDEX idx_rooms_localization ON rooms (localization(100));

-- Tabela: performance
CREATE INDEX idx_performance_evaluation_id ON performance (evaluation_id);
CREATE INDEX idx_performance_evaluator_id ON performance (evaluator_id);

-- Tabela: audit_logs
CREATE INDEX idx_audit_logs_table_name_operation_type ON audit_logs (table_name, operation_type);

-- Tabela: companies_contracts
CREATE INDEX idx_companies_contracts_started_at ON companies_contracts (started_at);
CREATE INDEX idx_companies_contracts_ended_at ON companies_contracts (ended_at);

-- Tabela: companies_sla_evaluation
-- CREATE INDEX idx_companies_sla_evaluation_evaluation_date ON companies_sla_evaluation (evaluation_date);

-- Tabela: student_enrollments
CREATE INDEX idx_student_enrollments_enrollment_date ON student_enrollments (enrollment_date);

-- Tabela: staff_leaves
-- CREATE INDEX idx_staff_leaves_start_date ON staff_leaves (start_date);
-- CREATE INDEX idx_staff_leaves_end_date ON staff_leaves (end_date);

-- Tabela: payments
CREATE INDEX idx_payments_payment_date ON payments (payment_date);

-- Tabela: fines
-- CREATE INDEX idx_fines_fine_date ON fines (fine_date);
-- Nota: Esta tabela não possui coluna fine_date

-- Tabela: course_availability
-- CREATE INDEX idx_course_availability_academic_year ON course_availability (academic_year);

-- Tabela: grades
CREATE INDEX idx_grades_score ON grades (score);

-- Tabela: companies_sla
CREATE INDEX idx_companies_sla_target_percentage ON companies_sla (target_percentage);

-- Tabela: departments
-- CREATE INDEX idx_departments_budget_amount ON departments (budget_amount);

-- Tabela: academic_qualifications
CREATE INDEX idx_academic_qualifications_qualification_type ON academic_qualifications (qualification_type);

-- Tabela: user_identification
CREATE INDEX idx_user_identification_issue_date ON user_identification (issue_date);
-- CREATE INDEX idx_user_identification_expiry_date ON user_identification (expiry_date);

-- Tabela: user_health
-- CREATE INDEX idx_user_health_blood_type ON user_health (blood_type);

-- Tabela: staff_positions
-- CREATE INDEX idx_staff_positions_start_date ON staff_positions (start_date);
-- CREATE INDEX idx_staff_positions_end_date ON staff_positions (end_date);

-- Tabela: evaluation
-- CREATE INDEX idx_evaluation_evaluation_date ON evaluation (evaluation_date);

-- Tabela: classes_attended
-- CREATE INDEX idx_classes_attended_attendance_date ON classes_attended (attendance_date);

-- Tabela: course_access
-- CREATE INDEX idx_course_access_access_date ON course_access (access_date);
-- Nota: Esta tabela não possui coluna access_date

-- Tabela: service_evaluation
-- CREATE INDEX idx_service_evaluation_evaluation_date ON service_evaluation (evaluation_date);

-- Tabela: services
CREATE INDEX idx_services_value ON services (value);

-- Tabela: company_payments
-- CREATE INDEX idx_company_payments_payment_date ON company_payments (payment_date);
-- Nota: Esta tabela não possui coluna payment_date diretamente, 
-- mas referencia payments através de payment_id

-- Tabela: staff_payments
-- CREATE INDEX idx_staff_payments_payment_date ON staff_payments (payment_date);
-- Nota: Esta tabela não possui coluna payment_date diretamente, 
-- mas referencia payments através de payment_id

-- Tabela: companies_departments
-- CREATE INDEX idx_companies_departments_assignment_date ON companies_departments (assignment_date);
-- Nota: Esta tabela não possui coluna assignment_date

-- Tabela: student_fees
CREATE INDEX idx_student_fees_reference_month ON student_fees (reference_month);

-- Tabela: course_fees
CREATE INDEX idx_course_fees_start_at ON course_fees (start_at);
CREATE INDEX idx_course_fees_end_at ON course_fees (end_at);