# Modelo Entidade Relacionamento Lógico (DER) - SIGEPOLI

Este modelo lógico representa a estrutura do banco de dados SIGEPOLI, detalhando as tabelas, colunas, tipos de dados, chaves primárias (PKs), chaves estrangeiras (FKs) e relacionamentos, conforme implementado nos scripts SQL fornecidos.

## Convenções:

*   `PK`: Chave Primária
*   `FK`: Chave Estrangeira
*   `UQ`: Chave Única
*   `NN`: Não Nulo
*   `DEFAULT`: Valor Padrão

## Tabelas e Seus Atributos:

### 1. `users`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `first_name` (VARCHAR(50), NN)
*   `last_name` (VARCHAR(50), NN)
*   `email` (VARCHAR(100), NN, UQ)
*   `password` (VARCHAR(255), NN)
*   `phone` (VARCHAR(20))
*   `address` (TEXT)
*   `date_of_birth` (DATE)
*   `status` (ENUM, NN, DEFAULT 'active')
*   `gender` (ENUM, DEFAULT NULL)
*   `profile_picture` (TEXT)
*   `is_verified` (BOOLEAN, DEFAULT FALSE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 2. `user_roles`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `code` (VARCHAR(20), NN, UQ)
*   `name` (VARCHAR(50), NN)
*   `description` (TEXT)
*   `permissions` (JSON)
*   `hierarchy_level` (INT, DEFAULT 0)
*   `is_active` (BOOLEAN, DEFAULT TRUE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 3. `user_role_assignments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `user_id` (INT, NN, FK to `users.id`)
*   `role_id` (INT, NN, FK to `user_roles.id`)
*   `assigned_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `assigned_by` (INT, FK to `users.id`)
*   `is_active` (BOOLEAN, DEFAULT TRUE)
*   `expires_at` (TIMESTAMP)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

### 4. `user_identification`
*   `user_id` (INT, PK, FK to `users.id`)
*   `document_type` (ENUM, NN)
*   `document_number` (VARCHAR(20), NN, UQ)
*   `issue_date` (DATE)
*   `expiration_date` (DATE)
*   `nationality` (VARCHAR(50))
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 5. `user_health`
*   `user_id` (INT, PK, FK to `users.id`)
*   `conditions` (TEXT)
*   `medications` (TEXT)
*   `allergies` (TEXT)
*   `need_assessibility` (BOOLEAN, DEFAULT FALSE)
*   `emergency_contact_name` (VARCHAR(100))
*   `emergency_contact_relationship` (ENUM, NN)
*   `emergency_contact_phone` (VARCHAR(20))
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 6. `departments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(100), NN, UQ)
*   `acronym` (VARCHAR(10), NN, UQ)
*   `description` (TEXT)
*   `head_staff_id` (INT, FK to `staff.user_id`)
*   `status` (ENUM, NN, DEFAULT 'active')
*   `classification` (ENUM, NN, DEFAULT 'academic')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 7. `department_budgets`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `department_id` (INT, NN, FK to `departments.id`)
*   `fiscal_year` (INT, NN)
*   `budget_amount` (DECIMAL(15, 2), NN)
*   `spent_amount` (DECIMAL(15, 2), DEFAULT 0.00)
*   `remaining_amount` (DECIMAL(15, 2), DEFAULT 0.00)
*   `on_account` (BOOLEAN, DEFAULT FALSE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 8. `staff`
*   `user_id` (INT, PK, FK to `users.id`)
*   `staff_number` (VARCHAR(50), NN, UQ)
*   `hire_date` (DATE, NN, DEFAULT CURRENT_DATE())
*   `employment_type` (ENUM, DEFAULT 'full_time')
*   `employment_status` (ENUM, DEFAULT 'active')
*   `department_id` (INT, FK to `departments.id`)
*   `staff_category` (ENUM, NN)
*   `office_location` (VARCHAR(100))
*   `status` (ENUM, NN, DEFAULT 'active')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 9. `academic_qualifications`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `user_id` (INT, NN, FK to `users.id`)
*   `title` (VARCHAR(100), NN)
*   `field_of_study` (VARCHAR(100))
*   `qualification_type` (ENUM, NN, DEFAULT 'other')
*   `institution` (VARCHAR(100), NN)
*   `completion_date` (DATE)
*   `document_url` (TEXT)
*   `is_verified` (BOOLEAN, DEFAULT FALSE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 10. `positions`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(100), NN, UQ)
*   `description` (TEXT)
*   `amount` (DECIMAL(10, 2), NN, DEFAULT 0.00)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 11. `staff_positions`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `user_id` (INT, NN, FK to `staff.user_id`)
*   `position_id` (INT, NN, FK to `positions.id`)
*   `description` (TEXT)
*   `start_date` (DATE, NN, DEFAULT CURRENT_DATE())
*   `end_date` (DATE)
*   `status` (ENUM, NN, DEFAULT 'active')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 12. `staff_leaves`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `staff_id` (INT, NN, FK to `staff.user_id`)
*   `leave_type` (ENUM, NN)
*   `reason` (TEXT)
*   `required_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `start_date` (DATE, NN)
*   `end_date` (DATE, NN)
*   `status` (ENUM, NN, DEFAULT 'pending')
*   `replacement_staff_id` (INT, FK to `staff.user_id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 13. `evaluation`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `iniciator_staff_id` (INT, NN, FK to `staff.user_id`)
*   `title` (VARCHAR(100), NN)
*   `description` (TEXT)
*   `type_of_evaluated` (ENUM, NN)
*   `type_of_evaluator` (ENUM, NN)
*   `evaluation_type` (ENUM, NN)
*   `criteria` (JSON)
*   `evaluation_date_start` (DATE, NN)
*   `evaluation_date_end` (DATE, NN)
*   `status_evaluation` (ENUM, DEFAULT 'started')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 14. `staff_evaluation`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `evaluation_id` (INT, NN, FK to `evaluation.id`)
*   `staff_id` (INT, NN, FK to `staff.user_id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 15. `course_evaluation`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `evaluation_id` (INT, NN, FK to `evaluation.id`)
*   `course_id` (INT, NN, FK to `courses.id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 16. `performance`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `evaluation_id` (INT, NN, FK to `evaluation.id`)
*   `evaluator_id` (INT, NN, FK to `users.id`)
*   `evaluation_date` (DATE, NN)
*   `criteria_scores` (JSON)
*   `feedback` (TEXT)
*   `status` (ENUM, DEFAULT 'draft')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 17. `course_access`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `user_id` (INT, NN, FK to `users.id`)
*   `course_availability_id` (INT, NN, FK to `course_availability.id`)
*   `exam_score` (DECIMAL(5, 2))
*   `status` (ENUM, NN, DEFAULT 'pending')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 18. `services`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(100), NN, UQ)
*   `description` (TEXT)
*   `service_types_id` (INT, NN, FK to `service_types.id`)
*   `value` (DECIMAL(10, 2), NN)
*   `departament_id` (INT, NN, FK to `departments.id`)
*   `status` (ENUM, NN, DEFAULT 'active')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 19. `service_types`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(50), NN, UQ)
*   `description` (TEXT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 20. `service_evaluation`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `evaluation_id` (INT, NN, FK to `evaluation.id`)
*   `service_id` (INT, NN, FK to `services.id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 21. `payments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `amount` (DECIMAL(10, 2), NN)
*   `payment_date` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `payment_method_id` (INT, NN, FK to `payment_types.id`)
*   `reference_number` (VARCHAR(50), UQ)
*   `status` (ENUM, NN, DEFAULT 'pending')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 22. `studant_payments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `payment_id` (INT, NN, FK to `payments.id`)
*   `service_id` (INT, NN, FK to `services.id`)
*   `student_id` (INT, NN, FK to `students.user_id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 23. `company_payments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `payment_id` (INT, NN, FK to `payments.id`)
*   `company_id` (INT, NN, FK to `companies.id`)
*   `department_budgets_id` (INT, NN, FK to `department_budgets.id`)
*   `approved_by_staff` (INT, NN, FK to `users.id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 24. `staff_payments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `type_of_payment` (ENUM, NN)
*   `payment_id` (INT, NN, FK to `payments.id`)
*   `staff_id` (INT, NN, FK to `users.id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 25. `payment_types`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(50), NN, UQ)
*   `description` (TEXT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 26. `fines`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `payment_id` (INT, NN, FK to `payments.id`)
*   `fined` (ENUM, NN)
*   `amount` (DECIMAL(10, 2), NN)
*   `reason` (VARCHAR(255), NN)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 27. `companies`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(255), NN)
*   `nif` (VARCHAR(20), NN, UQ)
*   `address` (VARCHAR(255), NN)
*   `phone` (VARCHAR(20))
*   `email` (VARCHAR(100))
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 28. `companies_departments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `company_id` (INT, NN, FK to `companies.id`)
*   `department_id` (INT, NN, FK to `departments.id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 29. `companies_contracts`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `company_id` (INT, NN, FK to `companies.id`)
*   `contract_details` (TEXT, NN)
*   `started_at` (DATE, NN)
*   `ended_at` (DATE)
*   `status` (ENUM, NN, DEFAULT 'active')
*   `signed_by_staff` (INT, NN, FK to `users.id`)
*   `signed_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 30. `companies_sla`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `company_id` (INT, NN, FK to `companies.id`)
*   `sla_name` (VARCHAR(100), NN)
*   `description` (TEXT)
*   `sla_type` (ENUM, NN)
*   `target_percentage` (DECIMAL(5, 2), NN, DEFAULT 90.00)
*   `penalty_percentage` (DECIMAL(5, 2), DEFAULT 10.00)
*   `sla_details` (TEXT, NN)
*   `is_active` (BOOLEAN, DEFAULT TRUE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 31. `companies_sla_evaluation`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `company_id` (INT, NN, FK to `companies.id`)
*   `sla_id` (INT, NN, FK to `companies_sla.id`)
*   `evaluation_period` (DATE, NN)
*   `achieved_percentage` (DECIMAL(5, 2), NN)
*   `penalty_applied` (BOOLEAN, DEFAULT FALSE)
*   `penalty_amount` (DECIMAL(10, 2), DEFAULT 0.00)
*   `evaluator_id` (INT, NN, FK to `users.id`)
*   `feedback` (TEXT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 32. `audit_logs`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `user_id` (INT, NN, FK to `users.id`)
*   `table_name` (VARCHAR(50), NN)
*   `operation_type` (ENUM, NN)
*   `record_id` (INT)
*   `old_values` (JSON)
*   `new_values` (JSON)
*   `ip_address` (VARCHAR(45))
*   `user_agent` (TEXT)
*   `session_id` (VARCHAR(128))
*   `description` (TEXT)
*   `severity` (ENUM, NN, DEFAULT 'LOW')
*   `status` (ENUM, NN, DEFAULT 'SUCCESS')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)
*   `execution_time_ms` (INT, DEFAULT 0)

### 33. `library_items`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `title` (VARCHAR(255), NN)
*   `isbn` (VARCHAR(20))
*   `barcode` (VARCHAR(50), UQ)
*   `item_type` (ENUM, NN)
*   `format` (ENUM, NN, DEFAULT 'physical')
*   `language` (VARCHAR(10), DEFAULT 'pt')
*   `author` (VARCHAR(255))
*   `publisher` (VARCHAR(255))
*   `publication_year` (YEAR)
*   `subject_area` (VARCHAR(100))
*   `location` (VARCHAR(100))
*   `acquisition_date` (DATE)
*   `acquisition_cost` (DECIMAL(10, 2))
*   `condition_status` (ENUM, DEFAULT 'excellent')
*   `availability_status` (ENUM, DEFAULT 'available')
*   `max_loan_days` (INT, DEFAULT 15)
*   `renewal_limit` (INT, DEFAULT 2)
*   `description` (TEXT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 34. `library_loans`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `library_item_id` (INT, NN, FK to `library_items.id`)
*   `borrower_id` (INT, NN, FK to `users.id`)
*   `loan_date` (TIMESTAMP, NN, DEFAULT CURRENT_TIMESTAMP)
*   `due_date` (TIMESTAMP, NN)
*   `return_date` (TIMESTAMP)
*   `renewal_count` (INT, DEFAULT 0)
*   `status` (ENUM, NN, DEFAULT 'active')
*   `late_fee_amount` (DECIMAL(8, 2), DEFAULT 0.00)
*   `damage_fee_amount` (DECIMAL(8, 2), DEFAULT 0.00)
*   `notes` (TEXT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 35. `notifications`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `user_id` (INT, NN, FK to `users.id`)
*   `title` (VARCHAR(255), NN)
*   `message` (TEXT, NN)
*   `notification_type` (ENUM, NN, DEFAULT 'general')
*   `status` (ENUM, NN, DEFAULT 'unread')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 36. `courses`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(100), NN, UQ)
*   `description` (TEXT)
*   `duration_semesters` (INT, NN)
*   `department_id` (INT, NN, FK to `departments.id`)
*   `coordinator_staff_id` (INT, NN, FK to `staff.user_id`)
*   `level` (ENUM, NN, DEFAULT 'graduate')
*   `status` (ENUM, NN, DEFAULT 'active')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 37. `subjects`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(100), NN)
*   `code` (VARCHAR(20), NN, UQ)
*   `description` (TEXT)
*   `workload_hours` (INT, NN)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 38. `course_subjects`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `subject_id` (INT, NN, FK to `subjects.id`)
*   `course_id` (INT, NN, FK to `courses.id`)
*   `semester` (INT, NN)
*   `prerequisites` (JSON)
*   `syllabus` (TEXT)
*   `is_mandatory` (BOOLEAN, NN, DEFAULT TRUE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 39. `course_availability`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `course_id` (INT, NN, FK to `courses.id`)
*   `academic_year` (INT, NN)
*   `student_limit` (INT, NN)
*   `prerequisites` (JSON)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 40. `classes`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(20), NN)
*   `code` (VARCHAR(10), NN, UQ)
*   `course_id` (INT, NN, FK to `courses.id`)
*   `academic_year` (INT, NN)
*   `semester` (INT, NN)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 41. `time_slots`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `day_of_week` (ENUM, NN)
*   `shift` (ENUM, NN)
*   `start_time` (TIME, NN)
*   `end_time` (TIME, NN)
*   `hours` (INT, NN)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 42. `class_schedules`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `class_id` (INT, NN, FK to `classes.id`)
*   `subject_id` (INT, NN, FK to `subjects.id`)
*   `teacher_id` (INT, NN, FK to `teachers.user_id`)
*   `time_slot_ids` (JSON, NN)
*   `room_id` (INT, FK to `rooms.id`)
*   `status` (ENUM, NN, DEFAULT 'draft')
*   `approved_by` (INT, FK to `staff.user_id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 43. `rooms`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(50), NN, UQ)
*   `description` (TEXT)
*   `localization` (TEXT, UQ)
*   `capacity` (INT, NN)
*   `type_of_room` (ENUM, NN, DEFAULT 'classroom')
*   `acessibility` (BOOLEAN, DEFAULT FALSE)
*   `is_available` (BOOLEAN, DEFAULT FALSE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 44. `resources`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `name` (VARCHAR(50), NN, UQ)
*   `description` (TEXT)
*   `responsible_department_id` (INT, NN, FK to `departments.id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 45. `room_resources`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `room_id` (INT, NN, FK to `rooms.id`)
*   `resource_id` (INT, NN, FK to `resources.id`)
*   `status_resources` (ENUM, NN, DEFAULT 'available')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 46. `room_bookings`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `room_id` (INT, NN, FK to `rooms.id`)
*   `department_id` (INT, NN, FK to `departments.id`)
*   `reason` (TEXT, NN)
*   `date` (DATE, NN)
*   `start_time` (TIME, NN)
*   `end_time` (TIME, NN)
*   `purpose` (TEXT)
*   `status` (ENUM, NN, DEFAULT 'pending')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 47. `students`
*   `user_id` (INT, PK, FK to `users.id`)
*   `student_number` (VARCHAR(50), NN, UQ)
*   `studying` (BOOLEAN, DEFAULT TRUE)
*   `searching` (BOOLEAN, DEFAULT TRUE)
*   `recommendation` (TEXT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 48. `student_enrollments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `student_id` (INT, NN, FK to `students.user_id`)
*   `course_id` (INT, NN, FK to `courses.id`)
*   `enrollment_date` (DATE, NN, DEFAULT CURRENT_DATE())
*   `status` (ENUM, NN, DEFAULT 'active')
*   `conclusion_date` (DATE, NN, DEFAULT CURRENT_DATE())
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 49. `class_enrollments`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `student_id` (INT, NN, FK to `students.user_id`)
*   `class_schedules_id` (INT, NN, FK to `class_schedules.id`)
*   `enrollment_date` (DATE, NN, DEFAULT CURRENT_DATE())
*   `type_of_enrollment` (ENUM, NN, DEFAULT 'regular')
*   `status` (ENUM, NN, DEFAULT 'active')
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 50. `teachers`
*   `staff_id` (INT, PK, FK to `staff.user_id`)
*   `academic_rank` (ENUM, DEFAULT 'instructor')
*   `tenure_status` (ENUM, DEFAULT 'adjunct')
*   `is_thesis_advisor` (BOOLEAN, DEFAULT FALSE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 51. `teacher_specializations`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `teacher_id` (INT, NN, FK to `teachers.user_id`)
*   `qualification_id` (INT, FK to `academic_qualifications.id`)
*   `subject_area` (VARCHAR(100), NN)
*   `subject_id` (INT, NN, FK to `subjects.id`)
*   `proficiency_level` (ENUM, DEFAULT 'intermediate')
*   `is_approved` (BOOLEAN, DEFAULT FALSE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 52. `teacher_availability`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `teacher_id` (INT, NN, FK to `teachers.user_id`)
*   `time_slot_ids` (JSON, NN)
*   `total_hours` (INT, NN)
*   `approved` (BOOLEAN, DEFAULT FALSE)
*   `approved_by` (INT, FK to `staff.user_id`)
*   `year_of_approval` (INT)
*   `semester_of_approval` (INT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 53. `grades`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `student_id` (INT, NN, FK to `students.user_id`)
*   `class_schedules_id` (INT, NN, FK to `class_schedules.id`)
*   `assessment_type_id` (INT, NN, FK to `assessment_types.id`)
*   `score` (DECIMAL(5, 2), NN)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 54. `assessment_types`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `code` (VARCHAR(20), NN, UQ)
*   `name` (VARCHAR(50), NN)
*   `description` (TEXT)
*   `weight` (DECIMAL(5, 2))
*   `is_active` (BOOLEAN, DEFAULT TRUE)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 55. `attendance`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `student_id` (INT, NN, FK to `students.user_id`)
*   `classes_attended_id` (INT, NN, FK to `classes_attended.id`)
*   `status` (ENUM, NN, DEFAULT 'present')
*   `justification` (TEXT)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### 56. `classes_attended`
*   `id` (INT, PK, AUTO_INCREMENT)
*   `class_id` (INT, NN, FK to `classes.id`)
*   `class_date` (DATE, NN)
*   `time_slot_id` (INT, NN, FK to `time_slots.id`)
*   `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
*   `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)


