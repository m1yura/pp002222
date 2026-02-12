-- Обновление статуса проекта
UPDATE projects
SET status = 'на согласовании',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- Обновление статуса этапа
UPDATE project_stages
SET status = 'на согласовании',
    end_date = CURRENT_DATE
WHERE id = 2;

-- История изменений (если есть таблица логов)
INSERT INTO project_log (project_id, action, user_id, timestamp)
VALUES (1, 'Статус изменен на "на согласовании"', 2, CURRENT_TIMESTAMP);