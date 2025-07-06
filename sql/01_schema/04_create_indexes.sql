-- ==============================================================
-- SISTEMA DE GESTÃO ESCOLAR POLITÉCNICA (SIGEPOLI)
-- Índices para Otimização de Performance
-- ==============================================================

-- ==========================================================================================
-- ÍNDICES ACADÉMICOS
-- ==========================================================================================

-- CURSOS
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_courses_coordinator ON courses(coordinator_user_id);
CREATE INDEX idx_courses_status ON courses(status);
CREATE INDEX idx_courses_level ON courses(level);

-- DISCIPLINAS
CREATE INDEX idx_subjects_code ON subjects(code);
CREATE INDEX idx_subjects_workload ON subjects(workload_hours);

-- RELAÇÃO CURSO-DISCIPLINA
CREATE INDEX idx_course_subjects_course ON course_subjects(course_id);
CREATE INDEX idx_course_subjects_subject ON course_subjects(subject_id);
CREATE INDEX idx_course_subjects_semester ON course_subjects(semester);

-- DISPONIBILIDADE DE CURSOS
CREATE INDEX idx_course_availability_year ON course_availability(academic_year);
CREATE INDEX idx_course_availability_course_year ON course_availability(course_id, academic_year);

-- TURMAS
CREATE INDEX idx_classes_course ON classes(course_id);
CREATE INDEX idx_classes_academic_year ON classes(academic_year);
CREATE INDEX idx_classes_semester ON classes(semester);
CREATE INDEX idx_classes_course_year_semester ON classes(course_id, academic_year, semester);

-- HORÁRIOS
CREATE INDEX idx_time_slots_day_shift ON time_slots(day_of_week, shift);
CREATE INDEX idx_time_slots_start_time ON time_slots(start_time);

-- HORÁRIOS DAS TURMAS
CREATE INDEX idx_class_schedules_class ON class_schedules(class_id);
CREATE INDEX idx_class_schedules_teacher ON class_schedules(teacher_id);
CREATE INDEX idx_class_schedules_subject ON class_schedules(subject_id);
CREATE INDEX idx_class_schedules_room ON class_schedules(room_id);
CREATE INDEX idx_class_schedules_teacher_time ON class_schedules(teacher_id, time_slot_ids);

-- SALAS
CREATE INDEX idx_rooms_type ON rooms(type_of_room);
CREATE INDEX idx_rooms_capacity ON rooms(capacity);
CREATE INDEX idx_rooms_available ON rooms(is_available);
CREATE INDEX idx_rooms_accessibility ON rooms(acessibility);

-- RECURSOS
CREATE INDEX idx_resources_department ON resources(responsible_department_id);

-- RECURSOS POR SALA
CREATE INDEX idx_room_resources_room ON room_resources(room_id);
CREATE INDEX idx_room_resources_status ON room_resources(status_resources);

-- RESERVAS DE SALAS
CREATE INDEX idx_room_bookings_room ON room_bookings(room_id);
CREATE INDEX idx_room_bookings_date ON room_bookings(date);
CREATE INDEX idx_room_bookings_status ON room_bookings(status);
CREATE INDEX idx_room_bookings_room_date ON room_bookings(room_id, date);

-- ALUNOS
CREATE INDEX idx_students_number ON students(student_number);
CREATE INDEX idx_students_studying ON students(studying);
CREATE INDEX idx_students_searching ON students(searching);

-- MATRÍCULAS
CREATE INDEX idx_student_enrollments_student ON student_enrollments(student_id);
CREATE INDEX idx_student_enrollments_course ON student_enrollments(course_id);
CREATE INDEX idx_student_enrollments_status ON student_enrollments(status);
CREATE INDEX idx_student_enrollments_date ON student_enrollments(enrollment_date);
CREATE INDEX idx_student_enrollments_student_status ON student_enrollments(student_id, status);

