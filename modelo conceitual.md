# Modelo Entidade Relacionamento Conceitual (MER) - SIGEPOLI

Este documento integra entidades, atributos, relacionamentos e fluxos de processos detalhados, todos alinhados ao schema real do SIGEPOLI. Cada fluxo está descrito passo a passo, sem simplificações, e faz referência direta às tabelas e campos reais. Entidades ou fluxos sem tabela real identificada estão sinalizados para ajuste futuro.

---

## 1. Usuário e Papéis

### Entidade: Usuário (`users`)
- **Atributos:** id, first_name, last_name, email, phone, address, date_of_birth, status
- **Relacionamentos:**
  - Possui papéis via `user_role_assignments` (**1:N**)
  - Recebe notificações via `notifications` (**1:N**)
  - Realiza empréstimos via `library_loans` (**1:N**)
  - Realiza logs de auditoria via `audit_logs` (**1:N**)
  - É funcionário via `staff` (**1:1**)
  - É aluno via `students` (**1:1**)
  - É professor via `teachers` (**1:1**)

### Entidade: Papel de Usuário (`user_roles`)
- **Atributos:** id, name, permissions
- **Relacionamentos:**
  - Atribuído a usuários via `user_role_assignments` (**1:N**)

### Entidade: Atribuição de Papel (`user_role_assignments`)
- **Atributos:** id, user_id, role_id, assigned_at, is_active
- **Relacionamentos:**
  - Refere-se a um usuário (`users`) (**N:1**)
  - Refere-se a um papel (`user_roles`) (**N:1**)

#### Fluxo de Atribuição de Papel
1. Cadastro do usuário em `users`.
2. Criação de papel em `user_roles` (se necessário).
3. Atribuição do papel ao usuário em `user_role_assignments` (campos: user_id, role_id, assigned_at, is_active).
4. O usuário passa a ter permissões e acessos conforme o papel.

---

## 2. Funcionário Administrativo

### Entidade: Funcionário (`staff`)
- **Atributos:** user_id, staff_number, hire_date, category, status, department_id
- **Relacionamentos:**
  - Vinculado a um usuário (`users`) (**1:1**)
  - Pertence a um departamento (`departments`) (**N:1**)
  - Possui cargos (`staff_positions`) (**1:N**)
  - Tem férias/licenças (`staff_leaves`) (**1:N**)
  - Recebe pagamentos (`staff_payments`) (**1:N**)
  - Possui qualificações acadêmicas (`academic_qualifications`) (**1:N**)
  - Participa de avaliações (`staff_evaluation`) (**1:N**)
  - É coordenador de curso (`courses`) (**1:1**)

### Entidade: Cargo do Funcionário (`staff_positions`)
- **Atributos:** staff_id, position_id, start_date, end_date
- **Relacionamentos:**
  - Refere-se a um funcionário (`staff`) (**N:1**)
  - Refere-se a um cargo (`positions`) (**N:1**)

### Entidade: Férias/Licença (`staff_leaves`)
- **Atributos:** staff_id, leave_type, start_date, end_date
- **Relacionamentos:**
  - Refere-se a um funcionário (`staff`) (**N:1**)

### Entidade: Pagamento de Funcionário (`staff_payments`)
- **Atributos:** staff_id, payment_id, amount, etc.
- **Relacionamentos:**
  - Refere-se a um funcionário (`staff`) (**N:1**)
  - Refere-se a um pagamento (`payments`) (**N:1**)

### Entidade: Qualificação Acadêmica (`academic_qualifications`)
- **Atributos:** staff_id, title, type, institution, completion_date
- **Relacionamentos:**
  - Refere-se a um funcionário (`staff`) (**N:1**)

### Entidade: Avaliação de Funcionário (`staff_evaluation`)
- **Atributos:** staff_id, evaluation_id, score, comments
- **Relacionamentos:**
  - Refere-se a um funcionário (`staff`) (**N:1**)
  - Refere-se a uma avaliação (`evaluation`) (**N:1**)

