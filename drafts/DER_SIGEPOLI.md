# DIAGRAMA ENTIDADE-RELACIONAMENTO (DER) - SIGEPOLI
## Sistema de Gestão Escolar Politécnica

---

## 1. VISÃO GERAL DO SISTEMA

O SIGEPOLI é um sistema de gestão escolar que integra funcionalidades acadêmicas, administrativas e financeiras para uma instituição de ensino politécnica.

### 1.1 Módulos Principais:
- **Módulo Acadêmico**: Cursos, disciplinas, turmas, matrículas, notas
- **Módulo Administrativo**: Usuários, departamentos, funcionários, salas
- **Módulo Financeiro**: Pagamentos, propinas, orçamentos, contratos
- **Módulo de Recursos**: Salas, recursos, reservas, biblioteca
- **Módulo de Avaliação**: Avaliações, desempenho, SLA

---

## 2. ENTIDADES PRINCIPAIS

### 2.1 ENTIDADES DE USUÁRIOS
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     USERS       │    │    STUDENTS     │    │    TEACHERS     │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ PK: id          │    │ PK: user_id     │    │ PK: staff_id    │
│ first_name      │    │ student_number  │    │ hire_date       │
│ last_name       │    │ enrollment_date │    │ contract_type   │
│ email           │    │ status          │    │ salary          │
│ phone           │    │                 │    │                 │
│ birth_date      │    │                 │    │                 │
│ gender          │    │                 │    │                 │
│ address         │    │                 │    │                 │
│ status          │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │     STAFF       │
                    ├─────────────────┤
                    │ PK: user_id     │
                    │ employee_number │
                    │ hire_date       │
                    │ contract_type   │
                    │ salary          │
                    │ status          │
                    └─────────────────┘
```

### 2.2 ENTIDADES ACADÊMICAS
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   DEPARTMENTS   │    │     COURSES     │    │    SUBJECTS     │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ PK: id          │    │ PK: id          │    │ PK: id          │
│ name            │    │ name            │    │ name            │
│ description     │    │ description     │    │ code            │
│ head_staff_id   │    │ duration_sem    │    │ description     │
│ status          │    │ department_id   │    │ workload_hours  │
└─────────────────┘    │ coordinator_id  │    └─────────────────┘
         │             │ level           │             │
         │             │ status          │             │
         └─────────────┼─────────────────┘             │
                       │                               │
                       │                               │
            ┌─────────────────┐            ┌─────────────────┐
            │     CLASSES     │            │ COURSE_SUBJECTS │
            ├─────────────────┤            ├─────────────────┤
            │ PK: id          │            │ PK: id          │
            │ name            │            │ subject_id      │
            │ code            │            │ course_id       │
            │ course_id       │            │ semester        │
            │ academic_year   │            │ prerequisites   │
            │ semester        │            │ is_mandatory    │
            └─────────────────┘            └─────────────────┘
                       │
                       │
            ┌─────────────────┐
            │ CLASS_SCHEDULES │
            ├─────────────────┤
            │ PK: id          │
            │ class_id        │
            │ subject_id      │
            │ teacher_id      │
            │ time_slot_ids   │
            │ room_id         │
            │ status          │
            └─────────────────┘
```

### 2.3 ENTIDADES DE MATRÍCULA E AVALIAÇÃO
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│STUDENT_ENROLL   │    │CLASS_ENROLLMENTS│    │     GRADES      │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ PK: id          │    │ PK: id          │    │ PK: id          │
│ student_id      │    │ student_id      │    │ student_id      │
│ course_id       │    │ class_sched_id  │    │ class_sched_id  │
│ enrollment_date │    │ enrollment_date │    │ assessment_id   │
│ status          │    │ type_enrollment │    │ score           │
│ conclusion_date │    │ status          │    │ comments        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  ATTENDANCE     │
                    ├─────────────────┤
                    │ PK: id          │
                    │ student_id      │
                    │ classes_att_id  │
                    │ status          │
                    │ justification   │
                    └─────────────────┘
