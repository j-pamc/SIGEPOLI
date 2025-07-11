# SISTEMA SIGEPOLI (ISPTEC)

## CONTEXTO E OBJETIVO
**Sistema de Gestão Escolar Politécnica (SIGEPOLI)** - Banco de dados relacional que integra gestão académica, administrativa e operacional para o Instituto Superior Politécnico de Tecnologias e Ciências (ISPTEC).

### 1. Objetivo Geral
Desenhar, modelar e implementar um banco de dados relacional que integre a gestão académica (cursos, turmas, matrículas e avaliações), a gestão de pessoas (professores, coordenadores, administrativos) e a gestão operacional (contratos com empresas de serviços de limpeza, segurança e cafetaria), garantindo rastreabilidade, controlo de custos e relatórios de desempenho.

---

### 2. Contexto do Problema
O Instituto Superior Politécnico de Tecnologias e Ciências, assim como vários outros institutos, opera com várias áreas interligadas:

1. **Académica** – oferecimento de cursos, criação de turmas, matrícula de alunos, atribuição de professores e avaliação de desempenho discente.
2. **Administrativa** – pessoal administrativo distribuído por departamentos (Secretaria Académica, Tesouraria, Recursos Humanos, Biblioteca, Laboratórios, etc.).
3. **Coordenação Pedagógica** – coordenadores de curso responsáveis por currículos, grade horária e indicadores de qualidade.
4. **Operacional** – contratação e fiscalização de empresas terceirizadas (limpeza, segurança, cafetaria) com metas de SLA (Service Level Agreement) e pagamentos mensais.

O sistema atual apresenta dados dispersos, gerando redundância, falhas e dificuldade de apuração de custos.

---

### 3. Requisitos Funcionais
- **RF01** – Cadastrar departamentos, incluindo orçamento anual e chefe responsável.
- **RF02** – Registrar colaboradores administrativos, vinculando-os a um departamento.
- **RF03** – Cadastrar professores e respectiva titulação.
- **RF04** – Designar coordenadores por curso.
- **RF05** – Gerir cursos, disciplinas, turmas e horários.
- **RF06** – Processar matrículas de alunos nas turmas.
- **RF07** – Lançar avaliações e obter médias.
- **RF08** – Cadastrar empresas terceirizadas, contratos e SLA.
- **RF09** – Registar pagamentos mensais às empresas com controle de SLA.
- **RF10** – Gerar relatórios de carga horária, salas e custos.
- **RF11** – Manter auditoria de alterações sensíveis.

---

### 4. Regras de Negócio Obrigatórias
- **RN01** – Um professor não pode ter aulas em turmas com horários sobrepostos.
- **RN02** – Só é permitida matrícula se houver vaga e propina paga.
- **RN03** – Notas devem estar entre 0–20.
- **RN04** – Empresas precisam apresentar garantia válida antes do pagamento.
- **RN05** – SLA inferior a 90% gera multa automática.
- **RN06** – Coordenador deve aprovar carga horária dos professores do curso.

---

#### **Entregáveis e Pontuação**
- **Modelo Conceitual (ER)**: 5 pontos - ≥10 entidades, relações N:M resolvidas
- **Modelo Lógico (DER)**: 3 pontos - Tipos adequados, PKs/FKs, 3FN
- **Script DDL**: 2 pontos - CHECK, UNIQUE, INDEX, ON UPDATE/DELETE
- **Procedures**: 2 pontos - Matricular, alocar, processar pagamento
- **Functions**: 3 pontos - Média ponderada, percentual SLA
- **Triggers**: 5 pontos - Auditoria, bloqueios automáticos
- **Views**: 2 pontos - Grade horária, carga horária, custos
- **Consultas de Teste**: 1 ponto - ≥10 INSERTs + ≥15 consultas
- **Documentação**: 2 pontos - Guia implantação, diagrama físico

---

## PROGRAMABILIDADE E VISUALIZAÇÃO

### **Procedures (Procedimentos Armazenados)**

#### **1. EnrollStudent**
- **Descrição**: Matricula um aluno em um curso e em uma turma específica
- **Parâmetros**: `p_user_id`, `p_course_id`, `p_class_schedules_id`
- **Funcionalidade**: Valida se o usuário é aluno, insere matrícula no curso e na turma
- **Regra de Negócio**: RF06 - Processar matrículas de alunos nas turmas

