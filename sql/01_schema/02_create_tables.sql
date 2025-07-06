-- ==============================================================
-- SISTEMA DE GESTÃO ESCOLAR POLITÉCNICA (SIGEPOLI)
-- Schema do banco de dados 
-- ==============================================================
-- Este schema suporta as seguintes funcionalidades:
-- 1. Académica: cursos, turmas, matrículas, professores e avaliações
-- 2. Administrativa: pessoal distribuído por departamentos
-- 3. Coordenação Pedagógica: coordenadores e currículos
-- 4. Operacional: gestão de recursos e terceirizados
-- ==============================================================

-- ============================
-- TABELA DE USUÁRIOS (CENTRAL)
-- ============================
-- Tabela principal que centraliza todos os usuários do sistema
-- Implementa Single Table Inheritance para diferentes tipos de usuários
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL, -- Nome de usuário único para login
    first_name VARCHAR(50) NOT NULL, -- Primeiro nome do usuário
    last_name VARCHAR(50) NOT NULL, -- Sobrenome do usuário
    email VARCHAR(100) UNIQUE NOT NULL, -- Email único para comunicação
    password VARCHAR(255) NOT NULL, -- Senha criptografada
    phone VARCHAR(20), -- Telefone de contato
    address TEXT, -- Endereço completo
    date_of_birth DATE, -- Data de nascimento
    status ENUM(
        'active',
        'inactive',
        'blocked',
        'suspended'
    ) NOT NULL DEFAULT 'active',
    gender ENUM('M', 'F', 'O') DEFAULT NULL, -- ENUM para gênero (padrão internacional)
    profile_picture TEXT, -- URL da foto de perfil
    role_id INT NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Corrigido de 'last_update' para 'updated_at'
);