```

### 2.4 ENTIDADES DE RECURSOS E INFRAESTRUTURA
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     ROOMS       │    │   RESOURCES     │    │ ROOM_RESOURCES  │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ PK: id          │    │ PK: id          │    │ PK: id          │
│ name            │    │ name            │    │ room_id         │
│ description     │    │ description     │    │ resource_id     │
│ localization    │    │ dept_responsible│    │ status_resources│
│ capacity        │    │                 │    │                 │
│ type_of_room    │    │                 │    │                 │
│ accessibility   │    │                 │    │                 │
│ is_available    │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ ROOM_BOOKINGS   │
                    ├─────────────────┤
                    │ PK: id          │
                    │ room_id         │
                    │ department_id   │
                    │ reason          │
                    │ date            │
                    │ start_time      │
                    │ end_time        │
                    │ status          │
                    └─────────────────┘
```

### 2.5 ENTIDADES FINANCEIRAS
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    PAYMENTS     │    │STUDENT_PAYMENTS │    │COMPANY_PAYMENTS │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ PK: id          │    │ PK: id          │    │ PK: id          │
│ amount          │    │ payment_id      │    │ payment_id      │
│ payment_method  │    │ service_id      │    │ company_id      │
│ reference_num   │    │ student_id      │    │ dept_budget_id  │
│ status          │    │                 │    │ approved_by     │
│ payment_date    │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │ STAFF_PAYMENTS  │
                    ├─────────────────┤
                    │ PK: id          │
                    │ payment_id      │
                    │ staff_id        │
                    │ type_of_payment │
                    └─────────────────┘
```

### 2.6 ENTIDADES DE SERVIÇOS E CONTRATOS
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  SERVICE_TYPES  │    │    SERVICES     │    │   COMPANIES     │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ PK: id          │    │ PK: id          │    │ PK: id          │
│ name            │    │ name            │    │ name            │
│ description     │    │ description     │    │ contact_person  │
│                 │    │ service_type_id │    │ phone           │
│                 │    │ value           │    │ email           │
│                 │    │ department_id   │    │ address         │
│                 │    │ status          │    │ status          │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │COMP_CONTRACTS   │
                    ├─────────────────┤
                    │ PK: id          │
                    │ company_id      │
                    │ contract_details│
                    │ start_date      │
                    │ end_date        │
                    │ value           │
                    │ status          │
                    └─────────────────┘
```

---

## 3. RELACIONAMENTOS PRINCIPAIS

### 3.1 RELACIONAMENTOS DE HERANÇA
- **USERS** → **STAFF** (1:1)
- **USERS** → **STUDENTS** (1:1)
- **STAFF** → **TEACHERS** (1:1)

### 3.2 RELACIONAMENTOS ACADÊMICOS
- **DEPARTMENTS** → **COURSES** (1:N)
- **COURSES** → **CLASSES** (1:N)
- **COURSES** → **COURSE_SUBJECTS** (1:N)
- **SUBJECTS** → **COURSE_SUBJECTS** (1:N)
- **CLASSES** → **CLASS_SCHEDULES** (1:N)
- **STUDENTS** → **STUDENT_ENROLLMENTS** (1:N)
- **STUDENTS** → **CLASS_ENROLLMENTS** (1:N)

### 3.3 RELACIONAMENTOS DE RECURSOS
- **ROOMS** → **ROOM_RESOURCES** (1:N)
- **RESOURCES** → **ROOM_RESOURCES** (1:N)
- **ROOMS** → **ROOM_BOOKINGS** (1:N)
- **DEPARTMENTS** → **ROOM_BOOKINGS** (1:N)

### 3.4 RELACIONAMENTOS FINANCEIROS
- **PAYMENTS** → **STUDENT_PAYMENTS** (1:1)
- **PAYMENTS** → **COMPANY_PAYMENTS** (1:1)
- **PAYMENTS** → **STAFF_PAYMENTS** (1:1)
- **STUDENTS** → **STUDENT_PAYMENTS** (1:N)
- **COMPANIES** → **COMPANY_PAYMENTS** (1:N)
- **STAFF** → **STAFF_PAYMENTS** (1:N)

---

## 4. CARDINALIDADES

### 4.1 RELACIONAMENTOS 1:1
- **USERS** ↔ **STAFF** (um usuário é um funcionário)
- **USERS** ↔ **STUDENTS** (um usuário é um aluno)
- **STAFF** ↔ **TEACHERS** (um funcionário é um professor)
- **PAYMENTS** ↔ **STUDENT_PAYMENTS** (um pagamento é de um aluno)
- **PAYMENTS** ↔ **COMPANY_PAYMENTS** (um pagamento é de uma empresa)
- **PAYMENTS** ↔ **STAFF_PAYMENTS** (um pagamento é de um funcionário)