#### **2. AllocateResourceToRoom**
- **Descrição**: Aloca um recurso a uma sala ou atualiza o status de um recurso já alocado
- **Parâmetros**: `p_room_id`, `p_resource_id`, `p_status_resources`
- **Funcionalidade**: Valida existência da sala e recurso, aloca/atualiza status
- **Regra de Negócio**: Gestão de recursos e salas

#### **3. ProcessPayment**
- **Descrição**: Processa um pagamento, registrando-o na tabela principal e nas tabelas específicas
- **Parâmetros**: `p_amount`, `p_payment_method_id`, `p_reference_number`, `p_status`, `p_student_id`, `p_service_id`, `p_company_id`, `p_department_budgets_id`, `p_approved_by_staff`, `p_staff_id`, `p_type_of_staff_payment`
- **Funcionalidade**: Valida valor do pagamento, insere registro principal e associa ao tipo específico
- **Regra de Negócio**: RF09 - Registar pagamentos mensais às empresas com controle de SLA

### **Functions (Funções)**

#### **1. ValidateGrade**
- **Descrição**: Valida se uma nota está dentro do intervalo permitido (0 a 20)
- **Parâmetros**: `grade DECIMAL(5, 2)`
- **Retorna**: `BOOLEAN` - TRUE se válida, FALSE caso contrário
- **Regra de Negócio**: RN03 - Notas devem estar entre 0–20

#### **2. CalculateWeightedAverage**
- **Descrição**: Calcula a média ponderada das notas de um aluno numa disciplina específica
- **Parâmetros**: `p_student_id`, `p_class_schedules_id`
- **Retorna**: `DECIMAL(5, 2)` - Média ponderada calculada
- **Regra de Negócio**: RF07 - Lançar avaliações e obter médias

#### **3. CalculateSLAPercentage**
- **Descrição**: Retorna o percentual de SLA alcançado por uma empresa para um SLA específico
- **Parâmetros**: `p_company_id`, `p_sla_id`, `p_evaluation_period`
- **Retorna**: `DECIMAL(5, 2)` - Percentual de SLA alcançado
- **Regra de Negócio**: RF08 - Gerar relatórios de carga horária, salas e custos

### **Triggers (Gatilhos)**

#### **1. trg_audit_users**
- **Descrição**: Registra INSERTs na tabela `users` na tabela `audit_logs`
- **Evento**: `AFTER INSERT ON users`
- **Funcionalidade**: Auditoria automática de novos usuários
- **Regra de Negócio**: RF11 - Manter auditoria de alterações sensíveis

#### **2. trg_audit_users_update**
- **Descrição**: Registra UPDATEs na tabela `users` na tabela `audit_logs`
- **Evento**: `AFTER UPDATE ON users`
- **Funcionalidade**: Auditoria automática de alterações de usuários
- **Regra de Negócio**: RF11 - Manter auditoria de alterações sensíveis

#### **3. trg_audit_users_delete**
- **Descrição**: Registra DELETEs na tabela `users` na tabela `audit_logs`
- **Evento**: `AFTER DELETE ON users`
- **Funcionalidade**: Auditoria automática de exclusões de usuários
- **Regra de Negócio**: RF11 - Manter auditoria de alterações sensíveis

#### **4. trg_apply_sla_fine**
- **Descrição**: Aplica multa automática se SLA inferior a 90%
- **Evento**: `AFTER INSERT ON companies_sla_evaluation`
- **Funcionalidade**: Calcula e aplica multa automaticamente quando SLA < 90%
- **Regra de Negócio**: RN05 - SLA inferior a 90% gera multa automática

#### **5. trg_approve_teacher_availability**
- **Descrição**: Garante que aprovação da carga horária seja feita por coordenador
- **Evento**: `BEFORE UPDATE ON teacher_availability`
- **Funcionalidade**: Valida se aprovador é coordenador do curso do professor
- **Regra de Negócio**: RN06 - Coordenador deve aprovar carga horária dos professores do curso

### **Views (Visões)**

#### **1. ClassScheduleView**
- **Descrição**: Visão consolidada da grade horária das turmas
- **Conteúdo**: Turma, disciplina, professor, horários e sala
- **Funcionalidade**: Apresenta informações completas de agendamento de aulas
- **Regra de Negócio**: RF10 - Gerar relatórios de carga horária, salas e custos

#### **2. TeacherWorkloadView**
- **Descrição**: Carga horária total de cada professor por disciplina
- **Conteúdo**: Professor, disciplina e total de horas de trabalho
- **Funcionalidade**: Controle de carga horária dos docentes
- **Regra de Negócio**: RF10 - Gerar relatórios de carga horária, salas e custos

