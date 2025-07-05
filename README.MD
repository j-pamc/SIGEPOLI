# Projeto Final – SIGEPOLI  

## Projeto de Banco de Dados – SIGEPOLI
Sistema Integrado de Gestão Académica, Pessoal e Operacional para um Instituto Superior Politécnico

## 1. Objetivo Geral
Desenhar, modelar e implementar um banco de dados relacional que integre a gestão académica (cursos, turmas, matrículas e avaliações), a gestão de pessoas (professores, coordenadores, administrativos) e a gestão operacional (contratos com empresas de serviços de limpeza, segurança e cafetaria), garantindo rastreabilidade, controlo de custos e relatórios de desempenho.

---

## 2. Contexto do Problema
O Instituto Superior Politécnico de Tecnologias e Ciências, assim como vários outros institutos, opera com várias áreas interligadas:

1. **Académica** – oferecimento de cursos, criação de turmas, matrícula de alunos, atribuição de professores e avaliação de desempenho discente.
2. **Administrativa** – pessoal administrativo distribuído por departamentos (Secretaria Académica, Tesouraria, Recursos Humanos, Biblioteca, Laboratórios, etc.).
3. **Coordenação Pedagógica** – coordenadores de curso responsáveis por currículos, grade horária e indicadores de qualidade.
4. **Operacional** – contratação e fiscalização de empresas terceirizadas (limpeza, segurança, cafetaria) com metas de SLA (Service Level Agreement) e pagamentos mensais.

O sistema atual apresenta dados dispersos, gerando redundância, falhas e dificuldade de apuração de custos.

---

## 3. Requisitos Funcionais
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

## 4. Regras de Negócio Obrigatórias
- **RN01** – Um professor não pode ter aulas em turmas com horários sobrepostos.
- **RN02** – Só é permitida matrícula se houver vaga e propina paga.
- **RN03** – Notas devem estar entre 0–20.
- **RN04** – Empresas precisam apresentar garantia válida antes do pagamento.
- **RN05** – SLA inferior a 90% gera multa automática.
- **RN06** – Coordenador deve aprovar carga horária dos professores do curso.

---

## 5. Entregáveis e Checklist de Implementação

### Modelo Conceitual (ER) – 15 pontos
- [ ] Criar ≥10 entidades
- [ ] Resolver relações N:M com tabelas auxiliares
- [ ] Diagramas legíveis e organizados

### Modelo Lógico (DER) – 3 pontos
- [ ] Usar tipos de dados adequados
- [ ] Definir PKs e FKs
- [ ] Garantir que está em 3ª Forma Normal (3FN)

### Script DDL – 2 pontos
- [ ] Criar tabelas com:
  - [ ] CHECK constraints
  - [ ] UNIQUE em atributos apropriados
  - [ ] INDEX quando necessário
  - [ ] ON UPDATE/DELETE com ações em FKs (CASCADE, SET NULL, etc.)

### Procedures – 2 pontos
- [ ] Procedure: Matricular aluno com validações (RN02)
- [ ] Procedure: Alocar professor à turma, sem conflito de horário (RN01)
- [ ] Procedure: Processar pagamento com cálculo de multa se SLA < 90% (RN05)

### Functions – 3 pontos
- [ ] Calcular média ponderada de um aluno
- [ ] Calcular percentual de SLA mensal
- [ ] (Escolher uma terceira function útil ao sistema)

### Triggers – 5 pontos
- [ ] Trigger: Auditoria de alterações em matrículas
- [ ] Trigger: Auditoria de alterações em pagamentos
- [ ] Trigger: Bloquear pagamento se não houver garantia válida (RN04)
- [ ] (Adicionar outra trigger útil, como registro de horário de inserção)
- [ ] (Mais uma trigger extra para fechar os 5 pontos)

### Views – 2 pontos
- [ ] View: Grade horária por curso
- [ ] View: Carga horária por professor
- [ ] View: Resumo de custos de serviços por mês (bônus/alternativa)

### Consultas de Teste – 1 ponto
- [ ] Criar ≥10 INSERTs realistas
- [ ] Criar ≥15 SELECTs ad-hoc demonstrando as regras de negócio

### Documentação Técnica – 2 pontos
- [ ] Escrever guia de implantação
- [ ] Incluir diagrama físico
- [ ] Justificar uso de índices e constraints

---

## 6. Teste de Compreensão
1. Relatório escrito de 1 página explicando como cada Regra de Negócio será implementada dentro do SGBD.
2. Desenho do DER que será apresentado ao docente no exame.

## 7. Entrega e Demonstração
1. Repositório Git público com tags de versão, verificar os commits em vosso Git e depois no GitHub
2. Apresentação (10 min): execução de procedures, triggers (ex.: tentativa de matrícula sem vaga), views analíticas.
3. Teste ao vivo: docente insere cenário novo e verifica regras.


sigepoli/
├── sql/
│   ├── 01_schema/
│   │   ├── create_database.sql
│   │   ├── create_tables.sql
│   │   ├── create_constraints.sql
│   │   └── create_indexes.sql
│   ├── 02_programmability/
│   │   ├── procedures.sql
│   │   ├── functions.sql
│   │   └── triggers.sql
│   ├── 03_views/
│   │   └── views.sql
│   ├── 04_data/
│   │   ├── insert_master_data.sql
│   │   └── insert_test_data.sql
│   └── 05_tests/
│       ├── test_queries.sql
│       └── validate_rules.sql
├── scripts/
│   ├── deploy_completo.sql        # OPÇÃO 1: referências
│   ├── deploy_monolitico.sql      # OPÇÃO 2: tudo copiado
│   └── reset_database.sql
├── README.md
├── modelo conceitual
├── modelo logico
├── Guia de implantação
├── justificativas de escolha de índices
└── Relatório escrito de 1 página (explicando como cada Regra de Negócio será 
implementada dentro do SGBD)