#### Fluxo de Funcionário Administrativo
1. Registro de dados pessoais em `users`.
2. Vinculação do usuário em `staff` (campos: user_id, staff_number, hire_date, department_id, etc.).
3. Atribuição de cargo em `staff_positions` (campos: staff_id, position_id, start_date, end_date).
4. Submissão de férias/licenças em `staff_leaves` (campos: staff_id, leave_type, start_date, end_date).
5. Recebimento de pagamentos em `staff_payments` (campos: staff_id, payment_id, amount, etc.) via `payments`.
6. Participação em avaliações internas em `staff_evaluation` (campos: staff_id, evaluation_id, score, comments).
7. Registro de qualificações acadêmicas em `academic_qualifications` (campos: staff_id, title, type, institution, completion_date).

---

## 3. Chefe de Departamento

### Entidade: Departamento (`departments`)
- **Atributos:** id, name, acronym, description
- **Relacionamentos:**
  - Possui orçamento (`department_budgets`) (**1:N**)
  - Oferece cursos (`courses`) (**1:N**)
  - Possui serviços (`services`) (**1:N**)
  - Possui recursos (`resources`) (**1:N**)
  - Tem empresa-departamento (`companies_departments`) (**N:M**)

### Entidade: Orçamento do Departamento (`department_budgets`)
- **Atributos:** id, department_id, fiscal_year, total_budget, spent_budget
- **Relacionamentos:**
  - Refere-se a um departamento (`departments`) (**N:1**)

### Entidade: Empresa-Departamento (`companies_departments`)
- **Atributos:** company_id, department_id
- **Relacionamentos:**
  - Refere-se a um departamento (`departments`) (**N:1**)
  - Refere-se a uma empresa (`companies`) (**N:1**)

#### Fluxo de Chefe de Departamento
1. Atribuição do papel "head_department" via `user_role_assignments`.
2. Gestão dos dados do departamento em `departments`.
3. Gestão do orçamento em `department_budgets` (campos: department_id, fiscal_year, total_budget, spent_budget).
4. Aprovação de solicitações de recursos em `room_bookings` (campos: room_id, department_id, reason, date, status) e cadastro de recursos em `resources` (campos: name, responsible_department_id).
5. Aprovação de propostas de contratação de empresas `companies_contracts`.
6. Aprovação de pagamentos departamentais em `company_payments` (campos: company_id, payment_id, department_id, etc.).

---

## 4. Professor

### Entidade: Professor (`teachers`)
- **Atributos:** staff_id, academic_rank, tenure_status, is_thesis_advisor
- **Relacionamentos:**
  - Vinculado a um funcionário (`staff`) (**1:1**)
  - Possui especializações (`teacher_specializations`) (**1:N**)
  - Define disponibilidade (`teacher_availability`) (**1:N**)
  - Leciona em turmas (`class_schedules`) (**1:N**)
  - Participa de avaliações de desempenho (`staff_evaluation`) (**1:N**)

### Entidade: Especialização do Professor (`teacher_specializations`)
- **Atributos:** teacher_id, subject_area, subject_id, proficiency_level, is_approved
- **Relacionamentos:**
  - Refere-se a um professor (`teachers`) (**N:1**)
  - Refere-se a uma disciplina (`subjects`) (**N:1**)

### Entidade: Disponibilidade do Professor (`teacher_availability`)
- **Atributos:** teacher_id, time_slot_ids, total_hours, approved
- **Relacionamentos:**
  - Refere-se a um professor (`teachers`) (**N:1**)

### Entidade: Horário da Turma (`class_schedules`)
- **Atributos:** id, class_id, subject_id, teacher_id, time_slot_ids, room_id, status, approved_by
- **Relacionamentos:**
  - Refere-se a uma turma (`classes`) (**N:1**)
  - Refere-se a uma disciplina (`subjects`) (**N:1**)
  - Ministrado por um professor (`teachers`) (**N:1**)
  - Ocorre em uma sala (`rooms`) (**N:1**)
  - Confirmado por coordenador do curso (`staff`) (**N:1**)