#### **3. DepartmentCostsView**
- **Descrição**: Orçamentos e gastos por departamento para cada ano fiscal
- **Conteúdo**: Departamento, ano fiscal, orçamento total, gasto e restante
- **Funcionalidade**: Controle de custos por departamento
- **Regra de Negócio**: RF10 - Gerar relatórios de carga horária, salas e custos

#### **4. CompanyPaymentCostsView**
- **Descrição**: Pagamentos feitos a empresas com informações detalhadas
- **Conteúdo**: Empresa, valor, data, tipo de pagamento e departamento
- **Funcionalidade**: Controle de pagamentos a terceirizados
- **Regra de Negócio**: RF10 - Gerar relatórios de carga horária, salas e custos

#### **5. StudentFeeCostsView**
- **Descrição**: Custos de propinas dos alunos com informações completas
- **Conteúdo**: Aluno, valor da propina, mês de referência, data e status
- **Funcionalidade**: Controle de pagamentos de propinas
- **Regra de Negócio**: RF10 - Gerar relatórios de carga horária, salas e custos

---

## RESUMO ESTATÍSTICO DAS FUNCIONALIDADES

### **📊 Estatísticas Gerais**
- **Total de Tabelas**: 35+ tabelas implementadas
- **Total de Procedures**: 3 procedures funcionais
- **Total de Functions**: 3 funções especializadas
- **Total de Triggers**: 5 triggers de auditoria e validação
- **Total de Views**: 5 views para relatórios e consultas

### **🎯 Cobertura dos Requisitos Funcionais**
- ✅ **RF01** - Cadastrar departamentos com orçamento
- ✅ **RF02** - Registrar colaboradores administrativos
- ✅ **RF03** - Cadastrar professores e titulação
- ✅ **RF04** - Designar coordenadores por curso
- ✅ **RF05** - Gerir cursos, disciplinas, turmas e horários
- ✅ **RF06** - Processar matrículas de alunos (Procedure: EnrollStudent)
- ✅ **RF07** - Lançar avaliações e obter médias (Function: CalculateWeightedAverage)
- ✅ **RF08** - Cadastrar empresas terceirizadas, contratos e SLA
- ✅ **RF09** - Registar pagamentos mensais (Procedure: ProcessPayment)
- ✅ **RF10** - Gerar relatórios (5 Views implementadas)
- ✅ **RF11** - Manter auditoria (3 Triggers de auditoria)

### **🔒 Cobertura das Regras de Negócio**
- ✅ **RN01** - Professor não pode ter aulas com horários sobrepostos
- ✅ **RN02** - Matrícula só com vaga e propina paga
- ✅ **RN03** - Notas entre 0–20 (Function: ValidateGrade)
- ✅ **RN04** - Empresas precisam apresentar garantia válida
- ✅ **RN05** - SLA inferior a 90% gera multa automática (Trigger: trg_apply_sla_fine)
- ✅ **RN06** - Coordenador aprova carga horária (Trigger: trg_approve_teacher_availability)

### **🏗️ Arquitetura do Sistema**
- **Camada de Dados**: 35+ tabelas normalizadas
- **Camada de Lógica**: 3 procedures + 3 functions
- **Camada de Auditoria**: 5 triggers automáticos
- **Camada de Apresentação**: 5 views para relatórios
- **Camada de Validação**: Constraints CHECK, UNIQUE, FOREIGN KEY
- **Camada de Performance**: Índices otimizados

---

## IMPLEMENTACAO

> SGBD -> MySQL

### 6. ESTRUTURA 

#### **Arquivos SQL**
```
sigepoli/
├── sql/
│   ├── 01_schema/
│   │   ├── 01_create_database.sql
│   │   ├── 02_create_tables.sql
│   │   ├── 03_create_constraints.sql
│   │   └── 04_create_indexes.sql
│   ├── 02_programmability/
│   │   ├── procedures.sql
│   │   ├── functions.sql
│   │   └── triggers.sql
│   ├── 03_views/
│   │   └── views.sql
│   ├── 04_data/
│   │   └── insert_test_data.sql
│   └── 05_tests/
│       ├── test_queries.sql
│       └── validate_rules.sql
├── scripts/
│   ├── deploy_completo.sql
│   ├── deploy_monolitico.sql
│   └── reset_database.sql
├── README.md
├── modelo conceitual.md
├── modelo logico.md
├── guia_implantacao.md
├── justificativas_indices.md
└── relatorio_1_pagina.pdf
```

