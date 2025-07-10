-- ==============================================================
-- FUNCTIONS
-- ==============================================================

DELIMITER //

-- Function para calcular a Média Ponderada das Notas de um Aluno em uma Disciplina (RF07)
CREATE FUNCTION CalculateWeightedAverage (p_student_id INT, p_class_schedules_id INT)
RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE v_weighted_sum DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_total_weight DECIMAL(10, 2) DEFAULT 0.00;

    SELECT
        SUM(g.score * at.weight),
        SUM(at.weight)
    INTO
        v_weighted_sum,
        v_total_weight
    FROM
        grades g
    JOIN
        assessment_types at ON g.assessment_type_id = at.id
    WHERE
        g.student_id = p_student_id AND g.class_schedules_id = p_class_schedules_id;

    IF v_total_weight > 0 THEN
        RETURN v_weighted_sum / v_total_weight;
    ELSE
        RETURN 0.00; -- Retorna 0 se não houver notas ou pesos
    END IF;
END //

DELIMITER ;




DELIMITER //

-- Function para calcular o Percentual de SLA (RF08)
-- Retorna o percentual alcançado de um SLA específico para uma empresa.
CREATE FUNCTION CalculateSLAPercentage (p_company_id INT, p_sla_id INT)
RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE v_achieved_percentage DECIMAL(5, 2);

    SELECT achieved_percentage
    INTO v_achieved_percentage
    FROM companies_sla_evaluation
    WHERE company_id = p_company_id AND sla_id = p_sla_id
    ORDER BY evaluation_period DESC
    LIMIT 1; -- Pega o último percentual avaliado

    IF v_achieved_percentage IS NULL THEN
        RETURN 0.00; -- Retorna 0 se não houver avaliação
    ELSE
        RETURN v_achieved_percentage;
    END IF;
END //

DELIMITER ;
