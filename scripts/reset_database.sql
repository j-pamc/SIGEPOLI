-- ==============================================================
-- SISTEMA DE GESTÃO ESCOLAR POLITÉCNICA (SIGEPOLI)
-- Script de Reset Completo do Banco de Dados
-- ==============================================================

-- ==========================================================================================
-- CONFIGURAÇÃO INICIAL
-- ==========================================================================================

-- Definir modo SQL seguro
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- Selecionar o banco de dados
USE sigepoli;

-- ==========================================================================================
-- REMOÇÃO DE TODAS AS TABELAS (ORDEM INVERSA DE DEPENDÊNCIAS)
-- ==========================================================================================

-- 1. REMOVER TABELAS DE SUPORTE E AUDITORIA
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS library_loans;
DROP TABLE IF EXISTS library_items;
DROP TABLE IF EXISTS audit_logs;

-- 2. REMOVER TABELAS OPERACIONAIS
DROP TABLE IF EXISTS companies_sla_evaluation;
DROP TABLE IF EXISTS companies_sla;
DROP TABLE IF EXISTS companies_contracts;
DROP TABLE IF EXISTS companies_departments;
DROP TABLE IF EXISTS companies;

-- 3. REMOVER TABELAS FINANCEIRAS
DROP TABLE IF EXISTS fines;
DROP TABLE IF EXISTS staff_payments;
DROP TABLE IF EXISTS company_payments;
DROP TABLE IF EXISTS studant_payments;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS payment_types;
DROP TABLE IF EXISTS service_evaluation;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS service_types;

-- 4. REMOVER TABELAS DE ACESSO E AVALIAÇÃO
DROP TABLE IF EXISTS course_access;
DROP TABLE IF EXISTS performance;
DROP TABLE IF EXISTS course_evaluation;
DROP TABLE IF EXISTS staff_evaluation;
DROP TABLE IF EXISTS evaluation;

-- 5. REMOVER TABELAS ADMINISTRATIVAS
DROP TABLE IF EXISTS staff_leaves;
DROP TABLE IF EXISTS staff_positions;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS academic_qualifications;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS department_budgets;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS user_health;
DROP TABLE IF EXISTS user_identification;
DROP TABLE IF EXISTS user_role_assignments;
DROP TABLE IF EXISTS user_roles;

-- 6. REMOVER TABELAS ACADÉMICAS
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS classes_attended;
DROP TABLE IF EXISTS assessment_types;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS teacher_availability;
DROP TABLE IF EXISTS teacher_specializations;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS class_enrollments;
DROP TABLE IF EXISTS student_enrollments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS room_bookings;
DROP TABLE IF EXISTS room_resources;
DROP TABLE IF EXISTS resources;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS class_schedules;
DROP TABLE IF EXISTS time_slots;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS course_availability;
DROP TABLE IF EXISTS course_subjects;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS courses;

-- 7. REMOVER TABELA CENTRAL DE USUÁRIOS
DROP TABLE IF EXISTS users;

-- ==========================================================================================
-- VERIFICAÇÃO DE LIMPEZA
-- ==========================================================================================

-- Verificar se todas as tabelas foram removidas
SELECT 'Verificando se todas as tabelas foram removidas...' as status;

-- Listar tabelas restantes (deve estar vazio)
SHOW TABLES;

-- ==========================================================================================
-- RECRIAÇÃO DO BANCO DE DADOS
-- ==========================================================================================

-- Recriar o banco de dados
DROP DATABASE IF EXISTS sigepoli;
CREATE DATABASE sigepoli
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Selecionar o banco recriado
USE sigepoli;

-- ==========================================================================================
-- EXECUÇÃO DOS SCRIPTS DE CRIAÇÃO
-- ==========================================================================================

-- Executar scripts na ordem correta
SOURCE sql/01_schema/01_create_database.sql;
SOURCE sql/01_schema/02_create_tables.sql;
SOURCE sql/01_schema/03_create_constraints.sql;
SOURCE sql/01_schema/04_create_indexes.sql;
