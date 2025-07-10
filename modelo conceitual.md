# Modelo Entidade Relacionamento Conceitual (MER) - SIGEPOLI

Este modelo conceitual representa as entidades principais e seus relacionamentos no sistema SIGEPOLI, abstraindo detalhes de implementação para focar na visão de alto nível do negócio.

## Entidades Principais e Seus Atributos Chave:

- **Usuário**: Representa qualquer pessoa que interage com o sistema (alunos, professores, funcionários, etc.).
  - Atributos: Nome, Email, Telefone, Endereço, Data de Nascimento.

- **Identificação do Usuário**: Documentos oficiais do usuário.
  - Atributos: Tipo de Documento, Número, Nacionalidade.

- **Saúde do Usuário**: Informações de saúde e emergência.
  - Atributos: Condições, Medicamentos, Acessibilidade, Contato de Emergência.

- **Papel de Usuário**: Papéis possíveis no sistema (admin, aluno, professor, etc.).
  - Atributos: Nome, Permissões.

- **Atribuição de Papel**: Relaciona usuários a papéis.
  - Atributos: Data de Atribuição, Ativo.

- **Departamento**: Unidade organizacional da instituição.
  - Atributos: Nome, Sigla, Descrição.

- **Orçamento do Departamento**: Orçamento anual de cada departamento.
  - Atributos: Ano Fiscal, Valor, Valor Gasto.

- **Funcionário**: Funcionários administrativos e docentes.
  - Atributos: Número, Data de Contratação, Categoria, Status.

- **Qualificação Acadêmica**: Qualificações dos funcionários.
  - Atributos: Título, Tipo, Instituição, Data de Conclusão.

- **Cargo**: Cargos disponíveis na instituição.
  - Atributos: Nome, Descrição, Salário.

- **Cargo do Funcionário**: Relaciona funcionários a cargos.
  - Atributos: Data de Início, Data de Fim.

- **Férias/Licença**: Períodos de afastamento do funcionário.
  - Atributos: Tipo, Data de Início, Data de Fim.

- **Curso**: Programa de estudo oferecido pela instituição.
  - Atributos: Nome, Descrição, Duração.

- **Disponibilidade do Curso**: Vagas por ano letivo.
  - Atributos: Ano, Limite de Alunos.

- **Disciplina**: Unidade de ensino dentro de um curso.
  - Atributos: Nome, Código, Carga Horária.

- **Disciplina do Curso**: Relação N:M entre curso e disciplina.
  - Atributos: Semestre, Obrigatória, Pré-requisitos.

- **Turma**: Instância específica de uma disciplina em um período.
  - Atributos: Nome, Código, Ano Letivo, Semestre.

- **Horário**: Período de aula.
  - Atributos: Dia da Semana, Turno, Início, Fim.

- **Horário da Turma**: Relaciona turma, disciplina, professor e horários.
  - Atributos: Status, Aprovado por.

- **Sala**: Salas de aula e outros ambientes.
  - Atributos: Nome, Localização, Capacidade, Tipo.

- **Recurso**: Recursos disponíveis (projetor, etc.).
  - Atributos: Nome, Departamento Responsável.

- **Recurso da Sala**: Relação N:M entre sala e recurso.
  - Atributos: Status.

- **Reserva de Sala**: Reservas especiais de salas.
  - Atributos: Data, Início, Fim, Motivo.

- **Aluno**: Discente matriculado em cursos e turmas.
  - Atributos: Número de Matrícula.

- **Matrícula em Curso**: Matrícula do aluno em curso.
  - Atributos: Data, Status.

- **Matrícula em Turma**: Matrícula do aluno em turma.
  - Atributos: Data, Status.

- **Professor**: Docente responsável por ministrar disciplinas.
  - Atributos: Número de Funcionário, Categoria Acadêmica.

- **Especialização do Professor**: Disciplinas que o professor pode ministrar.
  - Atributos: Disciplina, Qualificação.

- **Disponibilidade do Professor**: Horários disponíveis para lecionar.
  - Atributos: Dia, Turno, Horário.