#### Fluxo de Professor
1. Cadastro em `users` → vínculo em `staff` → vínculo em `teachers`.
2. Definição de especializações em `teacher_specializations` (campos: teacher_id, subject_area, subject_id, proficiency_level, is_approved).
3. Submissão de disponibilidade semanal em `teacher_availability` (campos: teacher_id, time_slot_ids, total_hours, approved).
4. Lecionar aulas conforme `class_schedules` (presença registrada em `classes_attended`).
5. Lançamento de notas em `grades` (campos: student_id, class_schedules_id, assessment_type_id, score) e controle de frequência em `attendance` (campos: student_id, classes_attended_id, status).
6. Participação em avaliações de desempenho (`staff_evaluation`).

---

## 5. Aluno

### Entidade: Aluno (`students`)
- **Atributos:** user_id, student_number, studying, searching, recommendation
- **Relacionamentos:**
  - Vinculado a um usuário (`users`) (**1:1**)
  - Matricula-se em cursos (`student_enrollments`) (**1:N**)
  - Matricula-se em turmas (`class_enrollments`) (**1:N**)
  - Tem frequência (`attendance`) (**1:N**)
  - Recebe notas (`grades`) (**1:N**)
  - Realiza pagamentos de propina (`student_fees`, `student_payments`) (**1:N**)
  - Solicita serviços (`student_payments` + `services`) (**1:N**)

### Entidade: Matrícula em Curso (`student_enrollments`)
- **Atributos:** id, student_id, course_id, enrollment_date, status, conclusion_date
- **Relacionamentos:**
  - Refere-se a um aluno (`students`) (**N:1**)
  - Refere-se a um curso (`courses`) (**N:1**)

### Entidade: Matrícula em Turma (`class_enrollments`)
- **Atributos:** id, student_id, class_schedules_id, enrollment_date, type_of_enrollment, status
- **Relacionamentos:**
  - Refere-se a um aluno (`students`) (**N:1**)
  - Refere-se a um horário de turma (`class_schedules`) (**N:1**)

### Entidade: Nota (`grades`)
- **Atributos:** student_id, class_schedules_id, assessment_type_id, score
- **Relacionamentos:**
  - Refere-se a um aluno (`students`) (**N:1**)
  - Refere-se a um horário de turma (`class_schedules`) (**N:1**)

### Entidade: Frequência (`attendance`)
- **Atributos:** student_id, classes_attended_id, status
- **Relacionamentos:**
  - Refere-se a um aluno (`students`) (**N:1**)
  - Refere-se a uma aula ministrada (`classes_attended`) (**N:1**)

### Entidade: Propina do Aluno (`student_fees`)
- **Atributos:** id, student_id, amount, due_date, status, payment_id
- **Relacionamentos:**
  - Refere-se a um aluno (`students`) (**N:1**)
  - Gera pagamento de aluno (`student_payments`) (**1:1**)

### Entidade: Pagamento de Aluno (`student_payments`)
- **Atributos:** id, payment_id, service_id, student_id, created_at, updated_at
- **Relacionamentos:**
  - Refere-se a um aluno (`students`) (**N:1**)
  - Refere-se a um serviço (`services`) (**N:1**)
  - Efetuado via pagamento (`payments`) (**N:1**)

#### Fluxo de Aluno
1. Inscrição no curso registrada em `course_access` (campos: student_id, course_id, exam_score, etc.).
2. Prova de acesso e respectiva nota armazenadas no campo `exam_score` de `course_access`.
3. Matrícula no curso em `student_enrollments` (campos: student_id, course_id, enrollment_date, status).
4. Matrícula em turma em `class_enrollments` (campos: student_id, class_schedules_id, enrollment_date, type_of_enrollment, status).
5. Emissão de propina em `student_fees` → pagamento em `student_payments`.
6. Frequência registrada em `attendance` para aulas listadas em `classes_attended`.
7. Lançamento de notas em `grades`.
8. Solicitação e pagamento de serviços por meio de `student_payments` vinculando a tabela `services`.
9. Multas por atrasos ou infrações `fines`.
10. Avaliação de cursos, funcionários e serviços em `course_evaluation`, `staff_evaluation`, `service_evaluation`.

---


## 6. Curso, Disciplina, Turma e Matrículas

