# INSTRUÇÕES PARA GERAR O DIAGRAMA DER VISUAL

## Opções para Gerar o Diagrama DER

### 1. **MySQL Workbench** (Recomendado)
1. Abra o MySQL Workbench
2. Vá em **Database** → **Reverse Engineer**
3. Conecte ao banco SIGEPOLI
4. Selecione todas as tabelas
5. Execute o reverse engineering
6. O diagrama será gerado automaticamente

### 2. **dbdiagram.io** (Online)
1. Acesse https://dbdiagram.io
2. Crie uma nova conta ou faça login
3. Crie um novo diagrama
4. Use o seguinte código:

```sql
// SIGEPOLI - Sistema de Gestão Escolar Politécnica

Table users {
  id int [pk, increment]
  first_name varchar(50) [not null]
  last_name varchar(50) [not null]
  email varchar(100) [unique, not null]
  phone varchar(20)
  birth_date date
  gender enum('male', 'female', 'other')
  address text
  status enum('active', 'inactive', 'suspended') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table staff {
  user_id int [pk, ref: > users.id]
  employee_number varchar(20) [unique, not null]
  hire_date date [not null]
  contract_type enum('permanent', 'temporary', 'part_time') [not null]
  salary decimal(10, 2)
  status enum('active', 'inactive', 'terminated') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table students {
  user_id int [pk, ref: > users.id]
  student_number varchar(20) [unique, not null]
  enrollment_date date [not null]
  status enum('active', 'inactive', 'graduated', 'dropped') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table teachers {
  staff_id int [pk, ref: > staff.user_id]
  hire_date date [not null]
  contract_type enum('permanent', 'temporary', 'part_time') [not null]
  salary decimal(10, 2)
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table departments {
  id int [pk, increment]
  name varchar(100) [not null]
  description text
  head_staff_id int [ref: > staff.user_id]
  status enum('active', 'inactive') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table courses {
  id int [pk, increment]
  name varchar(100) [not null]
  description text
  duration_semesters int [not null]
  department_id int [ref: > departments.id]
  coordinator_staff_id int [ref: > staff.user_id]
  level enum('skill', 'technical', 'graduate', 'postgraduate', 'specialization', 'master', 'doctorate') [default: 'graduate']
  status enum('active', 'inactive', 'suspended', 'discontinued') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table subjects {
  id int [pk, increment]
  name varchar(100) [not null]
  code varchar(20) [unique, not null]
  description text
  workload_hours int [not null]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table course_subjects {
  id int [pk, increment]
  subject_id int [ref: > subjects.id]
  course_id int [ref: > courses.id]
  semester int [not null]
  prerequisites json
  syllabus text
  is_mandatory boolean [default: true]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table classes {
  id int [pk, increment]
  name varchar(20) [not null]
  code varchar(10) [unique, not null]
  course_id int [ref: > courses.id]
  academic_year int [not null]
  semester int [not null]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table class_schedules {
  id int [pk, increment]
  class_id int [ref: > classes.id]
  subject_id int [ref: > subjects.id]
  teacher_id int [ref: > teachers.staff_id]
  time_slot_ids json [not null]
  room_id int [ref: > rooms.id]
  status enum('draft', 'approved', 'rejected') [default: 'draft']
  approved_by int [ref: > staff.user_id]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table rooms {
  id int [pk, increment]
  name varchar(50) [not null]
  description text
  localization text
  capacity int [not null]
  type_of_room enum('classroom', 'library', 'laboratory', 'conference', 'auditorium', 'other') [default: 'classroom']
  acessibility boolean [default: false]
  is_available boolean [default: false]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table resources {
  id int [pk, increment]
  name varchar(50) [not null]
  description text
  responsible_department_id int [ref: > departments.id]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table room_resources {
  id int [pk, increment]
  room_id int [ref: > rooms.id]
  resource_id int [ref: > resources.id]
  status_resources enum('available', 'unavailable', 'damaged', 'maintenance', 'lost') [default: 'available']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table payments {
  id int [pk, increment]
  amount decimal(10, 2) [not null]
  payment_method_id int [ref: > payment_types.id]
  reference_number varchar(50) [unique, not null]
  status enum('pending', 'completed', 'failed', 'refunded') [default: 'pending']
  payment_date timestamp [default: `now()`]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table student_payments {
  id int [pk, increment]
  payment_id int [ref: > payments.id]
  service_id int [ref: > services.id]
  student_id int [ref: > students.user_id]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table company_payments {
  id int [pk, increment]
  payment_id int [ref: > payments.id]
  company_id int [ref: > companies.id]
  department_budgets_id int [ref: > department_budgets.id]
  approved_by_staff int [ref: > staff.user_id]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table staff_payments {
  id int [pk, increment]
  payment_id int [ref: > payments.id]
  staff_id int [ref: > staff.user_id]
  type_of_payment enum('salary', 'bonus', 'reimbursement', 'commission', 'other') [not null]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table companies {
  id int [pk, increment]
  name varchar(100) [not null]
  contact_person varchar(100)
  phone varchar(20)
  email varchar(100)
  address text
  status enum('active', 'inactive') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table student_enrollments {
  id int [pk, increment]
  student_id int [ref: > students.user_id]
  course_id int [ref: > courses.id]
  enrollment_date date [not null]
  status enum('active', 'inactive', 'graduated', 'dropped') [default: 'active']
  conclusion_date date
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table class_enrollments {
  id int [pk, increment]
  student_id int [ref: > students.user_id]
  class_schedules_id int [ref: > class_schedules.id]
  enrollment_date date [not null]
  type_of_enrollment enum('regular', 'special', 'audit') [default: 'regular']
  status enum('active', 'inactive', 'dropped') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table grades {
  id int [pk, increment]
  student_id int [ref: > students.user_id]
  class_schedules_id int [ref: > class_schedules.id]
  assessment_type_id int [ref: > assessment_types.id]
  score decimal(4, 2) [not null]
  comments text
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table payment_types {
  id int [pk, increment]
  name varchar(50) [not null]
  description text
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table services {
  id int [pk, increment]
  name varchar(100) [not null]
  description text
  service_types_id int [ref: > service_types.id]
  value decimal(10, 2) [not null]
  department_id int [ref: > departments.id]
  status enum('active', 'inactive') [default: 'active']
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table service_types {
  id int [pk, increment]
  name varchar(50) [not null]
  description text
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table assessment_types {
  id int [pk, increment]
  name varchar(50) [not null]
  description text
  weight_percentage decimal(5, 2) [not null]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}

Table department_budgets {
  id int [pk, increment]
  department_id int [ref: > departments.id]
  fiscal_year int [not null]
  budget_amount decimal(12, 2) [not null]
  created_at timestamp [default: `now()`]
  updated_at timestamp [default: `now()`]
}
```