-- MATRÍCULAS EM TURMAS
CREATE INDEX idx_class_enrollments_student ON class_enrollments(student_id);
CREATE INDEX idx_class_enrollments_class ON class_enrollments(class_id);
CREATE INDEX idx_class_enrollments_status ON class_enrollments(status);
CREATE INDEX idx_class_enrollments_student_status ON class_enrollments(student_id, status);

-- PROFESSORES
CREATE INDEX idx_teachers_academic_rank ON teachers(academic_rank);
CREATE INDEX idx_teachers_tenure_status ON teachers(tenure_status);
CREATE INDEX idx_teachers_thesis_advisor ON teachers(is_thesis_advisor);

-- ESPECIALIZAÇÕES DE PROFESSORES
CREATE INDEX idx_teacher_specializations_teacher ON teacher_specializations(teacher_id);
CREATE INDEX idx_teacher_specializations_subject ON teacher_specializations(subject_id);
CREATE INDEX idx_teacher_specializations_level ON teacher_specializations(proficiency_level);

-- HORÁRIOS DISPONÍVEIS POR PROFESSOR
CREATE INDEX idx_teacher_availability_teacher ON teacher_availability(teacher_id);
CREATE INDEX idx_teacher_availability_approved ON teacher_availability(aproved);

-- NOTAS
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_class ON grades(class_id);
CREATE INDEX idx_grades_assessment_type ON grades(assessment_type_id);
CREATE INDEX idx_grades_score ON grades(score);
CREATE INDEX idx_grades_student_class ON grades(student_id, class_id);
CREATE INDEX idx_grades_created_at ON grades(created_at);

-- TIPOS DE AVALIAÇÃO
CREATE INDEX idx_assessment_types_code ON assessment_types(code);
CREATE INDEX idx_assessment_types_active ON assessment_types(is_active);

-- FREQUÊNCIA
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_class_attended ON attendance(classes_attended_id);
CREATE INDEX idx_attendance_status ON attendance(status);
CREATE INDEX idx_attendance_created_at ON attendance(created_at);

-- AULAS MINISTRADAS
CREATE INDEX idx_classes_attended_class ON classes_attended(class_id);
CREATE INDEX idx_classes_attended_date ON classes_attended(class_date);
CREATE INDEX idx_classes_attended_time_slot ON classes_attended(time_slot_id);
CREATE INDEX idx_classes_attended_class_date ON classes_attended(class_id, class_date);

-- ==========================================================================================
-- ÍNDICES ADMINISTRATIVOS
-- ==========================================================================================

-- USUÁRIOS
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_verified ON users(is_verified);
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_users_name ON users(first_name, last_name);

-- PAPÉIS DE USUÁRIOS
CREATE INDEX idx_user_roles_code ON user_roles(code);
CREATE INDEX idx_user_roles_active ON user_roles(is_active);
CREATE INDEX idx_user_roles_hierarchy ON user_roles(hierarchy_level);

-- ATRIBUIÇÕES DE PAPÉIS
CREATE INDEX idx_user_role_assignments_user ON user_role_assignments(user_id);
CREATE INDEX idx_user_role_assignments_role ON user_role_assignments(role_id);
CREATE INDEX idx_user_role_assignments_active ON user_role_assignments(is_active);
CREATE INDEX idx_user_role_assignments_expires ON user_role_assignments(expires_at);

-- IDENTIFICAÇÃO DE USUÁRIOS
CREATE INDEX idx_user_identification_user ON user_identification(user_id);
CREATE INDEX idx_user_identification_document ON user_identification(document_number);
CREATE INDEX idx_user_identification_type ON user_identification(document_type);

-- SAÚDE DO USUÁRIO
CREATE INDEX idx_user_health_user ON user_health(user_id);
CREATE INDEX idx_user_health_accessibility ON user_health(need_assessibility);