### Entidade: Curso (`courses`)
- **Atributos:** id, name, description, duration, department_id, coordinator_staff_id
- **Relacionamentos:**
  - Oferecido por um departamento (`departments`) (**N:1**)
  - Possui disciplinas (`course_subjects`) (**1:N**)
  - Possui disponibilidade de vagas (`course_availability`) (**1:N**)
  - Coordenado por funcionário (`staff`) (**N:1**)
  - Tem turmas (`classes`) (**1:N**)
  - É avaliado em avaliação de curso (`course_evaluation`) (**1:N**)

### Entidade: Disciplina (`subjects`)
- **Atributos:** id, name, code, workload
- **Relacionamentos:**
  - Oferecida em disciplina do curso (`course_subjects`) (**N:M**)
  - Ministrada em turma (`class_schedules`) (**N:M** via `class_schedules`)
  - Ministrada por professor (`teacher_specializations`) (**N:M** via `teacher_specializations`)

### Entidade: Disciplinas do Curso (`course_subjects`)
- **Atributos:** id, course_id, subject_id, semester, is_mandatory, prerequisites
- **Relacionamentos:**
  - Refere-se a um curso (`courses`) (**N:1**)
  - Refere-se a uma disciplina (`subjects`) (**N:1**)

### Entidade: Turma (`classes`)
- **Atributos:** id, name, code, academic_year, semester, course_id
- **Relacionamentos:**
  - Refere-se a um curso (`courses`) (**N:1**)
  - Tem horários de turma (`class_schedules`) (**1:N**)
  - Tem matrículas em turma (`class_enrollments`) (**1:N**)
  - Tem aulas ministradas (`classes_attended`) (**1:N**)

### Entidade: Horário da Turma (`class_schedules`)
- **Atributos:** id, class_id, subject_id, teacher_id, time_slot_ids, room_id, status, approved_by
- **Relacionamentos:**
  - Refere-se a uma turma (`classes`) (**N:1**)
  - Refere-se a uma disciplina (`subjects`) (**N:1**)
  - Ministrado por um professor (`teachers`) (**N:1**)
  - Ocorre em uma sala (`rooms`) (**N:1**)
  - Confirmado por coordenador do curso (`staff`) (**N:1**)

#### Fluxo de Matrícula e Gestão Acadêmica
1. Oferta de curso registrada em `courses` e vinculada ao departamento.
2. Disciplinas associadas ao curso em `course_subjects`.
3. Disponibilidade de vagas por ano em `course_availability`.
4. Criação de turmas em `classes` e definição de horários em `class_schedules`.
5. Matrícula do aluno no curso em `student_enrollments`.
6. Matrícula do aluno em turmas/disciplina em `class_enrollments`.
7. Registro de presença em aulas via `attendance` e aulas ministradas em `classes_attended`.
8. Lançamento de notas em `grades`.

---

## 7. Infraestrutura: Salas, Recursos, Reservas

### Entidade: Sala (`rooms`)
- **Atributos:** id, name, description, localization, capacity, type_of_room, acessibility, is_available
- **Relacionamentos:**
  - Possui recursos da sala (`room_resources`) (**1:N**)
  - Tem reservas de sala (`room_bookings`) (**1:N**)

### Entidade: Recurso (`resources`)
- **Atributos:** id, name, description, responsible_department_id
- **Relacionamentos:**
  - É alocado em recurso da sala (`room_resources`) (**N:M**)
  - Pertence a um departamento (`departments`) (**N:1**)

### Entidade: Recurso da Sala (`room_resources`)
- **Atributos:** id, room_id, resource_id, status_resources
- **Relacionamentos:**
  - Refere-se a uma sala (`rooms`) (**N:1**)
  - Refere-se a um recurso (`resources`) (**N:1**)

### Entidade: Reserva de Sala (`room_bookings`)
- **Atributos:** id, room_id, department_id, reason, date, start_time, end_time, purpose, status
- **Relacionamentos:**
  - Refere-se a uma sala (`rooms`) (**N:1**)
  - Refere-se a um departamento (`departments`) (**N:1**)

#### Fluxo de Gestão de Infraestrutura
1. Cadastro de salas em `rooms`.
2. Cadastro de recursos em `resources`.
3. Vinculação de recursos a salas em `room_resources`.
4. Solicitação e aprovação de reservas especiais de sala em `room_bookings`.

