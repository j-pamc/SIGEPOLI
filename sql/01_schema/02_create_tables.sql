-- ==============================================================
-- SISTEMA DE GESTÃO ESCOLAR POLITÉCNICA (SIGEPOLI)
-- Schema do banco de dados
-- ==============================================================
-- Este schema suporta as seguintes funcionalidades:
-- ==============================================================

-- ==========================================================================================
-- Académica
-- oferecimento de cursos, criação de turmas, matrícula de alunos,
-- atribuição de professores e avaliação de desempenho discente
-- ==========================================================================================

-- TABELA DE CURSOS
-- Define os cursos oferecidos pela instituição
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Nome do curso
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE DISCIPLINAS
-- Catálogo de disciplinas disponíveis
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Nome da disciplina
    code VARCHAR(20) NOT NULL, -- Código único da disciplina
    description TEXT, -- Descrição do conteúdo da disciplina
    workload_hours INT NOT NULL, -- Carga horária em horas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE INFORMAÇÕES DA DISCIPLINA
-- Relaciona disciplinas com cursos e define semestre e pré-requisitos
CREATE TABLE IF NOT EXISTS course_subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL, -- ID da disciplina
    course_id INT NOT NULL, -- ID do curso
    semester INT NOT NULL, -- Semestre em que a disciplina é oferecida
    prerequisites JSON, -- Lista de IDs de disciplinas pré-requisito
    syllabus TEXT, -- Programa detalhado da disciplina
    is_mandatory BOOLEAN NOT NULL DEFAULT true, -- Se a disciplina é obrigatória ou optativa
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE DISPONIBILIDADE DE CURSOS
-- Define quantos alunos podem ser admitidos por curso a cada ano
CREATE TABLE IF NOT EXISTS course_availability (
    course_id INT NOT NULL, -- ID do curso
    academic_year INT NOT NULL, -- Ano letivo (nome mais descritivo)
    student_limit INT NOT NULL, -- Limite máximo de alunos
    prerequisites JSON, -- Lista de pré-requisitos para se candidatar ao curso
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE TURMAS
-- Representa uma turma específica em um período
CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL, -- Nome da turma
    code VARCHAR(10) NOT NULL, -- Código único da turma (corrigido de 'sigla')
    course_id INT NOT NULL, -- Curso ao qual a turma pertence
    academic_year INT NOT NULL, -- Ano letivo
    semester INT NOT NULL, -- Semestre (1 ou 2)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE HORÁRIOS
-- Define os períodos de tempo disponíveis para aulas
CREATE TABLE IF NOT EXISTS time_slots (
    id INT AUTO_INCREMENT PRIMARY KEY,
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE HORÁRIOS DAS TURMAS
-- Relaciona turmas com seus horários específicos de disciplinas
CREATE TABLE IF NOT EXISTS class_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL, -- ID da turma
    subject_id INT NOT NULL, -- Disciplina ministrada nesta turma
    teacher_id INT NOT NULL, -- ID do professor responsável
    time_slot_ids JSON NOT NULL, -- IDs dos horários [1, 2, 3] (lista de IDs de time_slots)
    room_id INT, -- Sala onde as aulas são ministradas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE SALAS
-- Define as salas disponíveis na instituição
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, -- Nome da sala
    description TEXT, -- Descrição da sala (opcional)
    localization TEXT, -- Localização da sala (ex: prédio, andar, etc.)
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE RECURSOS
-- Define os recursos disponíveis na instituição
CREATE TABLE IF NOT EXISTS resources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, -- Nome do recurso (ex: projetor, ar-condicionado)
    description TEXT, -- Descrição do recurso
    responsible_department_id INT NOT NULL, -- Departamento responsável pelo recurso
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE RECURSOS Por SALA
-- Define os recursos disponíveis em cada sala de aula
CREATE TABLE IF NOT EXISTS room_resources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL, -- ID da sala
    resource_id INT NOT NULL, -- ID do recurso
    status_resources ENUM(
        'available', -- Recurso disponível
        'unavailable', -- Recurso indisponível
        'damaged', -- Recurso danificado
        'maintenance', -- Recurso em manutenção
        'lost' -- Recurso perdido
    ) NOT NULL DEFAULT 'available', -- Status do recurso
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE RESERVAS DE SALAS
-- Gerenciar reservas especiais de salas para atividades não regulares
CREATE TABLE IF NOT EXISTS room_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL, -- ID da sala reservada
    department_id INT NOT NULL, -- ID do departamento solicitante
    reason TEXT NOT NULL, -- Motivo da reserva
    date DATE NOT NULL, -- Data da reserva
    start_time TIME NOT NULL, -- Horário de início da reserva
    end_time TIME NOT NULL, -- Horário de término da reserva
    purpose TEXT, -- Propósito da reserva (ex: evento, reunião, aula extra)
    status ENUM(
        'pending', -- Reserva pendente
        'confirmed', -- Reserva confirmada
        'cancelled', -- Reserva cancelada
        'completed' -- Reserva concluída
    ) NOT NULL DEFAULT 'pending', -- Status da reserva
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE ALunOS
-- Armazena informações dos alunos
CREATE TABLE IF NOT EXISTS students (
    user_id INT NOT NULL, -- Referencia users.id
    student_number VARCHAR(50) NOT NULL, -- Número de matrícula único
    studying BOOLEAN DEFAULT TRUE, -- Se o aluno está ativo
    searching BOOLEAN DEFAULT TRUE, -- Se o aluno está procurando emprego
    recommendation TEXT, -- Recomendações ou observações sobre o aluno
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE INSCRIÇÃO DE ALUNOS
-- Registra a matrícula dos alunos nos cursos
CREATE TABLE IF NOT EXISTS student_enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL, -- ID do aluno
    course_id INT NOT NULL, -- ID do curso
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de matrícula
    status ENUM(
        'active', -- Ativo
        'suspended', -- Suspenso
        'finished', -- Concluído
        'dropout', -- Evasão
        'transferred', -- Transferido
        'other' -- Outro status
    ) NOT NULL DEFAULT 'active', -- Status da matrícula
    conclusion_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de conclusão
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE MATRÍCULAS EM TURMAS
-- Registra quais alunos estão matriculados em quais turmas
CREATE TABLE IF NOT EXISTS class_enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL, -- ID do aluno
    class_id INT NOT NULL, -- ID da turma
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de matrícula na turma
    status ENUM(
        'active',
        'dropped',
        'completed',
        'failed'
    ) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE PROFESSORES
-- Armazena informações dos professores
CREATE TABLE IF NOT EXISTS teachers (
    user_id INT NOT NULL, -- Referência ao staff
    academic_rank ENUM(
        'instructor',
        'assistant_professor',
        'associate_professor',
        'full_professor',
        'emeritus'
    ) DEFAULT 'instructor',
    tenure_status ENUM(
        'tenured',
        'tenure_track',
        'adjunct',
        'visiting',
        'emeritus'
    ) DEFAULT 'adjunct',
    max_weekly_hours INT DEFAULT 40,
    research_area TEXT,
    is_thesis_advisor BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE ESPECIALIZAÇÕES DE PROFESSORES
-- Áreas de expertise e disciplinas que podem lecionar
CREATE TABLE IF NOT EXISTS teacher_specializations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    subject_area VARCHAR(100) NOT NULL,
    subject_id INT NOT NULL, -- ID da disciplina (referencia subjects.id)
    proficiency_level ENUM(
        'basic',
        'intermediate',
        'advanced',
        'expert'
    ) DEFAULT 'intermediate',
    years_experience INT DEFAULT 0,
    is_certified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE HORARIOS DISPONIVEIS POR PROFESSOR
-- Define os horários disponíveis de cada professor para ministrar aulas
CREATE TABLE IF NOT EXISTS teacher_availability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL, -- ID do professor
    time_slot_ids JSON NOT NULL, -- ID do horário {"1", "2", "3"} (lista de IDs de time_slots)
    total_hours INT NOT NULL, -- Total de horas semanais disponíveis
    aproved BOOLEAN DEFAULT FALSE, -- Se o horário foi aprovado pelo coordenado
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE NOTAS
-- Armazena as avaliações dos alunos
CREATE TABLE IF NOT EXISTS grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL, -- ID do aluno
    class_id INT NOT NULL, -- ID da turma
    assessment_type_id INT NOT NULL, -- ID do tipo de avaliação
    score DECIMAL(5, 2) NOT NULL, -- Nota obtida (0-100)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE TIPOS DE AVALIAÇÃO
-- Define os tipos de avaliações que podem ser aplicadas
-- Podem ser configuráveis (PP1, PP2, Exame Final, Recuperação, Especial)
CREATE TABLE assessment_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL, -- Código único
    name VARCHAR(50) NOT NULL,
    description TEXT,
    weight DECIMAL(5, 2), -- Peso da avaliação
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE FREQUÊNCIA
-- Registra a presença dos alunos em cada aula
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL, -- ID do aluno
    classes_attended_id INT NOT NULL, -- ID da aula
    status ENUM(
        'present',
        'absent',
        'late',
        'excused'
    ) NOT NULL DEFAULT 'present',
    justification TEXT, -- Justificativa para falta (se aplicável)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Aulas ministradas
-- Tabela que representa as aulas dadas e marca faltas
CREATE TABLE IF NOT EXISTS classes_attended (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL, -- ID da turma
    class_date DATE NOT NULL, -- Data da aula
    time_slot_id INT NOT NULL, -- Horário da aula
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================================================================================
-- Administrativa
-- pessoal administrativo distribuído por departamentos (Secretaria Académica,
-- Tesouraria, Recursos Humanos, Biblioteca, Laboratórios, etc.)
-- ==========================================================================================

-- TABELA DE USUÁRIOS (CENTRAL)
-- Tabela principal que centraliza todos os usuários do sistema
-- Implementa Single Table Inheritance para diferentes tipos de usuários
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL, -- Primeiro nome do usuário
    last_name VARCHAR(50) NOT NULL, -- Sobrenome do usuário
    email VARCHAR(100) NOT NULL, -- Email único para comunicação
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
    is_verified BOOLEAN DEFAULT FALSE, -- Se o usuário verificou seu email
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE PAPÉIS DE USUÁRIOS
-- Define os diferentes papéis no sistema
-- Papel: super_admin, admin, student, staff,
CREATE TABLE IF NOT EXISTS user_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL, -- Código único
    name VARCHAR(50) NOT NULL,
    description TEXT,
    permissions JSON,
    hierarchy_level INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE RELACIONAMENTO USUÁRIO-PAPEL
-- Relaciona usuários com seus papéis (Many-to-Many)
CREATE TABLE IF NOT EXISTS user_role_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_by INT, -- Quem atribuiu o papel
    is_active BOOLEAN DEFAULT TRUE,
    expires_at TIMESTAMP NULL, -- Para papéis temporários
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE IDENTIFICAÇÃO DE USUÁRIOS
-- Armazena informações oficiais de identificação
CREATE TABLE IF NOT EXISTS user_identification (
    user_id INT NOT NULL, -- Referencia users.id
    document_type ENUM(
        'id_card', -- Cartão de identidade (padrão internacional)
        'residence_id', -- Cartão de residência
        'passport', -- Passaporte
        'other' -- Outros tipos de documentos
    ) NOT NULL,
    document_number VARCHAR(20) NOT NULL, -- Número do documento único
    issue_date DATE, -- Data de emissão do documento
    expiration_date DATE, -- Data de expiração do documento (se aplicável)
    nationality VARCHAR(50), -- Nacionalidade do usuário
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE SAUDE DO USUÁRIO
-- Armazena informações de saúde e emergência do usuário
CREATE TABLE IF NOT EXISTS user_health (
    user_id INT NOT NULL, -- Referencia users.id
    conditions TEXT, -- Condições médicas conhecidas
    medications TEXT, -- Medicamentos em uso
    allergies TEXT, -- Alergias conhecidas
    need_assessibility BOOLEAN DEFAULT FALSE, -- Necessidade de acessibilidade
    emergency_contact_name VARCHAR(100),
    emergency_contact_relationship ENUM(
        'parent', -- Pai/Mãe
        'sibling', -- Irmão/Irmã
        'spouse', -- Cônjuge
        'family', -- Outro membro da família
        'friend', -- Amigo
        'other' -- Outro tipo de relacionamento
    ) NOT NULL, -- Relacionamento com o contato de emergência
    emergency_contact_phone VARCHAR(20), -- Telefone do contato de emergência
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE DEPARTAMENTOS
-- Organiza a estrutura administrativa da instituição
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Nome completo do departamento
    acronym VARCHAR(10) NOT NULL, -- Sigla do departamento (corrigido de 'sigla')
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE ORÇAMENTOS POR DEPARTAMENTO
-- Armazena o orçamento anual de cada departamento
CREATE TABLE IF NOT EXISTS department_budgets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL, -- ID do departamento
    fiscal_year INT NOT NULL, -- Ano fiscal (nome mais descritivo)
    budget_amount DECIMAL(15, 2) NOT NULL, -- Valor do orçamento
    spent_amount DECIMAL(15, 2) DEFAULT 0.00, -- Valor já gasto
    remaining_amount DECIMAL(15, 2) DEFAULT 0.00, -- Valor restante
    on_account BOOLEAN DEFAULT FALSE, -- Se o orçamento está em conta
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE FUNCIONÁRIOS
-- Armazena informações dos funcionários administrativos
CREATE TABLE IF NOT EXISTS staff (
    user_id INT NOT NULL, -- Referencia users.id
    staff_number VARCHAR(50) NOT NULL, -- Número de identificação do funcionário
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de contratação
    employment_type ENUM(
        'full_time',
        'part_time',
        'contract',
        'temporary',
        'visiting'
    ) DEFAULT 'full_time',
    employment_status ENUM(
        'active',
        'on_leave',
        'retired',
        'terminated',
        'probationary'
    ) DEFAULT 'active',
    department_id INT,
    staff_category ENUM(
        'academic',
        'administrative',
        'technical',
        'support',
        'management',
        'other'
    ) NOT NULL, -- Categoria do funcionário
    office_location VARCHAR(100),
    status ENUM(
        'active',
        'on_leave',
        'retired',
        'former'
    ) NOT NULL DEFAULT 'active', -- Status do funcionário
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE QUALIFICAÇÕES DOS FUNCIONÁRIOS
-- Armazena as qualificações e formações dos funcionários administrativos e docentes
CREATE TABLE IF NOT EXISTS academic_qualifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- Referencia users.id
    title VARCHAR(100) NOT NULL, -- Título da qualificação (ex: Bacharel em Engenharia)
    field_of_study VARCHAR(100), -- Área de estudo (opcional)
    qualification_type ENUM(
        'high_school', -- Ensino médio
        'bachelor', -- Graduação
        'master', -- Mestrado
        'doctorate', -- Doutorado
        'specialization', -- Especialização
        'skill', -- Habilidade
        'experience', -- Experiência
        'other' -- Outros tipos de qualificação
    ) NOT NULL DEFAULT 'other', -- Tipo de qualificação
    institution VARCHAR(100) NOT NULL, -- Instituição onde a qualificação foi obtida
    completion_date DATE, -- Data de conclusão da qualificação
    document_url TEXT, -- URL do documento comprobatório
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE CARGOS
-- Define os cargos ou funções dos funcionários administrativos
CREATE TABLE IF NOT EXISTS positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Nome do cargo
    description TEXT, -- Descrição das responsabilidades do cargo
    amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00, -- Salário do cargo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE FUNCIONÁRIOS POR CARGO
-- Relaciona funcionários com seus respectivos cargos
-- (decano, coordenador, professor, assistente, etc.)
CREATE TABLE IF NOT EXISTS staff_positions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- Referencia users.id
    position_id INT NOT NULL, -- ID do cargo 
    description TEXT, -- Descrição das responsabilidades no cargo
    start_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Data de início no cargo
    end_date DATE, -- Data de término no cargo (se aplicável)
    status ENUM(
        'active',
        'inactive',
        'terminated'
    ) NOT NULL DEFAULT 'active', -- Status do cargo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE FÉRIAS E LICENÇAS
-- Registra as férias e licenças dos funcionários administrativos
CREATE TABLE IF NOT EXISTS staff_leaves (
    id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL, -- Referencia users.id
    leave_type ENUM(
        'vacation',
        'sick_leave',
        'parental_leave',
        'study_leave',
        'sabbatical',
        'personal_leave',
        'bereavement_leave',
        'research_leave',
        'other'
    ) NOT NULL,
    reason TEXT, -- Motivo da licença (opcional)
    required_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data de solicitação da licença
    start_date DATE NOT NULL, -- Data de início da licença
    end_date DATE NOT NULL, -- Data de término da licença
    status ENUM(
        'pending', -- Pendente
        'approved', -- Aprovada
        'rejected' -- Rejeitada
    ) NOT NULL DEFAULT 'pending', -- Status da licença
    replacement_staff_id INT, -- ID do funcionário substituto (referencia users.id - opcional)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE AVALIAÇÕES
-- Registra as avaliações de desempenho dos funcionários administrativos e docentes
CREATE TABLE IF NOT EXISTS evaluation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    iniciator_user_id INT NOT NULL, -- ID do usuário que inicia a avaliação (referencia users.id)
    type_of_evaluated ENUM(
        'staff', -- Funcionário administrativo
        'teacher', -- Professor
        'course', -- Curso
        'service', -- Serviço prestado
        'other' -- Outro tipo de avaliação
    ) NOT NULL, -- Tipo de entidade avaliada
    type_of_evaluator ENUM(
        'staff', -- Funcionário administrativo
        'teacher', -- Professor
        'student', -- Aluno
        'external' -- Avaliador externo
    ) NOT NULL, -- Tipo de avaliador
    evaluation_type ENUM(
        'annual',
        'probationary',
        'promotion',
        'student_feedback',
        'peer_review',
        'self_assessment'
    ) NOT NULL,
    evaluation_date_start DATE NOT NULL, -- Data de início da avaliação
    evaluation_date_end DATE NOT NULL, -- Data de término da avaliação
    title VARCHAR(100) NOT NULL, -- Título da avaliação
    description TEXT, -- Descrição da avaliação
    criterios JSON, -- Critérios de avaliação (ex: {"criteria1": "description", "criteria2": "description"})
    status_evaluation ENUM(
        'started', -- Avaliação iniciada
        'in_progress', -- Avaliação em progresso
        'reviewed',
        'finalized', -- Avaliação finalizada
        'disputed', -- Avaliação contestada
    ) DEFAULT 'started', -- Status da avaliação
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE AVALIAÇÕES DE DESEMPENHO
-- Registra as avaliações de desempenho dos funcionários administrativos e docentes
CREATE TABLE IF NOT EXISTS staff_evaluation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL, -- Referencia evaluation.id
    staff_id INT NOT NULL, -- Referencia users.id
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE AVALIAÇÕES DE CURSOS
-- Registra as avaliações dos cursos pelos alunos
CREATE TABLE IF NOT EXISTS course_evaluation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL, -- Referencia evaluation.id
    course_id INT NOT NULL, -- ID do curso avaliado (referencia courses.id)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE PERFORMANCE
-- Registra RESULTADOS das avaliações de desempenho
-- Pode ser usado para feedback de alunos, professores, funcionários e companias terceirizadas
CREATE TABLE IF NOT EXISTS performance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL, -- Referencia evaluation.id
    evaluator_id INT NOT NULL, -- ID do avaliador (referencia users.id)
    evaluation_date DATE NOT NULL, -- Data da avaliação
    overall_score DECIMAL(3, 2), -- Nota geral da avaliação (0-5)
    score INT, -- Nota da avaliação
    feedback TEXT, -- Comentários do avaliador
    status ENUM(
        'draft',
        'submitted',
        'reviewed',
        'approved',
        'disputed'
    ) DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE ACESSO DE ALUNOS NO CURSO
-- Registra o acesso dos alunos aos cursos
CREATE TABLE IF NOT EXISTS course_access (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- ID do user q quer ser aluno
    course_availability_id INT NOT NULL, -- ID do curso e ano academico a q se inscreve course_availability.course_id
    exam_score DECIMAL(5, 2), -- Nota do exame de admissão
    status ENUM(
        'pending', -- Pendente
        'approved', -- Aprovado
        'rejected', -- Rejeitado
        'waitlisted' -- Em lista de espera
    ) NOT NULL DEFAULT 'pending', -- Status da inscrição
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE SERVIÇOS
-- Registra os serviços prestados pela instituição aos alunos (secretaria academica, biblioteca, etc.)
CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Nome do serviço 
    description TEXT, -- Descrição do serviço
    service_types_id INT NOT NULL, -- ID do tipo de serviço 
    value DECIMAL(10, 2) NOT NULL, -- Valor do serviço
    departament_id INT NOT NULL, -- ID do departamento responsável pelo serviço
    status ENUM(
        'active',
        'inactive',
        'suspended',
        'discontinued'
    ) NOT NULL DEFAULT 'active', -- Status do serviço
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE CATEGORIA DE SERVIÇOS
-- Define as categorias de serviços oferecidos pela instituição
CREATE TABLE IF NOT EXISTS service_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, -- Nome da categoria de serviço
    description TEXT, -- Descrição da categoria de serviço
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE AVALIAÇÕES DE SERVIÇOS
-- Registra as avaliações de serviços prestados pela instituição
CREATE TABLE IF NOT EXISTS service_evaluation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL, -- Referencia evaluation.id
    service_id INT NOT NULL, -- ID da empresa prestadora de serviço (referencia users.id)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--TABELA DE PAGAMENTOS
-- Registra os pagamentos realizados
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10, 2) NOT NULL, -- Valor pago
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data do pagamento
    payment_method_id INT NOT NULL, -- ID do método de pagamento (referencia payment_types.id)
    reference_number VARCHAR(50), -- Número de referência do pagamento
    status ENUM(
        'pending', -- Pendente
        'completed', -- Concluído
        'failed', -- Falhou
        'refunded' -- Reembolsado
    ) NOT NULL DEFAULT 'pending', -- Status do pagamento
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE PAGAMENTOS POR SERVIÇO
-- Registra os pagamentos realizados pelos serviços prestados
CREATE TABLE IF NOT EXISTS studant_payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL, -- Referencia payments.id
    service_id INT NOT NULL, -- ID do serviço pago (referencia services.id)
    student_id INT NOT NULL, -- ID do aluno que pagou (referencia students.user_id)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE PAGAMENTOS A EMPRESAS
-- Registra os pagamentos realizados às empresas terceirizadas
CREATE TABLE IF NOT EXISTS company_payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL, -- Referencia payments.id
    company_id INT NOT NULL, -- ID da empresa que recebeu o pagamento (referencia users.id)
    department_budgets_id INT NOT NULL, -- ID do orçamento do departamento (referencia department_budgets.id)
    approved_by_staff INT NOT NULL, -- ID do funcionario que aprovou o pagamento (referencia users.id)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE PAGAMENTOS A FUNCIONÁRIOS
-- Registra os pagamentos realizados aos funcionários administrativos
CREATE TABLE IF NOT EXISTS staff_payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_of_payment ENUM(
        'salary', -- Salário mensal
        'bonus', -- Bônus
        'reimbursement', -- Reembolso de despesas
        'commission', -- Comissão
        'other' -- Outro tipo de pagamento
    ) NOT NULL, -- Tipo de pagamento
    payment_id INT NOT NULL, -- Referencia payments.id
    staff_id INT NOT NULL, -- ID do funcionário que recebeu o pagamento (referencia users.id)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE TIPOS DE PAGAMENTO
-- Define os tipos de pagamento disponíveis para os serviços
CREATE TABLE IF NOT EXISTS payment_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, -- Nome do tipo de pagamento
    description TEXT, -- Descrição do tipo de pagamento
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--  TABELA DE MULTAS (ALUNOS EMPRESAS)
-- Registra as multas aplicadas a alunos e empresas
CREATE TABLE IF NOT EXISTS fines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL, -- ID do pagamento (referencia payments.id)
    fined ENUM(
        'student', -- Aluno
        'company' -- Empresa
    ) NOT NULL, -- Tipo de entidade multada
    amount DECIMAL(10, 2) NOT NULL, -- Valor da multa
    reason VARCHAR(255) NOT NULL, -- Motivo da multa
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================================================================================
-- Coordenação Pedagógica
-- coordenadores de curso responsáveis por currículos, grade horária e
-- indicadores de qualidade
-- ==========================================================================================

-- ==========================================================================================
-- Operacional
-- contratação e fiscalização de empresas terceirizadas (limpeza, segurança,
-- cafetaria) com metas de SLA (Service Level Agreement) e pagamentos mensais
-- ==========================================================================================

-- TABELA DE EMPRESAS
-- Armazena informações das empresas terceirizadas
CREATE TABLE IF NOT EXISTS companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    nif VARCHAR(20) NOT NULL, -- NIF único da empresa
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE EMPRESAS POR DEPARTAMENTO
-- Relaciona empresas com departamentos responsáveis pela fiscalização
CREATE TABLE IF NOT EXISTS companies_departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL, -- ID da empresa (referencia companies.id)
    department_id INT NOT NULL, -- ID do departamento (referencia departments.id)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE CONTRATOS DE EMPRESAS
-- Registra os contratos firmados com empresas terceirizadas
CREATE TABLE IF NOT EXISTS companies_contracts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL, -- ID da empresa (referencia companies.id)
    contract_details TEXT NOT NULL, -- Detalhes do contrato
    started_at DATE NOT NULL, -- Data de início do contrato
    ended_at DATE, -- Data de término do contrato (se aplicável)
    status ENUM(
        'active', -- Contrato ativo
        'expired', -- Contrato expirado
        'terminated', -- Contrato encerrado
        'suspended' -- Contrato suspenso
    ) NOT NULL DEFAULT 'active', -- Status do contrato
    signed_by_staff INT NOT NULL, -- ID do funcionario que assinou o contrato (referencia users.id)
    signed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data de assinatura do contrato
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE SLA (Service Level Agreement)
-- Define os acordos de nível de serviço com as empresas terceirizadas
CREATE TABLE IF NOT EXISTS companies_sla (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL, -- ID da empresa (referencia companies.id)
    sla_name VARCHAR(100) NOT NULL, -- Nome do SLA
    description TEXT, -- Descrição do SLA
    sla_type ENUM(
        'performance', -- SLA de desempenho
        'availability', -- SLA de disponibilidade
        'response_time', -- SLA de tempo de resposta
        'quality', -- SLA de qualidade
        'other' -- Outro tipo de SLA
    ) NOT NULL, -- Tipo do SLA
    target_percentage DECIMAL(5, 2) NOT NULL DEFAULT 90.00, -- Percentual alvo do SLA
    penalty_percentage DECIMAL(5, 2) DEFAULT 10.00, -- Percentual de penalidade se não atingir
    sla_details TEXT NOT NULL, -- Detalhes do SLA
    is_active BOOLEAN DEFAULT TRUE, -- Se o SLA está ativo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE SLA AVALIAÇÕES
-- Registra as avaliações dos SLA das empresas terceirizadas
CREATE TABLE IF NOT EXISTS companies_sla_evaluation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL, -- ID da empresa avaliada (referencia companies.id)
    sla_id INT NOT NULL, -- ID do SLA avaliado (referencia companies_sla.id)
    evaluation_period DATE NOT NULL, -- Período de avaliação (mês/ano)
    achieved_percentage DECIMAL(5, 2) NOT NULL, -- Percentual alcançado
    penalty_applied BOOLEAN DEFAULT FALSE, -- Se foi aplicada penalidade
    penalty_amount DECIMAL(10, 2) DEFAULT 0.00, -- Valor da penalidade
    evaluator_id INT NOT NULL, -- ID do avaliador (referencia users.id)
    feedback TEXT, -- Comentários do avaliador
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================================================================================
-- AUDITORIA E CONFIGURAÇÃO DO SISTEMA
-- ==========================================================================================

-- TABELA DE LOGS DE AUDITORIA
-- Registra todas as operações críticas do sistema para rastreabilidade
CREATE TABLE IF NOT EXISTS audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- ID do usuário que executou a operação
    table_name VARCHAR(50) NOT NULL, -- Nome da tabela afetada
    operation_type ENUM(
        'INSERT',
        'UPDATE',
        'DELETE',
        'LOGIN',
        'LOGOUT',
        'ACCESS_DENIED',
        'PERMISSION_CHANGE',
        'SYSTEM_CONFIG'
    ) NOT NULL, -- Tipo de operação realizada
    record_id INT, -- ID do registro afetado (se aplicável)
    old_values JSON, -- Valores anteriores (para UPDATE e DELETE)
    new_values JSON, -- Valores novos (para INSERT e UPDATE)
    ip_address VARCHAR(45), -- Endereço IP do usuário
    user_agent TEXT, -- Navegador/aplicação utilizada
    session_id VARCHAR(128), -- ID da sessão do usuário
    description TEXT, -- Descrição adicional da operação
    severity ENUM(
        'LOW',
        'MEDIUM',
        'HIGH',
        'CRITICAL'
    ) NOT NULL DEFAULT 'LOW', -- Nível de severidade da operação
    status ENUM(
        'SUCCESS',
        'FAILURE',
        'WARNING'
    ) NOT NULL DEFAULT 'SUCCESS', -- Status da operação
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    execution_time_ms INT DEFAULT 0 -- Tempo de execução em milissegundos
);

-- ==========================================================================================
-- BIBLIOTECA
-- ==========================================================================================

-- TABELA DE ITENS DA BIBLIOTECA
-- Catálogo geral de recursos da biblioteca (livros, revistas, equipamentos, etc.)
CREATE TABLE IF NOT EXISTS library_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL, -- Título do item
    isbn VARCHAR(20), -- ISBN para livros
    barcode VARCHAR(50), -- Código de barras único
    item_type ENUM(
        'book',
        'journal',
        'magazine',
        'newspaper',
        'thesis',
        'dissertation',
        'dvd',
        'cd',
        'computer',
        'equipment',
        'digital_resource',
        'other'
    ) NOT NULL, -- Tipo do item
    format ENUM(
        'physical',
        'digital',
        'audiobook',
        'ebook'
    ) NOT NULL DEFAULT 'physical', -- Formato do item
    language VARCHAR(10) DEFAULT 'pt', -- Idioma do item (código ISO)
    author VARCHAR(255), -- Autor principal
    publisher VARCHAR(255), -- Editora
    publication_year YEAR, -- Ano de publicação
    subject_area VARCHAR(100), -- Área temática
    location VARCHAR(100), -- Localização física na biblioteca
    acquisition_date DATE, -- Data de aquisição
    acquisition_cost DECIMAL(10, 2), -- Custo de aquisição
    condition_status ENUM(
        'excellent',
        'good',
        'fair',
        'poor',
        'damaged',
        'lost'
    ) DEFAULT 'excellent', -- Estado de conservação
    availability_status ENUM(
        'available',
        'checked_out',
        'reserved',
        'maintenance',
        'unavailable'
    ) DEFAULT 'available', -- Status de disponibilidade
    max_loan_days INT DEFAULT 15, -- Dias máximos de empréstimo
    renewal_limit INT DEFAULT 2, -- Limite de renovações
    description TEXT, -- Descrição ou resumo do item
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE EMPRÉSTIMOS DA BIBLIOTECA
-- Registra empréstimos, devoluções e histórico de uso dos itens
CREATE TABLE IF NOT EXISTS library_loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    library_item_id INT NOT NULL, -- ID do item emprestado
    borrower_id INT NOT NULL, -- ID do usuário que pegou emprestado
    loan_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Data do empréstimo
    due_date TIMESTAMP NOT NULL, -- Data de devolução prevista
    return_date TIMESTAMP, -- Data da devolução efetiva
    renewal_count INT DEFAULT 0, -- Número de renovações
    status ENUM(
        'active', -- Empréstimo ativo
        'returned', -- Devolvido
        'overdue', -- Em atraso
        'lost', -- Perdido
        'damaged' -- Danificado
    ) NOT NULL DEFAULT 'active', -- Status do empréstimo
    late_fee_amount DECIMAL(8, 2) DEFAULT 0.00, -- Valor da multa por atraso
    damage_fee_amount DECIMAL(8, 2) DEFAULT 0.00, -- Valor da multa por danos
    notes TEXT, -- Observações sobre o empréstimo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- TABELA DE NOTIFICAÇÕES
-- Gerencia todas as notificações do sistema para usuários
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- ID do usuário que receberá a notificação
    title VARCHAR(255) NOT NULL, -- Título da notificação
    message TEXT NOT NULL, -- Conteúdo da notificação
    notification_type ENUM(
        'system', -- Notificação do sistema
        'academic', -- Notificação acadêmica
        'administrative', -- Notificação administrativa
        'financial', -- Notificação financeira
        'library', -- Notificação da biblioteca
        'general' -- Notificação geral
    ) NOT NULL DEFAULT 'general', -- Tipo de notificação
    status ENUM(
        'unread', -- Não lida
        'read' -- Lida
    ) NOT NULL DEFAULT 'unread', -- Status da notificação
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);