-- DEPARTAMENTOS
CREATE INDEX idx_departments_head ON departments(head_user_id);
CREATE INDEX idx_departments_status ON departments(status);
CREATE INDEX idx_departments_classification ON departments(classification);
CREATE INDEX idx_departments_acronym ON departments(acronym);

-- ORÇAMENTOS POR DEPARTAMENTO
CREATE INDEX idx_department_budgets_department ON department_budgets(department_id);
CREATE INDEX idx_department_budgets_fiscal_year ON department_budgets(fiscal_year);
CREATE INDEX idx_department_budgets_on_account ON department_budgets(on_account);

-- FUNCIONÁRIOS
CREATE INDEX idx_staff_number ON staff(staff_number);
CREATE INDEX idx_staff_department ON staff(department_id);
CREATE INDEX idx_staff_status ON staff(status);
CREATE INDEX idx_staff_category ON staff(staff_category);
CREATE INDEX idx_staff_employment_type ON staff(employment_type);
CREATE INDEX idx_staff_hire_date ON staff(hire_date);

-- QUALIFICAÇÕES ACADÉMICAS
CREATE INDEX idx_academic_qualifications_user ON academic_qualifications(user_id);
CREATE INDEX idx_academic_qualifications_type ON academic_qualifications(qualification_type);
CREATE INDEX idx_academic_qualifications_verified ON academic_qualifications(is_verified);
CREATE INDEX idx_academic_qualifications_completion ON academic_qualifications(completion_date);

-- CARGOS
CREATE INDEX idx_positions_name ON positions(name);

-- CARGOS DOS FUNCIONÁRIOS
CREATE INDEX idx_staff_positions_user ON staff_positions(user_id);
CREATE INDEX idx_staff_positions_position ON staff_positions(position_id);
CREATE INDEX idx_staff_positions_status ON staff_positions(status);
CREATE INDEX idx_staff_positions_dates ON staff_positions(start_date, end_date);

-- FÉRIAS E LICENÇAS
CREATE INDEX idx_staff_leaves_staff ON staff_leaves(staff_id);
CREATE INDEX idx_staff_leaves_type ON staff_leaves(leave_type);
CREATE INDEX idx_staff_leaves_status ON staff_leaves(status);
CREATE INDEX idx_staff_leaves_dates ON staff_leaves(start_date, end_date);

-- AVALIAÇÕES
CREATE INDEX idx_evaluation_initiator ON evaluation(iniciator_user_id);
CREATE INDEX idx_evaluation_type_evaluated ON evaluation(type_of_evaluated);
CREATE INDEX idx_evaluation_type_evaluator ON evaluation(type_of_evaluator);
CREATE INDEX idx_evaluation_status ON evaluation(status_evaluation);
CREATE INDEX idx_evaluation_dates ON evaluation(evaluation_date_start, evaluation_date_end);

-- AVALIAÇÕES DE FUNCIONÁRIOS
CREATE INDEX idx_staff_evaluation_evaluation ON staff_evaluation(evaluation_id);
CREATE INDEX idx_staff_evaluation_staff ON staff_evaluation(staff_id);

-- AVALIAÇÕES DE CURSOS
CREATE INDEX idx_course_evaluation_evaluation ON course_evaluation(evaluation_id);
CREATE INDEX idx_course_evaluation_course ON course_evaluation(course_id);

-- PERFORMANCE
CREATE INDEX idx_performance_evaluation ON performance(evaluation_id);
CREATE INDEX idx_performance_evaluator ON performance(evaluator_id);
CREATE INDEX idx_performance_date ON performance(evaluation_date);
CREATE INDEX idx_performance_status ON performance(status);
CREATE INDEX idx_performance_score ON performance(overall_score);

-- ACESSO DE ALUNOS NO CURSO
CREATE INDEX idx_course_access_user ON course_access(user_id);
CREATE INDEX idx_course_access_availability ON course_access(course_availability_id);
CREATE INDEX idx_course_access_status ON course_access(status);
CREATE INDEX idx_course_access_exam_score ON course_access(exam_score);