---

## 8. Pagamentos e Finanças

### Entidade: Pagamento (`payments`)
- **Atributos:** id, amount, payment_date, payment_type_id, status
- **Relacionamentos:**
  - Tem tipo de pagamento (`payment_types`) (**N:1**)
  - Relacionado a pagamento de aluno (`student_payments`) (**1:N**)
  - Relacionado a pagamento de funcionário (`staff_payments`) (**1:N**)
  - Relacionado a pagamento de empresa (`company_payments`) (**1:N**)

### Entidade: Tipo de Pagamento (`payment_types`)
- **Atributos:** id, name
- **Relacionamentos:**
  - Relacionado a pagamentos (`payments`) (**1:N**)

### Entidade: Pagamento de Aluno (`student_payments`)
- **Atributos:** id, payment_id, service_id, student_id, created_at, updated_at
- **Relacionamentos:**
  - Refere-se a um pagamento (`payments`) (**N:1**)
  - Refere-se a um serviço (`services`) (**N:1**)
  - Refere-se a um aluno (`students`) (**N:1**)

### Entidade: Propina do Aluno (`student_fees`)
- **Atributos:** id, student_id, amount, due_date, status, payment_id
- **Relacionamentos:**
  - Refere-se a um aluno (`students`) (**N:1**)
  - Gera pagamento de aluno (`student_payments`) (**1:1**)

### Entidade: Pagamento de Funcionário (`staff_payments`)
- **Atributos:** id, payment_id, staff_id, created_at, updated_at
- **Relacionamentos:**
  - Refere-se a um pagamento (`payments`) (**N:1**)
  - Refere-se a um funcionário (`staff`) (**N:1**)

### Entidade: Pagamento de Empresa (`company_payments`)
- **Atributos:** id, payment_id, company_id, department_id
- **Relacionamentos:**
  - Refere-se a um pagamento (`payments`) (**N:1**)
  - Refere-se a uma empresa (`companies`) (**N:1**)
  - Refere-se a um orçamento de departamento (`department_budgets`) (**N:1**)

#### Fluxo de Pagamentos
1. Geração de transação base em `payments`.
2. Classificação pelo tipo em `payment_types`.
3. Associação específica:
   - `student_payments` (serviços do aluno)
   - `student_fees` (propinas do aluno)
   - `company_payments` (contratos/SLA)
   - `staff_payments` (salários, bônus)
4. Validação de status (`paid`, `pending`, `failed`).

---

## 9. Serviços

### Entidade: Serviço (`services`)
- **Atributos:** id, name, description, value, department_id, service_type_id
- **Relacionamentos:**
  - Tem tipo de serviço (`service_types`) (**N:1**)
  - Recebe pagamento (`student_payments`) (**1:N**)
  - É avaliado em avaliação de serviço (`service_evaluation`) (**1:N**)
  - Pertence a um departamento (`departments`) (**N:1**)

### Entidade: Tipo de Serviço (`service_types`)
- **Atributos:** id, name
- **Relacionamentos:**
  - Relacionado a serviços (`services`) (**1:N**)

### Entidade: Avaliação de Serviço (`service_evaluation`)
- **Atributos:** id, service_id, evaluation_id, score, comments
- **Relacionamentos:**
  - Refere-se a um serviço (`services`) (**N:1**)
  - Refere-se a uma avaliação (`evaluation`) (**N:1**)

#### Fluxo de Serviços
1. Criação do serviço em `services` com vínculo a `service_types` e departamento.
2. Solicitação pelo usuário via `student_payments` (ou outra tabela de requisição de serviço).
3. Pagamento via fluxo de pagamentos.
4. Execução do serviço e posterior avaliação em `service_evaluation`.

---

## 10. Avaliações e Performance

### Entidade: Avaliação (`evaluation`)
- **Atributos:** id, title, type, start_date, end_date
- **Relacionamentos:**
  - Avalia funcionário (`staff_evaluation`) (**1:N**)
  - Avalia curso (`course_evaluation`) (**1:N**)
  - Avalia serviço (`service_evaluation`) (**1:N**)
  - Gera performance (`performance`) (**1:N**)