- **Nota**: Registro de avaliação do aluno.
  - Atributos: Valor, Tipo de Avaliação.

- **Tipo de Avaliação**: Prova, trabalho, etc.
  - Atributos: Nome, Peso.

- **Frequência**: Presença do aluno nas aulas.
  - Atributos: Data, Status.

- **Aulas Ministradas**: Registro de aulas dadas.
  - Atributos: Data, Horário.

- **Empresa Terceirizada**: Empresas que prestam serviços à instituição.
  - Atributos: Nome, NIF, Endereço.

- **Empresa-Departamento**: Relação N:M entre empresa e departamento.
  - Atributos: -

- **Contrato**: Acordo formal com empresas terceirizadas.
  - Atributos: Detalhes, Início, Término.

- **Garantia da Empresa**: Garantias apresentadas para contratos.
  - Atributos: Tipo, Validade.

- **SLA (Service Level Agreement)**: Acordo de nível de serviço.
  - Atributos: Nome, Percentual Alvo, Penalidade.

- **Definição de SLA**: Termos e parâmetros do SLA.
  - Atributos: Descrição, Percentual.

- **Avaliação de SLA**: Avaliação mensal do SLA.
  - Atributos: Percentual, Data.

- **Pagamento**: Transação financeira.
  - Atributos: Valor, Data, Método.

- **Tipo de Pagamento**: Categoria do pagamento.
  - Atributos: Nome.

- **Pagamento de Aluno**: Pagamento feito por aluno.
  - Atributos: -

- **Pagamento de Funcionário**: Pagamento feito a funcionário.
  - Atributos: -

- **Pagamento de Empresa**: Pagamento feito a empresa.
  - Atributos: -

- **Multa**: Penalidade aplicada.
  - Atributos: Valor, Motivo.

- **Serviço**: Serviços oferecidos pela instituição.
  - Atributos: Nome, Descrição, Valor.

- **Tipo de Serviço**: Categoria do serviço.
  - Atributos: Nome.

- **Avaliação de Serviço**: Avaliação dos serviços.
  - Atributos: Nota, Comentário.

- **Item de Biblioteca**: Recursos disponíveis na biblioteca.
  - Atributos: Título, ISBN, Código de Barras.

- **Empréstimo**: Registro de empréstimo de item da biblioteca.
  - Atributos: Data de Empréstimo, Data de Devolução Prevista.

- **Acesso ao Curso**: Inscrição do aluno em curso.
  - Atributos: Data, Status.

- **Notificação**: Mensagens do sistema para usuários.
  - Atributos: Título, Mensagem, Data.

- **Log de Auditoria**: Registro de operações críticas.
  - Atributos: Usuário, Tabela, Operação, Data.

- **Avaliação**: Registro de desempenho (alunos, funcionários, serviços).
  - Atributos: Título, Tipo, Data de Início, Data de Término.

- **Avaliação de Funcionário**: Avaliação específica de funcionário.
  - Atributos: Nota, Comentário.

- **Avaliação de Curso**: Avaliação específica de curso.
  - Atributos: Nota, Comentário.

- **Performance**: Resultado de avaliação.
  - Atributos: Nota, Data.


## Relacionamentos Chave:

- **Usuário** `possui` **Papel de Usuário** (1:N)
- **Usuário** `possui` **Identificação do Usuário** (1:1)
- **Usuário** `possui` **Saúde do Usuário** (1:1)
- **Usuário** `possui` **Qualificação Acadêmica** (1:N)
- **Usuário** `possui` **Notificação** (1:N)
- **Usuário** `realiza` **Empréstimo** (1:N)
- **Usuário** `realiza` **Log de Auditoria** (1:N)
- **Usuário** `é` **Funcionário** (1:1)
- **Usuário** `é` **Aluno** (1:1)
- **Usuário** `é` **Professor** (1:1)

- **Funcionário** `possui` **Cargo do Funcionário** (1:N)
- **Funcionário** `tem` **Férias/Licença** (1:N)
- **Funcionário** `pertence a` **Departamento** (N:1)
- **Funcionário** `recebe` **Pagamento de Funcionário** (1:N)
- **Funcionário** `é coordenador de` **Curso** (1:1)
- **Funcionário** `é avaliado em` **Avaliação de Funcionário** (1:N)
- **Funcionário** `possui` **Qualificação Acadêmica** (1:N)

