-- Добавление нового пользователя-клиента
INSERT INTO users (full_name, email, password_hash, phone, role)
VALUES ('Иванов Иван Иванович', 'ivanov@email.com', 'hash123456', '+7(999)123-45-67', 'client');

-- Добавление в таблицу клиентов
INSERT INTO clients (user_id, company_name, contact_person, phone, email, source, status)
VALUES (
    currval('users_id_seq'),
    NULL,
    'Иванов Иван',
    '+7(999)123-45-67',
    'ivanov@email.com',
    'сайт',
    'потенциальный'
);