-- SERVIÇOS
CREATE INDEX idx_services_type ON services(service_types_id);
CREATE INDEX idx_services_department ON services(departament_id);
CREATE INDEX idx_services_status ON services(status);
CREATE INDEX idx_services_value ON services(value);

-- TIPOS DE SERVIÇOS
CREATE INDEX idx_service_types_name ON service_types(name);

-- AVALIAÇÕES DE SERVIÇOS
CREATE INDEX idx_service_evaluation_evaluation ON service_evaluation(evaluation_id);
CREATE INDEX idx_service_evaluation_service ON service_evaluation(service_id);

-- ==========================================================================================
-- ÍNDICES FINANCEIROS
-- ==========================================================================================

-- PAGAMENTOS
CREATE INDEX idx_payments_method ON payments(payment_method_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_date ON payments(payment_date);
CREATE INDEX idx_payments_amount ON payments(amount);
CREATE INDEX idx_payments_reference ON payments(reference_number);

-- TIPOS DE PAGAMENTO
CREATE INDEX idx_payment_types_name ON payment_types(name);

-- PAGAMENTOS DE ALUNOS
CREATE INDEX idx_studant_payments_payment ON studant_payments(payment_id);
CREATE INDEX idx_studant_payments_service ON studant_payments(service_id);
CREATE INDEX idx_studant_payments_student ON studant_payments(student_id);

-- PAGAMENTOS A EMPRESAS
CREATE INDEX idx_company_payments_payment ON company_payments(payment_id);
CREATE INDEX idx_company_payments_company ON company_payments(company_id);
CREATE INDEX idx_company_payments_budget ON company_payments(department_budgets_id);
CREATE INDEX idx_company_payments_approver ON company_payments(approved_by_staff);

-- PAGAMENTOS A FUNCIONÁRIOS
CREATE INDEX idx_staff_payments_payment ON staff_payments(payment_id);
CREATE INDEX idx_staff_payments_staff ON staff_payments(staff_id);
CREATE INDEX idx_staff_payments_type ON staff_payments(type_of_payment);

-- MULTAS
CREATE INDEX idx_fines_payment ON fines(payment_id);
CREATE INDEX idx_fines_type ON fines(fined);
CREATE INDEX idx_fines_amount ON fines(amount);
CREATE INDEX idx_fines_created_at ON fines(created_at);

-- ==========================================================================================
-- ÍNDICES OPERACIONAIS
-- ==========================================================================================

-- EMPRESAS
CREATE INDEX idx_companies_nif ON companies(nif);
CREATE INDEX idx_companies_name ON companies(name);
CREATE INDEX idx_companies_email ON companies(email);

-- EMPRESAS POR DEPARTAMENTO
CREATE INDEX idx_companies_departments_company ON companies_departments(company_id);
CREATE INDEX idx_companies_departments_department ON companies_departments(department_id);

-- CONTRATOS DE EMPRESAS
CREATE INDEX idx_companies_contracts_company ON companies_contracts(company_id);
CREATE INDEX idx_companies_contracts_status ON companies_contracts(status);
CREATE INDEX idx_companies_contracts_dates ON companies_contracts(started_at, ended_at);
CREATE INDEX idx_companies_contracts_signer ON companies_contracts(signed_by_staff);

-- SLA
CREATE INDEX idx_companies_sla_company ON companies_sla(company_id);
CREATE INDEX idx_companies_sla_type ON companies_sla(sla_type);
CREATE INDEX idx_companies_sla_active ON companies_sla(is_active);
CREATE INDEX idx_companies_sla_target ON companies_sla(target_percentage);

-- AVALIAÇÕES DE SLA
CREATE INDEX idx_companies_sla_evaluation_company ON companies_sla_evaluation(company_id);
CREATE INDEX idx_companies_sla_evaluation_sla ON companies_sla_evaluation(sla_id);
CREATE INDEX idx_companies_sla_evaluation_period ON companies_sla_evaluation(evaluation_period);
CREATE INDEX idx_companies_sla_evaluation_penalty ON companies_sla_evaluation(penalty_applied);
CREATE INDEX idx_companies_sla_evaluation_evaluator ON companies_sla_evaluation(evaluator_id);

-- ==========================================================================================
-- ÍNDICES DE AUDITORIA
-- ==========================================================================================

-- LOGS DE AUDITORIA
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_table ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_operation ON audit_logs(operation_type);
CREATE INDEX idx_audit_logs_severity ON audit_logs(severity);
CREATE INDEX idx_audit_logs_status ON audit_logs(status);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_audit_logs_user_date ON audit_logs(user_id, created_at);
CREATE INDEX idx_audit_logs_table_record ON audit_logs(table_name, record_id);

-- ==========================================================================================
-- ÍNDICES DA BIBLIOTECA
-- ==========================================================================================

-- ITENS DA BIBLIOTECA
CREATE INDEX idx_library_items_title ON library_items(title);
CREATE INDEX idx_library_items_type ON library_items(item_type);
CREATE INDEX idx_library_items_format ON library_items(format);
CREATE INDEX idx_library_items_author ON library_items(author);
CREATE INDEX idx_library_items_publisher ON library_items(publisher);
CREATE INDEX idx_library_items_subject_area ON library_items(subject_area);
CREATE INDEX idx_library_items_location ON library_items(location);
CREATE INDEX idx_library_items_condition ON library_items(condition_status);
CREATE INDEX idx_library_items_availability ON library_items(availability_status);
CREATE INDEX idx_library_items_isbn ON library_items(isbn);
CREATE INDEX idx_library_items_barcode ON library_items(barcode);
CREATE INDEX idx_library_items_acquisition_date ON library_items(acquisition_date);

-- EMPRÉSTIMOS DA BIBLIOTECA
CREATE INDEX idx_library_loans_item ON library_loans(library_item_id);
CREATE INDEX idx_library_loans_borrower ON library_loans(borrower_id);
CREATE INDEX idx_library_loans_status ON library_loans(status);
CREATE INDEX idx_library_loans_dates ON library_loans(loan_date, due_date, return_date);
CREATE INDEX idx_library_loans_overdue ON library_loans(status, due_date) WHERE status = 'active';

-- ==========================================================================================
-- ÍNDICES DE NOTIFICAÇÕES
-- ==========================================================================================

-- NOTIFICAÇÕES
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(notification_type);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE INDEX idx_notifications_user_status ON notifications(user_id, status);
CREATE INDEX idx_notifications_unread ON notifications(user_id, status) WHERE status = 'unread';

-- ==========================================================================================
-- ÍNDICES COMPOSTOS E ESPECIAIS
-- ==========================================================================================

-- ÍNDICES PARA CONSULTAS FREQUENTES DE RELATÓRIOS

-- Grade horária por curso
CREATE INDEX idx_class_schedules_course_teacher ON class_schedules(course_id, teacher_id, time_slot_ids);

-- Carga horária por professor
CREATE INDEX idx_teacher_availability_approved_hours ON teacher_availability(teacher_id, aproved, total_hours);

-- Matrículas ativas por curso
CREATE INDEX idx_student_enrollments_course_active ON student_enrollments(course_id, status) WHERE status = 'active';

-- Pagamentos por período
CREATE INDEX idx_payments_date_status ON payments(payment_date, status);

-- Avaliações de SLA por empresa e período
CREATE INDEX idx_sla_evaluation_company_period ON companies_sla_evaluation(company_id, evaluation_period, penalty_applied);

-- Empréstimos em atraso
CREATE INDEX idx_library_loans_overdue_active ON library_loans(borrower_id, status, due_date) WHERE status = 'active' AND due_date < CURRENT_DATE;

-- Notificações não lidas por usuário
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, created_at) WHERE status = 'unread'; 