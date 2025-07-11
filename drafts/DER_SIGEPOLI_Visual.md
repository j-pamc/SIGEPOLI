# DIAGRAMA ENTIDADE-RELACIONAMENTO (DER) - SIGEPOLI
## Visualização Simplificada

```
                    ┌─────────────────┐
                    │     USERS       │
                    │ (id, name, etc) │
                    └─────────┬───────┘
                              │
                    ┌─────────┴───────┐
                    │                 │
         ┌──────────┴─────────┐ ┌─────┴──────────┐
         │      STAFF         │ │    STUDENTS    │
         │ (user_id, etc)     │ │ (user_id, etc) │
         └──────────┬─────────┘ └─────┬──────────┘
                    │                 │
         ┌──────────┴─────────┐       │
         │     TEACHERS       │       │
         │ (staff_id, etc)    │       │
         └────────────────────┘       │
                                      │
                    ┌─────────────────┼─────────────────┐
                    │                 │                 │
         ┌──────────┴─────────┐ ┌─────┴──────────┐ ┌─────┴──────────┐
         │   DEPARTMENTS      │ │     COURSES    │ │   ENROLLMENTS  │
         │ (id, name, etc)    │ │ (id, name, etc)│ │ (student_id,   │
         └──────────┬─────────┘ └─────┬──────────┘ │  course_id)    │
                    │                 │            └─────────────────┘
                    │                 │
         ┌──────────┴─────────┐ ┌─────┴──────────┐
         │     CLASSES        │ │   SUBJECTS     │
         │ (id, course_id)    │ │ (id, name, etc)│
         └──────────┬─────────┘ └─────┬──────────┘
                    │                 │
         ┌──────────┴─────────┐ ┌─────┴──────────┐
         │ CLASS_SCHEDULES    │ │ COURSE_SUBJECTS│
         │ (class_id, etc)    │ │ (course_id,    │
         └────────────────────┘ │  subject_id)   │
                                └─────────────────┘

                    ┌─────────────────┐
                    │     ROOMS       │
                    │ (id, name, etc) │
                    └─────────┬───────┘
                              │
                    ┌─────────┴───────┐
                    │                 │
         ┌──────────┴─────────┐ ┌─────┴──────────┐
         │   RESOURCES        │ │ ROOM_BOOKINGS  │
         │ (id, name, etc)    │ │ (room_id, etc) │
         └──────────┬─────────┘ └─────────────────┘
                    │
         ┌──────────┴─────────┐
         │  ROOM_RESOURCES    │
         │ (room_id, res_id)  │
         └────────────────────┘

                    ┌─────────────────┐
                    │    PAYMENTS     │
                    │ (id, amount,    │
                    │  status, etc)   │
                    └─────────┬───────┘
                              │
                    ┌─────────┴───────┐
                    │                 │
         ┌──────────┴─────────┐ ┌─────┴──────────┐ ┌─────┴──────────┐
         │STUDENT_PAYMENTS    │ │COMPANY_PAYMENTS│ │ STAFF_PAYMENTS │
         │ (payment_id, etc)  │ │ (payment_id,   │ │ (payment_id,   │
         └────────────────────┘ │  company_id)   │ │  staff_id)     │
                                └─────────────────┘ └─────────────────┘

                    ┌─────────────────┐
                    │   COMPANIES     │
                    │ (id, name, etc) │
                    └─────────┬───────┘
                              │
         ┌────────────────────┴────────────────────┐
         │                                         │
         │              CONTRACTS                  │
         │         (company_id, etc)               │
         └─────────────────────────────────────────┘
```

## LEGENDA DOS RELACIONAMENTOS

### Relacionamentos 1:1
- **USERS** ↔ **STAFF** (um usuário é um funcionário)
- **USERS** ↔ **STUDENTS** (um usuário é um aluno)
- **STAFF** ↔ **TEACHERS** (um funcionário é um professor)
- **PAYMENTS** ↔ **STUDENT_PAYMENTS** (um pagamento é de um aluno)
- **PAYMENTS** ↔ **COMPANY_PAYMENTS** (um pagamento é de uma empresa)
- **PAYMENTS** ↔ **STAFF_PAYMENTS** (um pagamento é de um funcionário)

### Relacionamentos 1:N
- **DEPARTMENTS** → **COURSES** (um departamento tem vários cursos)
- **COURSES** → **CLASSES** (um curso tem várias turmas)
- **CLASSES** → **CLASS_SCHEDULES** (uma turma tem vários horários)
- **STUDENTS** → **ENROLLMENTS** (um aluno pode estar em vários cursos)
- **ROOMS** → **ROOM_RESOURCES** (uma sala tem vários recursos)
- **ROOMS** → **ROOM_BOOKINGS** (uma sala pode ter várias reservas)

### Relacionamentos N:M
- **SUBJECTS** ↔ **COURSES** (via COURSE_SUBJECTS)
- **ROOMS** ↔ **RESOURCES** (via ROOM_RESOURCES)
- **STUDENTS** ↔ **CLASS_SCHEDULES** (via CLASS_ENROLLMENTS)

## ENTIDADES PRINCIPAIS

### 1. **USERS** (Usuários)
- Entidade base para todos os usuários do sistema
- Atributos: id, first_name, last_name, email, phone, etc.

### 2. **STAFF** (Funcionários)
- Funcionários da instituição
- Herda de USERS (user_id)
- Atributos: employee_number, hire_date, contract_type, salary

### 3. **STUDENTS** (Alunos)
- Alunos matriculados
- Herda de USERS (user_id)
- Atributos: student_number, enrollment_date, status

### 4. **TEACHERS** (Professores)
- Professores da instituição
- Herda de STAFF (staff_id)
- Atributos: hire_date, contract_type, salary

### 5. **DEPARTMENTS** (Departamentos)
- Departamentos acadêmicos
- Atributos: name, description, head_staff_id, status

### 6. **COURSES** (Cursos)
- Cursos oferecidos pela instituição
- Atributos: name, description, duration_semesters, level, status

### 7. **CLASSES** (Turmas)
- Turmas específicas de cursos
- Atributos: name, code, academic_year, semester

### 8. **SUBJECTS** (Disciplinas)
- Disciplinas do catálogo
- Atributos: name, code, description, workload_hours

### 9. **ROOMS** (Salas)
- Salas de aula e outros espaços
- Atributos: name, capacity, type_of_room, is_available

### 10. **PAYMENTS** (Pagamentos)
- Pagamentos do sistema
- Atributos: amount, payment_method_id, reference_number, status

### 11. **COMPANIES** (Empresas)
- Empresas terceirizadas
- Atributos: name, contact_person, phone, email, address

## REGRAS DE NEGÓCIO IMPLEMENTADAS

### RN01 - Gestão de Cursos
- Um curso pertence a um departamento
- Um curso tem um coordenador (funcionário)
- Um curso tem duração em semestres

### RN02 - Gestão de Turmas
- Uma turma pertence a um curso
- Uma turma tem horários específicos
- Uma turma tem capacidade limitada

### RN03 - Avaliação Acadêmica
- Notas de 0 a 20
- Percentuais de 0 a 100
- Média ponderada por disciplina

### RN04 - Gestão Financeira
- Pagamentos com métodos específicos
- Orçamentos por departamento
- Contratos com empresas

### RN05 - Gestão de Recursos
- Salas com capacidade e tipo
- Recursos alocados por sala
- Reservas de salas

### RN06 - Auditoria
- Logs de todas as operações
- Rastreabilidade de mudanças
- Controle de acesso por papéis 