-- ============================
-- TABELA DE IDENTIFICAÇÃO DE USUÁRIOS
-- ============================
-- Armazena informações oficiais de identificação
CREATE TABLE IF NOT EXISTS user_identification (
    user_id INT NOT NULL, -- Referencia users.id
    document_type ENUM(
        'id_card', -- Cartão de identidade (padrão internacional)
        'residence_id', -- Cartão de residência
        'passport', -- Passaporte
        'other' -- Outros tipos de documentos
    ) NOT NULL,
    document_number VARCHAR(20) NOT NULL UNIQUE, -- Número do documento único
    issue_date DATE, -- Data de emissão do documento
    expiration_date DATE, -- Data de expiração do documento (se aplicável)
    nationality VARCHAR(50), -- Nacionalidade do usuário
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TABELA DE SAUDE DO USUÁRIO
-- ============================
-- Armazena informações de saúde e emergência do usuário
CREATE TABLE IF NOT EXISTS user_health (
    user_id INT NOT NULL, -- Referencia users.id
    conditions TEXT, -- Condições médicas conhecidas
    medications TEXT, -- Medicamentos em uso
    allergies TEXT, -- Alergias conhecidas
    need_assessibility BOOLEAN DEFAULT FALSE, -- Necessidade de acessibilidade
    emergency_contact_phone VARCHAR(20), -- Telefone do contato de emergência
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TABELA DE PAPÉIS DE USUÁRIOS
-- ============================
-- Define os diferentes papéis que os usuários podem ter no sistema
-- Papel: super_admin, admin, decano, coordenador, student, teacher, staff
CREATE TABLE user_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    permissions JSON, -- MySQL 5.7+
    hierarchy_level INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ================================
-- TABELA DE DEPARTAMENTOS
-- ================================
-- Organiza a estrutura administrativa da instituição
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE, -- Nome completo do departamento
    acronym VARCHAR(10) NOT NULL UNIQUE, -- Sigla do departamento (corrigido de 'sigla')
    description TEXT, -- Descrição das atividades do departamento
    head_user_id INT NOT NULL, -- ID do chefe do departamento (referencia users.id)
    status ENUM(
        'active',
        'inactive',
        'suspended',
        'discontinued'
    ) NOT NULL DEFAULT 'active', -- Status do departamento
    classification ENUM(
        'academic', -- Departamento acadêmico
        'administrative', -- Departamento administrativo
        'operational', -- Departamento operacional
        'support' -- Departamento de suporte
    ) NOT NULL DEFAULT 'academic', -- Classificação do departamento
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- TABELA DE CURSOS
-- ========================
-- Define os cursos oferecidos pela instituição
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE, -- Nome do curso
    description TEXT, -- Descrição do curso
    duration_semesters INT NOT NULL, -- Duração em semestres (nome mais descritivo)
    department_id INT NOT NULL, -- Departamento responsável pelo curso
    coordinator_user_id INT NOT NULL, -- Coordenador do curso (referencia users.id)
    level ENUM(
        'skill', -- Nível de habilidade
        'technical', -- Nível técnico
        'graduate', -- Nível de graduação
        'postgraduate', -- Nível de pós-graduação
        'specialization', -- Nível de especialização
        'master', -- Nível de mestrado
        'doctorate' -- Nível de doutorado
    ) NOT NULL DEFAULT 'graduate', -- ENUM para nível do curso
    status ENUM(
        'active',
        'inactive',
        'suspended',
        'discontinued'
    ) NOT NULL DEFAULT 'active', -- ENUM para status do curso
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- TABELA DE DISCIPLINAS
-- ===========================
-- Catálogo de disciplinas disponíveis
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Nome da disciplina
    code VARCHAR(20) NOT NULL UNIQUE, -- Código único da disciplina
    description TEXT, -- Descrição do conteúdo da disciplina
    workload_hours INT NOT NULL, -- Carga horária em horas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- TABELA DE INFORMAÇÕES DA DISCIPLINA
-- =====================================
-- Relaciona disciplinas com cursos e define semestre e pré-requisitos
CREATE TABLE IF NOT EXISTS course_subjects (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    subject_id INT NOT NULL, -- ID da disciplina
    course_id INT NOT NULL, -- ID do curso
    semester INT NOT NULL, -- Semestre em que a disciplina é oferecida
    prerequisites JSON, -- Lista de IDs de disciplinas pré-requisito
    syllabus TEXT, -- Programa detalhado da disciplina
    is_mandatory BOOLEAN NOT NULL DEFAULT true, -- Se a disciplina é obrigatória ou optativa
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- TABELA DE ALUNOS
-- ==============================
-- Extensão da tabela users para informações específicas de estudantes
CREATE TABLE IF NOT EXISTS students (
    user_id INT NOT NULL, -- Referencia users.id 
    registration_number VARCHAR(20) NOT NULL UNIQUE, -- Número de matrícula único
    course_id INT NOT NULL, -- Curso em que está matriculado
    status ENUM(
        'active',
        'suspended',
        'graduated',
        'dropout',
        'transferred'
    ) NOT NULL DEFAULT 'active',
    current_semester INT NOT NULL, -- Semestre atual (nome mais descritivo)
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de matrícula
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- TABELA DE PROFESSORES
-- ==============================
-- Extensão da tabela users para informações específicas de docentes
CREATE TABLE IF NOT EXISTS teachers (
    user_id INT NOT NULL, -- Referencia users.id 
    employee_number VARCHAR(20) NOT NULL UNIQUE, -- Número de registro do funcionário
    department_id INT NOT NULL, -- Departamento ao qual pertence
    status ENUM(
        'active',
        'on_leave',
        'retired',
        'former'
    ) NOT NULL DEFAULT 'active',
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de contratação
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- TABELA DE DISPONIBILIDADE DE CURSOS
-- ========================================
-- Define quantos alunos podem ser admitidos por curso a cada ano
CREATE TABLE IF NOT EXISTS course_availability (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    course_id INT NOT NULL, -- ID do curso
    academic_year INT NOT NULL, -- Ano letivo (nome mais descritivo)
    student_limit INT NOT NULL, -- Limite máximo de alunos
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- TABELA DE HORÁRIOS
-- ========================
-- Define os períodos de tempo disponíveis para aulas
CREATE TABLE IF NOT EXISTS time_slots (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    day_of_week ENUM(
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday'
    ) NOT NULL,
    shift ENUM(
        'morning',
        'afternoon',
        'evening',
        'night'
    ) NOT NULL,
    start_time TIME NOT NULL, -- Horário de início
    end_time TIME NOT NULL, -- Horário de término
    hours INT NOT NULL, -- Duração em horas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- TABELA DE TURMAS
-- ========================
-- Representa uma turma específica em um período
CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    name VARCHAR(20) NOT NULL, -- Nome da turma
    code VARCHAR(10) NOT NULL UNIQUE, -- Código único da turma (corrigido de 'sigla')
    course_id INT NOT NULL, -- Curso ao qual a turma pertence
    academic_year INT NOT NULL, -- Ano letivo
    semester INT NOT NULL, -- Semestre (1 ou 2)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ===================================
-- TABELA DE HORÁRIOS DAS TURMAS
-- ===================================
-- Relaciona turmas com seus horários específicos de disciplinas
CREATE TABLE IF NOT EXISTS class_schedules (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    class_id INT NOT NULL, -- ID da turma
    subject_id INT NOT NULL, -- Disciplina ministrada nesta turma
    teacher_id INT NOT NULL, -- ID do professor responsável
    time_slot_ids INT NOT NULL, -- ID do horário {"1", "2", "3"} (lista de IDs de time_slots)
    room_id INT, -- Sala onde as aulas são ministradas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===================================
-- TABELA DE SALAS 
-- ===================================
-- Define as salas disponíveis na instituição
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- Nome da sala
    description TEXT, -- Descrição da sala (opcional)
    localization TEXT UNIQUE, -- Localização da sala (ex: prédio, andar, etc.)
    capacity INT NOT NULL, -- Capacidade máxima de alunos
    type_of_room ENUM(
        'classroom', -- Sala de aula tradicional
        'library', -- Biblioteca (sala de leitura, estudo, etc.)
        'laboratory', -- Laboratório (química, física, informática, etc.)
        'conference', -- Sala de conferências ou reuniões
        'auditorium', -- Auditório para eventos maiores
        'other' -- Outros tipos de salas
    ) NOT NULL DEFAULT 'classroom', -- Tipo de montagem da sala
    acessibility BOOLEAN DEFAULT FALSE, -- Se a sala é acessível para pessoas com deficiência
    is_available BOOLEAN DEFAULT FALSE, -- Disponibilidade da sala
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===================================
-- TABELA DE RECURSOS 
-- ===================================
-- Define os recursos disponíveis na instituição
CREATE TABLE IF NOT EXISTS resources (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- Nome do recurso (ex: projetor, ar-condicionado)
    description TEXT, -- Descrição do recurso
    responsible_department_id INT NOT NULL, -- Departamento responsável pelo recurso
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===================================
-- TABELA DE RECURSOS Por SALA
-- ===================================
-- Define os recursos disponíveis em cada sala de aula
CREATE TABLE IF NOT EXISTS classroom_resources (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    classroom_id INT NOT NULL, -- ID da sala de aula
    resource_id INT NOT NULL, -- ID do recurso
    status_resources ENUM(
        'available', -- Recurso disponível
        'unavailable', -- Recurso indisponível
        'damaged', -- Recurso danificado
        'maintenance', -- Recurso em manutenção
        'lost' -- Recurso perdido
    ) NOT NULL DEFAULT 'available', -- Status do recurso
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ;
);

-- ===================================
-- TABELA DE HORARIOS DISPONIVEIS POR PROFESSOR
-- ===================================
-- Define os horários disponíveis de cada professor para ministrar aulas
CREATE TABLE IF NOT EXISTS teacher_availability (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    teacher_id INT NOT NULL, -- ID do professor
    time_slot_ids JSON NOT NULL, -- ID do horário {"1", "2", "3"} (lista de IDs de time_slots)
    total_hours INT NOT NULL, -- Total de horas semanais disponíveis
    aproved BOOLEAN DEFAULT FALSE, -- Se o horário foi aprovado pelo coordenado
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ======================================
-- TABELA DE MATRÍCULAS EM TURMAS
-- ======================================
-- Registra quais alunos estão matriculados em quais turmas
CREATE TABLE IF NOT EXISTS class_enrollments (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    student_user_id INT NOT NULL, -- ID do aluno
    class_id INT NOT NULL, -- ID da turma
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de matrícula na turma
    status ENUM(
        'active',
        'dropped',
        'completed',
        'failed'
    ) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- TABELA DE NOTAS
-- ========================
-- Armazena as avaliações dos alunos
CREATE TABLE IF NOT EXISTS grades (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    student_user_id INT NOT NULL, -- ID do aluno
    class_id INT NOT NULL, -- ID da turma
    assessment_type_id INT NOT NULL, -- ID do tipo de avaliação
    score DECIMAL(5, 2) NOT NULL, -- Nota obtida (0-100)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- TABELA DE TIPOS DE AVALIAÇÃO
-- ==============================
-- Define os tipos de avaliações que podem ser aplicadas
-- Podem ser configuráveis (PP1, PP2, Exame Final, Recuperação, Especial)
CREATE TABLE assessment_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    weight DECIMAL(5,2), -- Peso da avaliação
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- Aulas ministradas
-- ==============================
-- Tabela que representa as aulas dadas e marca faltas
CREATE TABLE IF NOT EXISTS classes_attended (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    class_id INT NOT NULL, -- ID da turma
    class_date DATE NOT NULL, -- Data da aula
    time_slot_id INT NOT NULL, -- Horário da aula
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- TABELA DE FREQUÊNCIA
-- ==============================
-- Registra a presença dos alunos em cada aula
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT  PRIMARY KEY,
    student_user_id INT NOT NULL, -- ID do aluno
    class_id INT NOT NULL, -- ID da turma
    classes_attended_id INT NOT NULL, -- ID da aula
    status ENUM(
        'present',
        'absent',
        'late',
        'excused'
    ) NOT NULL DEFAULT 'absent',
    justification TEXT, -- Justificativa para falta (se aplicável)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);