### 1. ÁREA ACADÊMICA 📚

#### **Estrutura de Cursos e Disciplinas**
- [x] `courses` — Cadastro de cursos oferecidos
- [x] `subjects` — Catálogo de disciplinas
- [x] `course_subjects` — Relação curso-disciplina com pré-requisitos
- [x] `course_availability` — Vagas disponíveis por ano letivo
- [x] `course_fees` — Definição das taxas de curso

#### **Gestão de Turmas e Horários**
- [x] `classes` — Turmas por curso
- [x] `time_slots` — Períodos de aula disponíveis
- [x] `class_schedules` — Horários das turmas e alocações (disciplina, professor, sala)
- [x] `rooms` — Salas de aula e espaços físicos
- [x] `resources` — Recursos materiais e equipamentos
- [x] `room_resources` — Alocação de recursos por sala
- [x] `room_bookings` — Reservas especiais de salas

#### **Gestão de Alunos**
- [x] `students` — Dados detalhados dos alunos
- [x] `student_enrollments` — Matrícula dos alunos em cursos
- [x] `class_enrollments` — Matrículas dos alunos em turmas específicas
- [x] `student_fees` — Registro das propinas e outras taxas dos alunos

#### **Gestão de Professores**
- [x] `teachers` — Dados específicos dos docentes
- [x] `teacher_specializations` — Especializações e áreas de atuação dos professores
- [x] `teacher_availability` — Disponibilidade e carga horária dos professores

#### **Sistema de Avaliação**
- [x] `grades` — Notas e resultados de avaliações dos alunos
- [x] `assessment_types` — Tipos de avaliação e seus pesos
- [x] `attendance` — Controle de presenças e faltas dos alunos
- [x] `classes_attended` — Registro de aulas ministradas

---

### 2. ÁREA ADMINISTRATIVA 🏢

#### **Gestão de Pessoal**
- [x] `users` — Dados centrais de todos os utilizadores (alunos, funcionários, professores)
- [x] `user_roles` — Definição dos papéis e permissões no sistema
- [x] `user_role_assignments` — Atribuição de papéis aos utilizadores
- [x] `user_identification` — Documentos de identificação dos utilizadores
- [x] `user_health` — Informações de saúde e necessidades especiais dos utilizadores
- [x] `departments` — Estrutura e organização dos departamentos
- [x] `department_budgets` — Orçamento anual e controle de gastos por departamento
- [x] `staff` — Funcionários administrativos e técnicos
- [x] `academic_qualifications` — Qualificações acadêmicas de funcionários e professores
- [x] `positions` — Cargos e funções disponíveis na instituição
- [x] `staff_positions` — Atribuição de cargos aos funcionários
- [x] `staff_leaves` — Registro de férias e licenças dos funcionários
- [x] `evaluation` — Definição de avaliações de desempenho
- [x] `staff_evaluation` — Avaliações específicas de funcionários
- [x] `course_evaluation` — Avaliações de cursos por alunos e feedback
- [x] `performance` — Resultados consolidados das avaliações de desempenho
- [x] `course_access` — Registro de inscrições e provas de acesso a cursos

#### **Coordenação de Cursos**
- [x] `courses.coordinator_staff_id` - Coordenadores atribuídos aos cursos (RF04)
  - **VALIDAÇÃO**: Apenas coordenadores aprovam carga horária (RN06)

#### **Secretaria Académica (crítica para ISPTEC)**
- [x] `services` — Serviços prestados pela instituição (ex: emissão de declarações)
- [x] `service_types` — Categorias de serviços oferecidos
- [x] `service_evaluation` — Avaliações da qualidade dos serviços

#### **Tesouraria (crítica para ISPTEC)**
- [x] `payments` — Registros gerais de todas as transações financeiras
- [x] `payment_types` — Tipos de métodos de pagamento
- [x] `student_payments` — Pagamentos específicos de alunos (propinas, serviços)
- [x] `company_payments` — Pagamentos a empresas terceirizadas
- [x] `staff_payments` — Pagamentos a funcionários (salários, bônus)
- [x] `fines` — Registro de multas aplicadas (atrasos, infrações)

#### **Biblioteca**
- [x] `library_items` — Catálogo geral de recursos da biblioteca (livros, periódicos, etc.)
- [x] `library_loans` — Empréstimos e devoluções de itens da biblioteca

---

### 3. ÁREA OPERACIONAL ⚙️