### 4.2 RELACIONAMENTOS 1:N
- **DEPARTMENTS** → **COURSES** (um departamento tem vários cursos)
- **COURSES** → **CLASSES** (um curso tem várias turmas)
- **CLASSES** → **CLASS_SCHEDULES** (uma turma tem vários horários)
- **STUDENTS** → **STUDENT_ENROLLMENTS** (um aluno pode estar em vários cursos)
- **STUDENTS** → **CLASS_ENROLLMENTS** (um aluno pode estar em várias turmas)
- **ROOMS** → **ROOM_RESOURCES** (uma sala tem vários recursos)
- **ROOMS** → **ROOM_BOOKINGS** (uma sala pode ter várias reservas)

### 4.3 RELACIONAMENTOS N:M
- **SUBJECTS** ↔ **COURSES** (via COURSE_SUBJECTS)
- **ROOMS** ↔ **RESOURCES** (via ROOM_RESOURCES)
- **STUDENTS** ↔ **CLASS_SCHEDULES** (via CLASS_ENROLLMENTS)
- **TEACHERS** ↔ **SUBJECTS** (via TEACHER_SPECIALIZATIONS)

---

## 5. ATRIBUTOS ESPECIAIS

### 5.1 CHAVES PRIMÁRIAS
- Todas as entidades principais têm chave primária auto-incremento (id)
- Entidades de herança usam a chave primária da entidade pai (user_id, staff_id)

### 5.2 CHAVES ESTRANGEIRAS
- Implementadas com constraints de integridade referencial
- Regras de DELETE apropriadas (CASCADE, RESTRICT, SET NULL)

### 5.3 ATRIBUTOS DERIVADOS
- **workload_hours**: Calculado a partir dos time_slots
- **total_budget**: Soma dos orçamentos por departamento
- **weighted_average**: Média ponderada das notas

### 5.4 ATRIBUTOS MULTIVALORADOS
- **prerequisites**: JSON com lista de pré-requisitos
- **time_slot_ids**: JSON com lista de horários
- **syllabus**: Texto longo com programa da disciplina

---

## 6. REGRAS DE NEGÓCIO IMPLEMENTADAS

### 6.1 RN01 - Gestão de Cursos
- Um curso pertence a um departamento
- Um curso tem um coordenador (funcionário)
- Um curso tem duração em semestres

### 6.2 RN02 - Gestão de Turmas
- Uma turma pertence a um curso
- Uma turma tem horários específicos
- Uma turma tem capacidade limitada

### 6.3 RN03 - Avaliação Acadêmica
- Notas de 0 a 20
- Percentuais de 0 a 100
- Média ponderada por disciplina

### 6.4 RN04 - Gestão Financeira
- Pagamentos com métodos específicos
- Orçamentos por departamento
- Contratos com empresas

### 6.5 RN05 - Gestão de Recursos
- Salas com capacidade e tipo
- Recursos alocados por sala
- Reservas de salas

### 6.6 RN06 - Auditoria
- Logs de todas as operações
- Rastreabilidade de mudanças
- Controle de acesso por papéis

---

## 7. VIEWS E PROCEDURES

### 7.1 Views Principais
- **ClassScheduleView**: Horários consolidados
- **TeacherWorkloadView**: Carga horária dos professores
- **StudentFeeCostsView**: Custos de propinas
- **DepartmentCostsView**: Orçamentos por departamento
- **CompanyPaymentCostsView**: Pagamentos de empresas

### 7.2 Procedures Principais
- **EnrollStudent**: Matrícula de alunos
- **AllocateResourceToRoom**: Alocação de recursos
- **ProcessPayment**: Processamento de pagamentos

### 7.3 Functions Principais
- **ValidateGrade**: Validação de notas
- **CalculateWeightedAverage**: Cálculo de média ponderada
- **CalculateSLAPercentage**: Cálculo de percentual SLA

---

## 8. CONSIDERAÇÕES DE IMPLEMENTAÇÃO

### 8.1 Normalização
- 3ª Forma Normal (3FN)
- Evita redundâncias
- Mantém integridade referencial

### 8.2 Performance
- Índices em chaves estrangeiras
- Índices em campos de busca frequente
- Otimização de queries complexas

### 8.3 Segurança
- Controle de acesso por papéis
- Logs de auditoria
- Validação de dados

### 8.4 Escalabilidade
- Estrutura modular
- Separação de responsabilidades
- Facilidade de manutenção

