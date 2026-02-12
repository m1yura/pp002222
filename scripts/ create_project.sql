-- Создание проекта
INSERT INTO projects (client_id, designer_id, name, description, property_type, area, style, budget, status, start_date, deadline)
VALUES (1, 2, 'Квартира в ЖК "Невский"', 'Дизайн-проект 3-комнатной квартиры', 'квартира', 85.5, 'минимализм', 800000, 'черновик', '2026-02-15', '2026-04-15');

-- Создание этапов проекта
INSERT INTO project_stages (project_id, stage_name, status, start_date, end_date)
VALUES
    (currval('projects_id_seq'), 'бриф', 'в работе', '2026-02-15', '2026-02-20'),
    (currval('projects_id_seq'), 'концепция', 'ожидание', '2026-02-21', '2026-03-05'),
    (currval('projects_id_seq'), '3D-визуализация', 'ожидание', '2026-03-06', '2026-03-20');

-- Создание пустой сметы
INSERT INTO estimates (project_id, estimate_number, total_amount, status, valid_until, created_by)
VALUES (currval('projects_id_seq'), 'EST-2026-001', 0, 'черновик', '2026-03-15', 2);