#### **Gestão de Serviços, Pagamentos e Terceirizados**
- [x] `companies` — Empresas parceiras e terceirizadas
- [x] `companies_departments` — Relacionamento entre empresas e departamentos
- [x] `companies_contracts` — Contratos firmados com empresas
- [x] `companies_sla` — Acordos de Nível de Serviço (SLA) com empresas
- [x] `companies_sla_evaluation` — Avaliações de desempenho dos SLAs

#### **Monitoramento e Pagamentos**
  - **VALIDAÇÃO**: Verifica garantia válida antes do pagamento (RN04)
  - **VALIDAÇÃO**: Multa automática se SLA < 90% (RN05)

---

### 4. ÁREAS TRANSVERSAIS 🔄

#### **Auditoria**
- [x] `audit_logs` — Logs detalhados de todas as operações sensíveis do sistema

#### **Relatórios** (Consultas, não tabelas)
- **RF10**: Relatórios de carga horária, salas e custos
- **Views implementadas**:
  - [x] `vw_class_schedule` - Grade horária detalhada por turma.
  - [x] `vw_teacher_workload` - Carga horária total por professor.
  - [x] `vw_department_costs_summary` - Resumo de custos por departamento.

#### **Notificações**
- [x] `notifications` — Gerenciamento e envio de notificações aos utilizadores

---

### 5. VALIDAÇÕES E REGRAS DE NEGÓCIO

#### **Procedures (RF - Matricular, Alocar, Processar)**
- [x] `EnrollStudentInClass` - Matrícula de aluno com validação de vaga e propina (RN02)
- [x] `AllocateTeacherToClass` - Alocação de professor sem sobreposição de horários (RN01)
- [x] `ProcessStudentPayment` - Processamento de pagamento de propina

#### **Functions (Cálculos)**
- [x] `CalculateWeightedAverage` - Cálculo da média ponderada das notas do aluno
- [x] `CalculateSLAPercentage` - Cálculo do percentual de SLA alcançado

#### **Triggers (Validações Automáticas e Lógica de Negócio)**
- [x] `Triggers de Auditoria` - Registram INSERTs, UPDATEs e DELETEs em tabelas sensíveis (RF11).
- [x] `trg_apply_sla_fine` - Aplica multa automática se o percentual de SLA for inferior a 90% (RN05).
- [x] `trg_approve_teacher_availability` - Garante que a aprovação da carga horária de um professor seja feita por um coordenador de curso (RN06).
- [x] `trg_grades_before_insert/update` - Valida que as notas inseridas/atualizadas estejam entre 0-20 (RN03).
- [x] `trg_generate_semester_fees` - Gera automaticamente as taxas de propina por semestre para novas matrículas de alunos.
- [x] `Triggers de Validação de Dados` - Implementados em diversas tabelas (`users`, `departments`, `students`, `staff`, `courses`, `subjects`, `classes`, `rooms`, `course_fees`, `student_fees`, `payments`, `payment_types`, `companies`, `companies_contracts`, `companies_sla`, `companies_sla_evaluation`, `assessment_types`, `user_roles`, `class_schedules`, `student_enrollments`) para garantir a integridade e consistência dos dados, conforme as regras de negócio.

#### **Procedures (RF - Matricular, Alocar, Processar)**

---matricular_aluno`** - Matrícula com validação de vaga e propina (RN02)
- [ ] **`sp_alocar_professor`** - Alocação sem sobreposição de horários (RN01)
- [ ] **`sp_processar_pagamento`** - Pagamento com cálculo de multa (RN05)

#### **Functions (Cálculos)**
- [ ] **`fn_calcular_media_ponderada`** - Média ponderada do aluno
- [ ] **`fn_calcular_percentual_sla`** - Percentual de SLA mensal

#### **Triggers (Validações Automáticas)**
- [ ] **`tr_validar_sobreposicao_horario`** - Previne sobreposição de horários (RN01)
- [ ] **`tr_validar_nota_range`** - Valida notas entre 0-20 (RN03)
- [ ] **`tr_bloquear_pagamento_sem_garantia`** - Bloqueia pagamento sem garantia (RN04)
- [ ] **`tr_auditoria_matriculas`** - Auditoria de matrículas (RF11)
- [ ] **`tr_auditoria_pagamentos`** - Auditoria de pagamentos (RF11)

#### **Views (Relatórios)**
- [ ] **`vw_grade_horaria_curso`** - Grade horária por curso
- [ ] **`vw_carga_horaria_professor`** - Carga horária por professor
- [ ] **`vw_custos_servicos_mes`** - Resumo de custos mensais

---

