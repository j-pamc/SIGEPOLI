-- Funções SQL para o SIGEPOLI

-- ==========================================================================================
-- Função: ValidateGrade
-- Descrição: Valida se uma nota está dentro do intervalo permitido (0 a 20).
-- Parâmetros:
--   grade DECIMAL(5, 2): A nota a ser validada.
-- Retorna:
--   BOOLEAN: TRUE se a nota for válida, FALSE caso contrário.
-- Regra de Negócio Associada: RN03 – Notas devem estar entre 0–20.
-- ==========================================================================================
DELIMITER //
CREATE FUNCTION ValidateGrade(grade DECIMAL(5, 2))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Verifica se a nota está entre 0.00 e 20.00 (inclusive).
    IF grade >= 0.00 AND grade <= 20.00 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //
DELIMITER ;

-- ==========================================================================================
-- Função: CalculateWeightedAverage
-- Descrição: Calcula a média ponderada das notas de um aluno numa disciplina específica.
-- Parâmetros:
--   p_student_id INT: O ID do aluno.
--   p_class_schedules_id INT: O ID do agendamento da turma/disciplina.
-- Retorna:
--   DECIMAL(5, 2): A média ponderada calculada.
-- ==========================================================================================
DELIMITER //
CREATE FUNCTION CalculateWeightedAverage(p_student_id INT, p_class_schedules_id INT)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE weighted_average DECIMAL(5, 2);

    -- Calcula a soma das notas multiplicadas pelos seus pesos e divide pela soma dos pesos.
    SELECT
        SUM(g.score * at.weight) / SUM(at.weight)
    INTO
        weighted_average
    FROM
        grades g
    JOIN
        assessment_types at ON g.assessment_type_id = at.id
    WHERE
        g.student_id = p_student_id AND g.class_schedules_id = p_class_schedules_id;

    RETURN weighted_average;
END //
DELIMITER ;

-- ==========================================================================================
-- Função: CalculateSLAPercentage
-- Descrição: Retorna o percentual de SLA alcançado por uma empresa para um SLA específico
--            em um determinado período de avaliação.
-- Parâmetros:
--   p_company_id INT: O ID da empresa.
--   p_sla_id INT: O ID do SLA.
--   p_evaluation_period DATE: A data do período de avaliação (para extrair mês e ano).
-- Retorna:
--   DECIMAL(5, 2): O percentual de SLA alcançado. Retorna 0.00 se não houver avaliação.
-- Regra de Negócio Associada: RF08 (Requisito Funcional) - Gerar relatórios de carga horária, salas e custos.
-- ==========================================================================================
DELIMITER //
CREATE FUNCTION CalculateSLAPercentage (p_company_id INT, p_sla_id INT, p_evaluation_period DATE)
RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE v_achieved_percentage DECIMAL(5, 2);

    -- Busca o percentual alcançado da avaliação de SLA mais recente para a empresa e SLA especificados,
    -- filtrando pelo mês e ano do período de avaliação.
    SELECT achieved_percentage
    INTO v_achieved_percentage
    FROM companies_sla_evaluation
    WHERE company_id = p_company_id
      AND sla_id = p_sla_id
      AND MONTH(evaluation_period) = MONTH(p_evaluation_period)
      AND YEAR(evaluation_period) = YEAR(p_evaluation_period)
    ORDER BY evaluation_period DESC
    LIMIT 1; -- Pega o último percentual avaliado para o período

    -- Se não houver avaliação para o período, retorna 0.00.
    IF v_achieved_percentage IS NULL THEN
        RETURN 0.00;
    ELSE
        RETURN v_achieved_percentage;
    END IF;
END //
DELIMITER ;


