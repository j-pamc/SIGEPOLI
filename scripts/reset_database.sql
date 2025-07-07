-- ==============================================================
-- SISTEMA DE GESTÃO ESCOLAR POLITÉCNICA (SIGEPOLI)
-- Script de Reset Completo do Banco de Dados
-- ==============================================================

-- ==========================================================================================
-- CONFIGURAÇÃO INICIAL
-- ==========================================================================================

DROP DATABASE IF EXISTS sigepoli;
CREATE DATABASE sigepol

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