### Entidade: Avaliação de Funcionário (`staff_evaluation`)
- **Atributos:** id, staff_id, evaluation_id, score, comments
- **Relacionamentos:**
  - Refere-se a um funcionário (`staff`) (**N:1**)
  - Refere-se a uma avaliação (`evaluation`) (**N:1**)

### Entidade: Avaliação de Curso (`course_evaluation`)
- **Atributos:** id, course_id, evaluation_id, score, comments
- **Relacionamentos:**
  - Refere-se a um curso (`courses`) (**N:1**)
  - Refere-se a uma avaliação (`evaluation`) (**N:1**)

### Entidade: Avaliação de Serviço (`service_evaluation`)
- **Atributos:** id, service_id, evaluation_id, score, comments
- **Relacionamentos:**
  - Refere-se a um serviço (`services`) (**N:1**)
  - Refere-se a uma avaliação (`evaluation`) (**N:1**)

### Entidade: Performance (`performance`)
- **Atributos:** id, evaluation_id, score, date
- **Relacionamentos:**
  - Refere-se a uma avaliação (`evaluation`) (**N:1**)

#### Fluxo de Avaliação e Performance
1. Criação de avaliação em `evaluation`.
2. Distribuição para avaliados:
   - Funcionários (`staff_evaluation`)
   - Cursos (`course_evaluation`)
   - Serviços (`service_evaluation`)
3. Submissão de resultados em `performance`.

---

## 11. Biblioteca 

### Entidade: Item de Biblioteca (`library_items`)
- **Atributos:** título, ISBN, código de barras
- **Relacionamentos:**
  - É emprestado em empréstimo (`library_loans`) (**1:N**)

### Entidade: Empréstimo (`library_loans`)
- **Atributos:** data de empréstimo, data de devolução prevista
- **Relacionamentos:**
  - Refere-se a um item de biblioteca (`library_items`) (**N:1**)
  - Refere-se a um usuário (`users`) (**N:1**)

#### Fluxo de Biblioteca
1. Cadastro de item em `library_items`.
2. Empréstimo/devolução em `library_loans`.
3. Multas por atraso em `fines` .

---

## 12. Notificações

### Entidade: Notificação (`notifications`)
- **Atributos:** id, user_id, title, message, date
- **Relacionamentos:**
  - Refere-se a um usuário (`users`) (**N:1**)

#### Fluxo de Notificações
1. Geração de notificação pelo sistema para usuários em `notifications`.
2. Visualização pelo usuário.

---

## 13. Log de Auditoria

### Entidade: Log de Auditoria (`audit_logs`)
- **Atributos:** usuário, tabela, operação, data
- **Relacionamentos:**
  - Refere-se a um usuário (`users`) (**N:1**)

#### Fluxo de Auditoria
1. Geração automática de logs em `audit_logs` para operações críticas.

## 14. Gestão de Empresas e SLAs

### Entidade: Acordo de Nível de Serviço (SLA) (`companies_sla`)
- **Atributos:** id, company_id, sla_name, description, sla_type, target_percentage, penalty_percentage, sla_details, is_active
- **Relacionamentos:**
  - Refere-se a uma empresa (`companies`) (**N:1**)
  - Tem avaliações de SLA (`companies_sla_evaluation`) (**1:N**)

### Entidade: Avaliação de SLA (`companies_sla_evaluation`)
- **Atributos:** id, company_id, sla_id, evaluation_period, achieved_percentage, penalty_applied, penalty_amount, evaluator_id, feedback
- **Relacionamentos:**
  - Refere-se a uma empresa (`companies`) (**N:1**)
  - Refere-se a um SLA (`companies_sla`) (**N:1**)
  - Avaliado por um usuário/funcionário (`users`) (**N:1**)

#### Fluxo de Gestão de SLAs
1. Cadastro de empresas em `companies`.
2. Definição de Acordos de Nível de Serviço (SLA) em `companies_sla` para cada empresa e tipo de serviço.
3. Avaliação periódica do cumprimento do SLA em `companies_sla_evaluation`, registrando o percentual alcançado, penalidades e feedback.
4. Geração de relatórios de desempenho e aplicação de ações corretivas `fines` se necessário.