- **Departamento** `possui` **Orçamento do Departamento** (1:N)
- **Departamento** `oferece` **Curso** (1:N)
- **Departamento** `possui` **Serviço** (1:N)
- **Departamento** `possui` **Recurso** (1:N)
- **Departamento** `tem` **Empresa-Departamento** (N:M)

- **Curso** `possui` **Disponibilidade do Curso** (1:N)
- **Curso** `contém` **Disciplina do Curso** (1:N)
- **Curso** `tem` **Turma** (1:N)
- **Curso** `é avaliado em` **Avaliação de Curso** (1:N)

- **Disciplina** `é oferecida em` **Disciplina do Curso** (N:M)
- **Disciplina** `é ministrada em` **Turma** (N:M via Horário da Turma)
- **Disciplina** `é ministrada por` **Professor** (N:M via Especialização do Professor)

- **Turma** `tem` **Horário da Turma** (1:N)
- **Turma** `tem` **Matrícula em Turma** (1:N)
- **Turma** `ocorre em` **Sala** (N:1 via Horário da Turma)
- **Turma** `tem` **Aulas Ministradas** (1:N)
- **Turma** `tem` **Frequência** (1:N)

- **Aluno** `matricula-se em` **Matrícula em Curso** (1:N)
- **Aluno** `matricula-se em` **Matrícula em Turma** (1:N)
- **Aluno** `recebe` **Nota** (1:N)
- **Aluno** `tem` **Frequência** (1:N)
- **Aluno** `realiza` **Pagamento de Propina** (1:N)
- **Aluno** `realiza` **Solicitação de Serviço** (1:N)
- **Propina de Aluno** `gera` **Pagamento de Aluno** (1:1)

- **Professor** `possui` **Especialização do Professor** (1:N)
- **Professor** `possui` **Disponibilidade do Professor** (1:N)
- **Professor** `ministra` **Horário da Turma** (1:N)
- **Horário da Turma** `é confirmado por` **Coordenador do Curso** (N:1)
- **Professor** `é avaliado em` **Avaliação de Funcionário** (1:N)

- **Sala** `possui` **Recurso da Sala** (1:N)
- **Sala** `tem` **Reserva de Sala** (1:N)
- **Recurso** `é alocado em` **Recurso da Sala** (N:M)

- **Empresa Terceirizada** `tem` **Empresa-Departamento** (N:M)
- **Empresa Terceirizada** `tem` **Contrato** (1:N)
- **Empresa Terceirizada** `tem` **SLA** (1:N)
- **Empresa Terceirizada** `recebe` **Pagamento de Empresa** (1:N)
- **Empresa Terceirizada** `pode ter` **Multa** (1:N)
- **Contrato** `tem` **Garantia da Empresa** (1:N)
- **Contrato** `tem` **SLA** (1:N)

- **SLA** `tem` **Definição de SLA** (1:N)
- **SLA** `tem` **Avaliação de SLA** (1:N)

- **Avaliação de SLA** `gera` **Multa** (0:N)
- **Pagamento de Aluno** `é efetuado via` **Pagamento** (N:1)
- **Pagamento de Funcionário** `é efetuado via` **Pagamento** (N:1)
- **Pagamento de Empresa** `é efetuado via` **Pagamento** (N:1)
- **Pagamento** `tem` **Tipo de Pagamento** (N:1)
- **Serviço** `tem` **Tipo de Serviço** (N:1)
- **Serviço** `recebe` **Pagamento** (1:N)
- **Serviço** `é avaliado em` **Avaliação de Serviço** (1:N)

- **Item de Biblioteca** `é emprestado em` **Empréstimo** (1:N)
- **Avaliação** `avalia` **Funcionário/Curso/Serviço** (1:N)
- **Avaliação** `gera` **Performance** (1:N)
- **Acesso ao Curso** `é de` **Aluno** (N:1)

## Fluxos de processos adicionais

