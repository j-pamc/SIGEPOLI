-- ==============================================================
-- TESTE: Verificação da Correção do Erro "Unknown column 'u.first_name'"
-- ==============================================================

-- Este script testa se o problema das views foi resolvido após a correção dos JOINs

-- ==========================================================================================
-- TESTE 1: Verificar se as tabelas existem e têm a estrutura correta
-- ==========================================================================================

SELECT 'Verificando estrutura das tabelas...' AS status;

-- Verificar se a tabela users existe e tem as colunas necessárias
DESCRIBE users;

-- Verificar se a tabela teachers existe
DESCRIBE teachers;

-- Verificar se a tabela staff existe
DESCRIBE staff;

-- ==========================================================================================
-- TESTE 2: Verificar se há dados nas tabelas
-- ==========================================================================================

SELECT 'Verificando dados nas tabelas...' AS status;

-- Contar usuários
SELECT COUNT(*) AS total_users FROM users;

-- Contar professores
SELECT COUNT(*) AS total_teachers FROM teachers;

-- Contar funcionários
SELECT COUNT(*) AS total_staff FROM staff;

-- ==========================================================================================
-- TESTE 3: Testar as views corrigidas
-- ==========================================================================================

SELECT 'Testando views corrigidas...' AS status;

-- Testar ClassScheduleView
SELECT 'Testando ClassScheduleView...' AS view_test;
SELECT COUNT(*) AS total_records FROM ClassScheduleView;

-- Testar TeacherWorkloadView
SELECT 'Testando TeacherWorkloadView...' AS view_test;
SELECT COUNT(*) AS total_records FROM TeacherWorkloadView;

-- Testar StudentFeeCostsView
SELECT 'Testando StudentFeeCostsView...' AS view_test;
SELECT COUNT(*) AS total_records FROM StudentFeeCostsView;

-- Testar DepartmentCostsView
SELECT 'Testando DepartmentCostsView...' AS view_test;
SELECT COUNT(*) AS total_records FROM DepartmentCostsView;

-- Testar CompanyPaymentCostsView
SELECT 'Testando CompanyPaymentCostsView...' AS view_test;
SELECT COUNT(*) AS total_records FROM CompanyPaymentCostsView;

-- ==========================================================================================
-- TESTE 4: Verificar dados específicos nas views
-- ==========================================================================================

SELECT 'Verificando dados específicos...' AS status;

-- Verificar se há professores na ClassScheduleView
SELECT 
    teacher_name,
    class_name,
    subject_name
FROM ClassScheduleView 
LIMIT 5;

-- Verificar se há carga horária na TeacherWorkloadView
SELECT 
    teacher_name,
    subject_name,
    total_workload_hours
FROM TeacherWorkloadView 
LIMIT 5;

-- Verificar se há propinas na StudentFeeCostsView
SELECT 
    student_name,
    fee_amount,
    payment_status
FROM StudentFeeCostsView 
LIMIT 5;

-- ==========================================================================================
-- TESTE 5: Verificar se os JOINs estão funcionando corretamente
-- ==========================================================================================

SELECT 'Verificando JOINs...' AS status;

-- Testar o JOIN manual para professores
SELECT 
    t.staff_id,
    u.first_name,
    u.last_name,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name
FROM teachers t
JOIN staff s ON t.staff_id = s.user_id
JOIN users u ON s.user_id = u.id
LIMIT 5;

-- ==========================================================================================
-- RESUMO DOS TESTES
-- ==========================================================================================

SELECT '=== RESUMO DOS TESTES ===' AS summary;

-- Verificar se todas as views estão funcionando
SELECT 
    'ClassScheduleView' AS view_name,
    (SELECT COUNT(*) FROM ClassScheduleView) AS record_count
UNION ALL
SELECT 
    'TeacherWorkloadView' AS view_name,
    (SELECT COUNT(*) FROM TeacherWorkloadView) AS record_count
UNION ALL
SELECT 
    'StudentFeeCostsView' AS view_name,
    (SELECT COUNT(*) FROM StudentFeeCostsView) AS record_count
UNION ALL
SELECT 
    'DepartmentCostsView' AS view_name,
    (SELECT COUNT(*) FROM DepartmentCostsView) AS record_count
UNION ALL
SELECT 
    'CompanyPaymentCostsView' AS view_name,
    (SELECT COUNT(*) FROM CompanyPaymentCostsView) AS record_count;

SELECT 'Testes concluídos com sucesso!' AS final_status; 