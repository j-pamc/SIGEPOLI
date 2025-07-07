-- ==============================================================
-- SIGEPOLI - Índices para Otimização de Consultas (MySQL)
-- ==============================================================
-- Este arquivo cria índices para acelerar buscas, joins e garantir performance.
-- Índices são criados para:
-- 1. Chaves estrangeiras (FKs) - sempre necessário para performance e integridade
-- 2. Colunas frequentemente usadas em WHERE, JOIN ou ORDER BY
-- 3. Não criar índices redundantes para campos UNIQUE (MySQL já cria)
--      Como funciona:
--      - Ao definir UNIQUE em uma coluna, o MySQL cria um índice com nome padrão:
--          <nome_da_tabela>_<nome_da_coluna>_UNIQUE
--      - Se o UNIQUE for composto, o nome pode ser:
--          <nome_da_tabela>_<primeira_coluna>_UNIQUE
--      - Você pode acessar esses índices normalmente em EXPLAIN, SHOW INDEX, etc.
-- 4. Não criar índices para campos JSON (não suportado)
-- ==============================================================

-- ===================== ACADÊMICO =====================
-- Índices para tabelas acadêmicas: aceleram buscas por FKs, matrículas, horários, avaliações, etc.

CREATE INDEX idx_courses_department_id ON courses(department_id); -- FK: departamento do curso
CREATE INDEX idx_courses_coordinator_staff_id ON courses(coordinator_staff_id); -- FK: coordenador do curso

CREATE INDEX idx_course_subjects_subject_id ON course_subjects(subject_id); -- FK: disciplina
CREATE INDEX idx_course_subjects_course_id ON course_subjects(course_id); -- FK: curso

CREATE INDEX idx_course_availability_course_id ON course_availability(course_id); -- FK: curso

CREATE INDEX idx_classes_course_id ON classes(course_id); -- FK: curso

CREATE INDEX idx_class_schedules_class_id ON class_schedules(class_id); -- FK: turma
CREATE INDEX idx_class_schedules_subject_id ON class_schedules(subject_id); -- FK: disciplina
CREATE INDEX idx_class_schedules_teacher_id ON class_schedules(teacher_id); -- FK: professor
CREATE INDEX idx_class_schedules_room_id ON class_schedules(room_id); -- FK: sala
CREATE INDEX idx_class_schedules_approved_by ON class_schedules(approved_by); -- FK: aprovador

CREATE INDEX idx_room_resources_room_id ON room_resources(room_id); -- FK: sala
CREATE INDEX idx_room_resources_resource_id ON room_resources(resource_id); -- FK: recurso

CREATE INDEX idx_room_bookings_room_id ON room_bookings(room_id); -- FK: sala
CREATE INDEX idx_room_bookings_department_id ON room_bookings(department_id); -- FK: departamento

CREATE INDEX idx_students_user_id ON students(user_id); -- FK: usuário

CREATE INDEX idx_student_enrollments_student_id ON student_enrollments(student_id); -- FK: aluno
CREATE INDEX idx_student_enrollments_course_id ON student_enrollments(course_id); -- FK: curso

CREATE INDEX idx_class_enrollments_student_id ON class_enrollments(student_id); -- FK: aluno
CREATE INDEX idx_class_enrollments_class_schedules_id ON class_enrollments(class_schedules_id); -- FK: disciplina na turma

CREATE INDEX idx_teachers_staff_id ON teachers(staff_id); -- FK: funcionário

CREATE INDEX idx_teacher_specializations_teacher_id ON teacher_specializations(teacher_id); -- FK: professor
CREATE INDEX idx_teacher_specializations_subject_id ON teacher_specializations(subject_id); -- FK: disciplina
CREATE INDEX idx_teacher_specializations_qualification_id ON teacher_specializations(qualification_id); -- FK: qualificação

CREATE INDEX idx_teacher_availability_teacher_id ON teacher_availability(teacher_id); -- FK: professor
CREATE INDEX idx_teacher_availability_approved_by ON teacher_availability(approved_by); -- FK: aprovador

CREATE INDEX idx_grades_student_id ON grades(student_id); -- FK: aluno
CREATE INDEX idx_grades_class_schedules_id ON grades(class_schedules_id); -- FK: disciplina na turma
CREATE INDEX idx_grades_assessment_type_id ON grades(assessment_type_id); -- FK: tipo de avaliação

CREATE INDEX idx_attendance_student_id ON attendance(student_id); -- FK: aluno
CREATE INDEX idx_attendance_classes_attended_id ON attendance(classes_attended_id); -- FK: aula

CREATE INDEX idx_classes_attended_class_id ON classes_attended(class_id); -- FK: turma
CREATE INDEX idx_classes_attended_time_slot_id ON classes_attended(time_slot_id); -- FK: horário

-- ===================== ADMINISTRATIVO =====================
-- Índices para tabelas administrativas: papéis, departamentos, funcionários, etc.

CREATE INDEX idx_user_role_assignments_user_id ON user_role_assignments(user_id); -- FK: usuário
CREATE INDEX idx_user_role_assignments_role_id ON user_role_assignments(role_id); -- FK: papel
CREATE INDEX idx_user_role_assignments_assigned_by ON user_role_assignments(assigned_by); -- FK: quem atribuiu