### 3. **Lucidchart** (Online)
1. Acesse https://www.lucidchart.com
2. Crie uma nova conta ou faça login
3. Selecione "Entity Relationship Diagram"
4. Use as formas padrão para criar as entidades
5. Conecte as entidades com linhas apropriadas

### 4. **Draw.io** (Online/Gratuito)
1. Acesse https://app.diagrams.net
2. Crie um novo diagrama
3. Selecione "Entity Relationship" como template
4. Use as formas de entidade e relacionamento

### 5. **Visual Studio Code + Extensão**
1. Instale a extensão "ERD" ou "Database Client"
2. Abra o projeto SIGEPOLI
3. Use os arquivos SQL para gerar o diagrama

## ELEMENTOS DO DIAGRAMA

### Símbolos Padrão:
- **Retângulo**: Entidade
- **Elipse**: Atributo
- **Losango**: Relacionamento
- **Linha**: Conexão
- **Cardinalidade**: 1, N, M

### Cores Sugeridas:
- **Azul**: Entidades principais (USERS, STAFF, STUDENTS)
- **Verde**: Entidades acadêmicas (COURSES, CLASSES, SUBJECTS)
- **Amarelo**: Entidades financeiras (PAYMENTS, BUDGETS)
- **Laranja**: Entidades de recursos (ROOMS, RESOURCES)
- **Roxo**: Entidades de relacionamento (ENROLLMENTS, SCHEDULES)

## DICAS PARA APRESENTAÇÃO

1. **Organize** as entidades em grupos lógicos
2. **Use** cores diferentes para diferentes tipos de entidade
3. **Mantenha** o diagrama limpo e legível
4. **Inclua** apenas os atributos mais importantes
5. **Destaque** as chaves primárias e estrangeiras
6. **Adicione** legendas explicativas
7. **Use** setas para mostrar a direção dos relacionamentos

## EXEMPLO DE APRESENTAÇÃO

Para a apresentação ao docente, recomendo:

1. **Slide 1**: Visão geral do sistema
2. **Slide 2**: Diagrama completo do DER
3. **Slide 3**: Detalhamento das entidades principais
4. **Slide 4**: Relacionamentos e cardinalidades
5. **Slide 5**: Regras de negócio implementadas
6. **Slide 6**: Views e procedures criadas
7. **Slide 7**: Considerações de implementação

## FERRAMENTAS RECOMENDADAS PARA APRESENTAÇÃO

1. **PowerPoint**: Para slides da apresentação
2. **MySQL Workbench**: Para diagrama técnico
3. **dbdiagram.io**: Para diagrama visual online
4. **Lucidchart**: Para diagrama profissional
5. **Draw.io**: Para diagrama gratuito e funcional 