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
├── modelo_conceitual
├── modelo_logico
├── guia_implantacao
├── justificativas_indices
└── relatorio_1_pagina
```

### 1. ÁREA ACADÊMICA 📚

#### **Estrutura de Cursos e Disciplinas**
- [x] `courses` — Cadastro de cursos oferecidos
- [x] `subjects` — Catálogo de disciplinas
- [x] `course_subjects` — Relação curso-disciplina com pré-requisitos
- [x] `course_availability` — Vagas disponíveis por ano letivo

#### **Gestão de Turmas e Horários**
- [x] `classes` — Turmas por curso
- [x] `time_slots` — Períodos de aula
- [x] `class_schedules` — Horários das turmas
- [x] `rooms` — Salas de aula
- [x] `resources` — Recursos disponíveis
- [x] `room_resources` — Recursos por sala
- [x] `room_bookings` — Reservas especiais de salas

#### **Gestão de Alunos**
- [x] `students` — Dados dos alunos
- [x] `student_enrollments` — Matrícula em cursos
- [x] `class_enrollments` — Matrículas em disciplinas em dadas turmas

#### **Gestão de Professores**
- [x] `teachers` — Dados dos docentes
- [x] `teacher_specializations` — Especializações dos professores
- [x] `teacher_availability` — Disponibilidade/carga horária

#### **Sistema de Avaliação**
- [x] `grades` — Notas dos alunos
- [x] `assessment_types` — Tipos de avaliação
- [x] `attendance` — Controle de presenças
- [x] `classes_attended` — Aulas ministradas

---

### 2. ÁREA ADMINISTRATIVA 🏢

#### **Gestão de Pessoal**
- [x] `users` — Dados centrais de todos os utilizadores
- [x] `user_roles` — Papéis no sistema
- [x] `user_role_assignments` — Relacionamento usuário-papel
- [x] `user_identification` — Documentos de identificação
- [x] `user_health` — Informações de saúde
- [x] `departments` — Estrutura departamental
- [x] `department_budgets` — Orçamento anual por departamento
- [x] `staff` — Funcionários administrativos
- [x] `academic_qualifications` — Qualificações dos funcionários
- [x] `positions` — Cargos disponíveis
- [x] `staff_positions` — Cargos dos funcionários
- [x] `staff_leaves` — Férias e licenças
- [x] `evaluation` — Avaliações de desempenho
- [x] `staff_evaluation` — Avaliações específicas de funcionários
- [x] `course_evaluation` — Avaliações de cursos pelos alunos
- [x] `performance` — Resultados das avaliações de desempenho
- [x] `course_access` — Inscrições de alunos nos cursos

#### **Coordenação de Cursos**
- [x] `courses.coordinator_user_id` - Coordenadores atribuídos (RF04)
  - **VALIDAÇÃO**: Apenas coordenadores aprovam carga horária (RN06)

#### **Secretaria Académica (crítica para ISPTEC)**
- [x] `services` — Serviços prestados pela instituição
- [x] `service_types` — Categorias de serviços
- [x] `service_evaluation` — Avaliações de serviços

#### **Tesouraria (crítica para ISPTEC)**
- [x] `payments` — Pagamentos gerais
- [x] `payment_types` — Tipos de pagamento
- [x] `studant_payments` — Pagamentos de alunos por serviços
- [x] `company_payments` — Pagamentos a empresas terceirizadas
- [x] `staff_payments` — Pagamentos a funcionários
- [x] `fines` — Multas aplicadas a alunos e empresas

#### **Biblioteca**
- [x] `library_items` — Catálogo geral da biblioteca
- [x] `library_loans` — Empréstimos e devoluções

---

### 3. ÁREA OPERACIONAL ⚙️

#### **Gestão de Serviços, Pagamentos e Terceirizados**
- [x] `companies` — Empresas terceirizadas
- [x] `companies_departments` — Relação empresas-departamentos
- [x] `companies_contracts` — Contratos com empresas
- [x] `companies_sla` — Acordos de nível de serviço
- [x] `companies_sla_evaluation` — Avaliações dos SLA
- [x] `companies_sla_definitions` — Definições dos termos dos SLA

#### **Monitoramento e Pagamentos**
  - **VALIDAÇÃO**: Verifica garantia válida antes do pagamento (RN04)
  - **VALIDAÇÃO**: Multa automática se SLA < 90% (RN05)

---

### 4. ÁREAS TRANSVERSAIS 🔄

#### **Auditoria**
- [x] `audit_logs` — Logs de auditoria

#### **Relatórios** (Consultas, não tabelas)
- **RF10**: Relatórios de carga horária, salas e custos
- **Views necessárias**:
  - Grade horária por curso
  - Carga horária por professor
  - Resumo de custos de serviços por mês

#### **Notificações**
- [x] `notifications` — Notificações do sistema

---

### 5. VALIDAÇÕES E REGRAS DE NEGÓCIO

#### **Procedures (RF - Matricular, Alocar, Processar)**
- [ ] `sp_matricular_aluno` - Matrícula com validação de vaga e propina (RN02)
- [ ] `sp_alocar_professor` - Alocação sem sobreposição de horários (RN01)
- [ ] `sp_processar_pagamento` - Pagamento com cálculo de multa (RN05)

#### **Functions (Cálculos)**
- [ ] `fn_calcular_media_ponderada` - Média ponderada do aluno
- [ ] `fn_calcular_percentual_sla` - Percentual de SLA mensal

#### **Triggers (Validações Automáticas)**
- [ ] `tr_validar_sobreposicao_horario` - Previne sobreposição de horários (RN01)
- [ ] `tr_validar_nota_range` - Valida notas entre 0-20 (RN03)
- [ ] `tr_bloquear_pagamento_sem_garantia` - Bloqueia pagamento sem garantia (RN04)
- [ ] `tr_auditoria_matriculas` - Auditoria de matrículas (RF11)
- [ ] `tr_auditoria_pagamentos` - Auditoria de pagamentos (RF11)

#### **Views (Relatórios)**
- [ ] `vw_grade_horaria_curso` - Grade horária por curso
- [ ] `vw_carga_horaria_professor` - Carga horária por professor
- [ ] `vw_custos_servicos_mes` - Resumo de custos mensais

---