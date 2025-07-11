# Erro "Unknown column 'u.first_name'" - Problema e Solução

## Descrição do Problema

O erro `ERROR 1054 (42S22): Unknown column 'u.first_name' in 'field list'` ocorria quando o sistema tentava executar views que faziam JOINs incorretos entre as tabelas `teachers`, `staff` e `users`.

## Causa Raiz

O problema estava localizado nas **views** no arquivo `sql/03_views/views.sql`, especificamente nas views `ClassScheduleView` e `TeacherWorkloadView`. O erro ocorria devido a JOINs incorretos na cadeia de relacionamentos:

### Estrutura das Tabelas:
- **`teachers`**: Chave primária `staff_id` (referencia `staff.user_id`)
- **`staff`**: Chave primária `user_id` (referencia `users.id`)
- **`users`**: Chave primária `id` (contém `first_name` e `last_name`)

### JOIN Incorreto (Causava o Erro):
```sql
JOIN teachers t ON cs.teacher_id = t.staff_id
JOIN users u ON t.staff_id = u.id  -- ❌ ERRO: t.staff_id não existe em users
```

### JOIN Correto (Após Correção):
```sql
JOIN teachers t ON cs.teacher_id = t.staff_id
JOIN staff st ON t.staff_id = st.user_id  -- ✅ Correto: t.staff_id = st.user_id
JOIN users u ON st.user_id = u.id         -- ✅ Correto: st.user_id = u.id
```

## Solução Implementada

### 1. Correção na View `ClassScheduleView`

**Arquivo:** `sql/03_views/views.sql`

**Antes:**
```sql
FROM
    class_schedules cs
JOIN
    classes c ON cs.class_id = c.id
JOIN
    subjects s ON cs.subject_id = s.id
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    users u ON t.staff_id = u.id  -- ❌ JOIN incorreto
```

**Depois:**
```sql
FROM
    class_schedules cs
JOIN
    classes c ON cs.class_id = c.id
JOIN
    subjects s ON cs.subject_id = s.id
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    staff st ON t.staff_id = st.user_id  -- ✅ JOIN correto
JOIN
    users u ON st.user_id = u.id         -- ✅ JOIN correto
```

### 2. Correção na View `TeacherWorkloadView`

**Arquivo:** `sql/03_views/views.sql`

**Antes:**
```sql
FROM
    class_schedules cs
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    users u ON t.staff_id = u.id  -- ❌ JOIN incorreto
JOIN
    subjects s ON cs.subject_id = s.id
```

**Depois:**
```sql
FROM
    class_schedules cs
JOIN
    teachers t ON cs.teacher_id = t.staff_id
JOIN
    staff st ON t.staff_id = st.user_id  -- ✅ JOIN correto
JOIN
    users u ON st.user_id = u.id         -- ✅ JOIN correto
JOIN
    subjects s ON cs.subject_id = s.id
```

## Cadeia de Relacionamentos Corrigida

### **Fluxo Correto:**
1. `class_schedules.teacher_id` → `teachers.staff_id`
2. `teachers.staff_id` → `staff.user_id`
3. `staff.user_id` → `users.id`
4. `users.id` → `users.first_name` e `users.last_name`

### **Explicação:**
- Um professor (`teachers`) é um tipo de funcionário (`staff`)
- Um funcionário (`staff`) é um tipo de usuário (`users`)
- Para obter o nome do professor, precisamos seguir toda a cadeia de relacionamentos

## Views Afetadas

### **Views Corrigidas:**
1. **ClassScheduleView** - Grade horária das turmas
2. **TeacherWorkloadView** - Carga horária dos professores

### **Views Não Afetadas:**
1. **DepartmentCostsView** - Custos por departamento
2. **CompanyPaymentCostsView** - Pagamentos a empresas
3. **StudentFeeCostsView** - Custos de propinas (usa JOIN direto students → users)

## Testes Implementados

Foi criado o arquivo `sql/05_tests/test_views_fix.sql` que inclui:

- **Teste 1:** Verificação da estrutura das tabelas
- **Teste 2:** Verificação de dados nas tabelas
- **Teste 3:** Teste das views corrigidas
- **Teste 4:** Verificação de dados específicos
- **Teste 5:** Verificação dos JOINs corrigidos
- **Resumo:** Estatísticas das views funcionando

## Como Executar os Testes

```sql
-- Executar o script de teste
SOURCE sql/05_tests/test_views_fix.sql;
```

## Monitoramento Futuro

Para evitar problemas similares no futuro:

1. **Sempre verificar a cadeia de relacionamentos:** Seguir o fluxo completo de FK → PK
2. **Usar diagramas ER:** Visualizar as relações entre tabelas
3. **Testar JOINs manualmente:** Verificar se os relacionamentos estão corretos
4. **Documentar relacionamentos complexos:** Especialmente quando há múltiplas tabelas intermediárias

## Arquivos Modificados

1. `sql/03_views/views.sql` - Correção das views ClassScheduleView e TeacherWorkloadView
2. `sql/05_tests/test_views_fix.sql` - Script de teste (novo)
3. `sql/05_tests/ERRO_FIRST_NAME_SOLUCAO.md` - Esta documentação (novo)

## Status

✅ **PROBLEMA RESOLVIDO**

O erro `ERROR 1054 (42S22): Unknown column 'u.first_name' in 'field list'` foi completamente corrigido e todas as views agora funcionam corretamente com os JOINs apropriados entre as tabelas `teachers`, `staff` e `users`. 