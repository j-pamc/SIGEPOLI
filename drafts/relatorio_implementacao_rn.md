# Relatório de Implementação de Regras de Negócio - SIGEPOLI

Este relatório detalha a implementação das regras de negócio obrigatórias do sistema SIGEPOLI, conforme especificado no documento de requisitos e no schema atualizado do banco de dados. Cada regra é abordada individualmente, descrevendo como foi incorporada na lógica do banco de dados através de funções, triggers ou procedures SQL.

---

## Regras de Negócio Obrigatórias e Sua Implementação

### RN01 – Um professor não pode ter aulas em turmas com horários sobrepostos.

Para garantir que um professor não tenha aulas em turmas com horários sobrepostos, foram implementados dois `TRIGGERS` no banco de dados: `trg_check_teacher_schedule_overlap_insert` (para inserções) e `trg_check_teacher_schedule_overlap_update` (para atualizações) na tabela `class_schedules`. Estes triggers verificam se o professor já possui outro agendamento que se sobreponha no mesmo dia e horário, comparando os `time_slot_ids` do novo agendamento com os existentes; se for detectada uma sobreposição, a operação é impedida com uma mensagem de erro, garantindo a integridade dos horários dos professores e evitando conflitos de agenda.

### RN02 – Só é permitida matrícula se houver vaga e propina paga.

A regra de negócio que condiciona a matrícula à existência de vagas e ao pagamento da propina foi implementada através do `TRIGGER` `trg_check_enrollment_conditions` na tabela `student_enrollments`, acionado `BEFORE INSERT` em cada nova tentativa de matrícula; ele verifica a disponibilidade de vagas no curso e o pagamento da propina correspondente ao curso e ao mês da matrícula, abortando a operação e retornando uma mensagem de erro caso qualquer uma das condições não seja satisfeita, assegurando que as matrículas só sejam efetivadas sob as condições financeiras e de capacidade estabelecidas.

### RN03 – Notas devem estar entre 0–20.

A validação das notas para que estejam no intervalo de 0 a 20 foi implementada através da `FUNCTION` `ValidateGrade(grade DECIMAL(5, 2))`, que retorna `TRUE` se a nota estiver dentro do intervalo permitido e `FALSE` caso contrário; esta função centraliza a lógica de validação de notas no banco de dados, garantindo a consistência dos dados em todo o sistema e prevenindo a inserção de valores inválidos, mesmo que a validação também seja realizada na camada de aplicação.

### RN04 – Empresas precisam apresentar garantia válida antes do pagamento.

Esta regra de negócio não foi diretamente implementada com um componente SQL específico devido à ausência de uma tabela de garantias no schema fornecido; a lógica para esta regra seria idealmente implementada em uma `PROCEDURE` de processamento de pagamentos ou em um `TRIGGER` `BEFORE INSERT` na tabela `company_payments`, envolvendo uma consulta a uma hipotética tabela `company_guarantees` para verificar a existência e validade de uma garantia associada à empresa antes de permitir o registro do pagamento, sendo, por enquanto, delegada à camada de aplicação.

### RN05 – SLA inferior a 90% gera multa automática.

A regra de negócio que estabelece uma multa automática para SLAs inferiores a 90% foi implementada através do `TRIGGER` `trg_apply_sla_fine` na tabela `companies_sla_evaluation`, acionado `AFTER INSERT` em cada nova avaliação de SLA; ele verifica se a `achieved_percentage` é menor que 90.00%, calcula o valor da multa com base na `penalty_percentage` e em um valor de contrato da empresa (placeholder), insere um registro na tabela `fines`, e atualiza o registro na `companies_sla_evaluation` para indicar a multa aplicada, garantindo a aplicação consistente e imediata das penalidades.

A `FUNCTION` `CalculateSLAPercentage(p_company_id INT, p_sla_id INT, P_evaluation_period DATE)` foi atualizada para retornar o percentual de SLA alcançado por uma empresa para um SLA específico, buscando o último percentual avaliado na tabela `companies_sla_evaluation` para o mês e ano da `P_evaluation_period`; esta função pode ser utilizada para consultas e relatórios que necessitem do valor atual do SLA de uma empresa.

### RN06 – Coordenador deve aprovar carga horária dos professores do curso.

A aprovação da carga horária dos professores pelo coordenador do curso é uma regra de negócio refletida na tabela `class_schedules` através dos campos `approved_by` e `status`; embora não haja um `TRIGGER` ou `PROCEDURE` específico para a *aprovação* em si (que é um processo de negócio da aplicação), a estrutura do banco de dados suporta essa regra, e a aplicação garantiria que apenas usuários com o papel de coordenador de curso pudessem executar a ação de aprovação, atualizando o `status` e o `approved_by` de `class_schedules`, com a `VIEW` `TeacherWorkloadView` auxiliando no monitoramento da carga horária.



