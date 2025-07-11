# Guia de Implantação – SIGEPOLI

## 1. Pré-requisitos
- SGBD compatível: **MySQL**
- Ferramenta de administração (recomendada): **Workbench 8.0**
- Scripts do projecto organizados conforme a estrutura:

```
sigepoli/
├── sql/
│   ├── 01_schema/ # 
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
├── modelo conceitual
├── modelo lógico
├── Guia de implantação
├── justificativas de escolha de índices
└── Relatório escrito de 1 página
```

## 2. Execução dos Scripts

### Opção 1: Execução automática (recomendada)
Utilize os scripts prontos na pasta `scripts/`:
- `scripts/deploy_completo.sql`: executa todos os scripts de referência na ordem correcta.
- `scripts/deploy_monolitico.sql`: executa tudo num único script monolítico.
- `scripts/reset_database.sql`: reinicia a base de dados do zero.

### Opção 2: Execução manual (avançado)
Execute manualmente os scripts da pasta `sql/` seguindo a ordem numérica das subpastas:
1. `sql/01_schema/` (estrutura da base de dados)
2. `sql/02_programmability/` (procedures, functions, triggers)
3. `sql/03_views/` (views)
4. `sql/04_data/` (dados de teste)
5. `sql/05_tests/` (consultas e validações)

## 3. Execução no MySQL Workbench

### Método 1: Executar script completo
1. Abra o MySQL Workbench
2. Conecte-se à instância MySQL
3. Vá em **File** → **Open SQL Script**
4. Seleccione o ficheiro `scripts/deploy_completo.sql` (pode nao reconhecer comando source) ou `scripts/deploy_monolitico.sql`
5. Clique no ícone de **raio** (Execute) ou pressione **Ctrl+Shift+Enter**
6. Aguarde a conclusão da execução

### Método 2: Executar scripts individuais
1. Abra cada script da pasta `sql/` seguindo a ordem numérica
2. Para cada script:
   - **File** → **Open SQL Script**
   - Seleccione o ficheiro desejado
   - Execute com **Ctrl+Shift+Enter**
   - Verifique se não há erros na aba **Action Output**

### Método 3: Executar comandos linha por linha
1. Abra o script no Workbench
2. Seleccione o comando específico que deseja executar
3. Execute com **Ctrl+Enter** (executa apenas o comando seleccionado)
4. Use este método para depuração ou execução controlada

**Dicas importantes:**
- Verifique sempre a aba **Action Output** para erros
- Utilize **Refresh** no painel **Schemas** para visualizar alterações
- Mantenha uma cópia de segurança antes de executar scripts de reset

## 4. Execução no Terminal/Linha de Comandos

*Antes de quallquer metodo executar:*
```bash
# Navegar para a pasta do projecto
cd /caminho/para/sigepoli

# Executar mysql e por password e dar enter
mysql -u root -p -h localhost
```

### Método 1: Executar script completo
```bash
# Navegar para a pasta do projecto
cd /caminho/para/sigepoli

# Executar mysql e por password e dar enter
mysql -u root -p -h localhost

# Executar script completo
SOURCE scripts/deploy_completo.sql

# Ou script monolítico
SOURCE scripts/deploy_monolitico.sql 

# Ou script monolítico
SOURCE scripts/reset_database.sql 
```

### Método 2: Executar scripts individuais
```bash
# Executar na ordem correcta
SOURCE sql/01_schema/create_database.sql
SOURCE sql/01_schema/create_tables.sql
SOURCE sql/01_schema/create_constraints.sql
SOURCE sql/01_schema/create_indexes.sql
SOURCE sql/02_programmability/procedures.sql
SOURCE sql/02_programmability/functions.sql
SOURCE sql/02_programmability/triggers.sql
SOURCE sql/03_views/views.sql
SOURCE sql/04_data/insert_test_data.sql
```

**Parâmetros importantes:**
- `-u root`: nome do utilizador MySQL
- `-p`: solicita senha (será pedida interactivamente)
- `-h localhost`: endereço do servidor (altere conforme necessário)
- `-D sigepoli`: especifica a base de dados a usar
- `2>&1`: redireciona erros e saída para o ficheiro de log

## 4. Testes e Validação
- Execute os scripts de teste em `sql/05_tests/` para validar as regras de negócio e funcionamento da base de dados.