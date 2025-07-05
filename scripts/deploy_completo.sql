-- DEPLOY COMPLETO SIGEPOLI
-- Este script executa todos os scripts do projecto na ordem recomendada.
 
-- 1. Estrutura do banco
SOURCE sql/01_schema/01_create_database.sql;
SOURCE sql/01_schema/02_create_tables.sql;
SOURCE sql/01_schema/03_create_constraints.sql;
SOURCE sql/01_schema/04_create_indexes.sql;

-- 2. Programabilidade
SOURCE sql/02_programmability/functions.sql;
SOURCE sql/02_programmability/procedures.sql;
SOURCE sql/02_programmability/triggers.sql;

-- 3. Views
SOURCE sql/03_views/views.sql;

-- 4. Dados
-- (Adicione aqui o insert_master_data.sql se existir)
SOURCE sql/04_data/insert_test_data.sql;

-- 5. Testes
SOURCE sql/05_tests/test_queries.sql;
SOURCE sql/05_tests/validate_rules.sql;