### Fluxo de processos de Funcionário Administrativo
1. Registro de dados pessoais em `users`.
2. Vinculação a `staff` com departamento.
3. Atribuição de cargo em `staff_positions`.
4. Submissão de férias/licenças em `staff_leaves`.
5. Recebimento de pagamentos em `staff_payments` via `payments`.
6. Participação em avaliações internas (`staff_evaluation`).

### Fluxo de processos de Chefe de Departamento
1. Atribuição do papel via `user_role_assignments` (role "head_department").
2. Gestão dos dados do departamento em `departments` e orçamento em `department_budgets`.
3. Aprovação de solicitações de recursos (`room_bookings`, `resources`).
4. Aprovação de propostas de contratação de empresas (`companies_contracts`).
5. Aprovação de pagamentos departamentais (`company_payments`).

### Fluxo de processos de Coordenador de Curso
1. Atribuição do papel via `user_role_assignments` (role "coordinator").
2. Definição/atualização de dados do curso em `courses` (campo `coordinator_staff_id`).
3. Aprovação da disponibilidade de professores em `teacher_availability` (RN06).
4. Aprovação de horários de turma em `class_schedules`.
5. Acompanhamento de desempenho de cursos via `course_evaluation`.

### Fluxo de processos de Professor
1. Cadastro em `users` → vínculo em `staff` → vínculo em `teachers`.
2. Definição de especializações em `teacher_specializations`.
3. Submissão de disponibilidade semanal em `teacher_availability`.
4. Lecionar aulas conforme `class_schedules` (presença em `classes_attended`).
5. Lançamento de notas em `grades` e controle de frequência em `attendance`.
6. Participação em avaliações de desempenho (`staff_evaluation`).

### Fluxo de Pagamentos
1. Geração de transação base em `payments`.
2. Classificação pelo tipo (`payment_types`).
3. Associação específica:
   * `student_payments` (propinas e serviços do aluno)
   * `company_payments` (contratos e SLA)
   * `staff_payments` (salários, bônus, etc.)
4. Validação de status (`paid`, `pending`, `failed`).
5. Registro em `audit_logs` para rastreabilidade.

### Fluxo de Serviços
1. Criação do serviço em `services` com `service_types`.
2. Solicitação pelo usuário (`student_payments` ou outra tabela de requisição de serviço).
3. Pagamento via fluxo de pagamentos.
4. Execução e posterior avaliação em `service_evaluation`.

### Fluxo de Companhias Terceirizadas
1. Cadastro em `companies`.
2. Associação a departamentos via `companies_departments`.
3. Criação de contrato em `companies_contracts` com definição de garantia e `companies_sla`.
4. Avaliação periódica em `companies_sla_evaluation` (RN05) — possível geração de `fines`.
5. Processamento de pagamento em `payments` → `company_payments`.


## Fluxo de processos

### Fluxo de processos de administração

1. o funcionario e contratado
2. recebe posicao e roles de permisoes na app
3. faz avalicao de curso
4. faz avaliacao de sla (se for dada a posicao)
5. faz avalicao de funcionario se for chefe de departamento ou coordenador de curso

### Fluxo de processos aluno 

1. O aluno se increve para um curso
2. O aluno faz a prova de acesso e recebe uma nota
3. Se aprovado o aluno se matricula em uma turma
4. O aluno paga a propina
5. O aluno faz as aulas (frequencia)
6. O aluno faz as provas
7. O aluno faz requesicao de servicos
8. O aluno faz requesicao de emprestimo de itens da biblioteca
9. O aluno paga emprestimos e servicos
10. O aluno paga multas
11. O aluno faz avaliacao de funcionarios, cursos e servicos
12. O aluno faz avaliacao de curso
13. O aluno faz avaliacao de funcionario
14. O aluno faz avaliacao de servico

### Fluxo de processos funcionario


### Fluxo de processos chefe de departamento
1. Edita informacoes do departamento
2. 

### Fluxo de processos coordenador de curso
1. Edita informacoes do curso
2. 

### Fluxo de professor

### Fluxo de pagamentos

### Fluxo de servicos

### Fluxo de companias 