CREATE INDEX idx_user_identification_user_id ON user_identification(user_id); -- FK: usuário
CREATE INDEX idx_user_health_user_id ON user_health(user_id); -- FK: usuário

CREATE INDEX idx_departments_head_staff_id ON departments(head_staff_id); -- FK: chefe do departamento

CREATE INDEX idx_department_budgets_department_id ON department_budgets(department_id); -- FK: departamento

CREATE INDEX idx_staff_user_id ON staff(user_id); -- FK: usuário
CREATE INDEX idx_staff_department_id ON staff(department_id); -- FK: departamento

CREATE INDEX idx_academic_qualifications_user_id ON academic_qualifications(user_id); -- FK: usuário

CREATE INDEX idx_staff_positions_user_id ON staff_positions(user_id); -- FK: funcionário
CREATE INDEX idx_staff_positions_position_id ON staff_positions(position_id); -- FK: cargo

CREATE INDEX idx_staff_leaves_staff_id ON staff_leaves(staff_id); -- FK: funcionário
CREATE INDEX idx_staff_leaves_replacement_staff_id ON staff_leaves(replacement_staff_id); -- FK: substituto

CREATE INDEX idx_evaluation_iniciator_staff_id ON evaluation(iniciator_staff_id); -- FK: avaliador

CREATE INDEX idx_staff_evaluation_evaluation_id ON staff_evaluation(evaluation_id); -- FK: avaliação
CREATE INDEX idx_staff_evaluation_staff_id ON staff_evaluation(staff_id); -- FK: funcionário

CREATE INDEX idx_course_evaluation_evaluation_id ON course_evaluation(evaluation_id); -- FK: avaliação
CREATE INDEX idx_course_evaluation_course_id ON course_evaluation(course_id); -- FK: curso

-- ===================== SERVIÇOS E FINANCEIRO =====================
-- Índices para tabelas de serviços, pagamentos, multas, etc.
CREATE INDEX idx_services_departament_id ON services(departament_id); -- FK: departamento responsável
CREATE INDEX idx_services_service_types_id ON services(service_types_id); -- FK: tipo de serviço

CREATE INDEX idx_payments_payment_method_id ON payments(payment_method_id); -- FK: tipo de pagamento

CREATE INDEX idx_studant_payments_payment_id ON studant_payments(payment_id); -- FK: pagamento
CREATE INDEX idx_studant_payments_service_id ON studant_payments(service_id); -- FK: serviço
CREATE INDEX idx_studant_payments_student_id ON studant_payments(student_id); -- FK: aluno

CREATE INDEX idx_company_payments_payment_id ON company_payments(payment_id); -- FK: pagamento
CREATE INDEX idx_company_payments_company_id ON company_payments(company_id); -- FK: empresa
CREATE INDEX idx_company_payments_department_budgets_id ON company_payments(department_budgets_id); -- FK: orçamento
CREATE INDEX idx_company_payments_approved_by_staff ON company_payments(approved_by_staff); -- FK: aprovador

CREATE INDEX idx_staff_payments_payment_id ON staff_payments(payment_id); -- FK: pagamento
CREATE INDEX idx_staff_payments_staff_id ON staff_payments(staff_id); -- FK: funcionário

CREATE INDEX idx_fines_payment_id ON fines(payment_id); -- FK: pagamento

-- ===================== OPERACIONAL =====================
-- Índices para empresas, contratos, SLA, avaliações de SLA

CREATE INDEX idx_companies_departments_company_id ON companies_departments(company_id); -- FK: empresa
CREATE INDEX idx_companies_departments_department_id ON companies_departments(department_id); -- FK: departamento

CREATE INDEX idx_companies_contracts_company_id ON companies_contracts(company_id); -- FK: empresa
CREATE INDEX idx_companies_contracts_signed_by_staff ON companies_contracts(signed_by_staff); -- FK: funcionário

CREATE INDEX idx_companies_sla_company_id ON companies_sla(company_id); -- FK: empresa

CREATE INDEX idx_companies_sla_evaluation_company_id ON companies_sla_evaluation(company_id); -- FK: empresa
CREATE INDEX idx_companies_sla_evaluation_sla_id ON companies_sla_evaluation(sla_id); -- FK: SLA
CREATE INDEX idx_companies_sla_evaluation_evaluator_id ON companies_sla_evaluation(evaluator_id); -- FK: avaliador

-- ===================== AUDITORIA =====================
-- Índices para logs de auditoria, facilitam rastreabilidade e relatórios
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id); -- FK: usuário
CREATE INDEX idx_audit_logs_table_name ON audit_logs(table_name); -- busca por tabela
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at); -- busca por data

-- ===================== BIBLIOTECA =====================
-- Índices para empréstimos, itens, usuários
CREATE INDEX idx_library_loans_library_item_id ON library_loans(library_item_id); -- FK: item
CREATE INDEX idx_library_loans_borrower_id ON library_loans(borrower_id); -- FK: usuário

-- ===================== NOTIFICAÇÕES =====================
-- Índices para buscas rápidas por usuário e status
CREATE INDEX idx_notifications_user_id ON notifications(user_id); -- FK: usuário
CREATE INDEX idx_notifications_status ON notifications(status); -- busca por status

-- ===================== OUTROS ÍNDICES =====================
-- Adicione índices para outras tabelas conforme o crescimento do sistema e análise de performance. 