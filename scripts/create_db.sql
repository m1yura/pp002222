-- Создание базы данных
CREATE DATABASE interior_design_db;

-- Подключение к БД
\c interior_design_db;

-- Таблица пользователей
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) CHECK (role IN ('admin', 'designer', 'client')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица клиентов
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    company_name VARCHAR(100),
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    source VARCHAR(50) CHECK (source IN ('сайт', 'рекомендация', 'соцсети', 'повторный')),
    status VARCHAR(20) CHECK (status IN ('потенциальный', 'активный', 'архивный')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица проектов
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
    designer_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    property_type VARCHAR(50) CHECK (property_type IN ('квартира', 'дом', 'офис', 'ресторан', 'магазин', 'другое')),
    area DECIMAL(10,2),
    style VARCHAR(50),
    budget DECIMAL(15,2),
    status VARCHAR(30) CHECK (status IN ('черновик', 'в работе', 'на согласовании', 'завершен', 'отменен')),
    start_date DATE,
    deadline DATE,
    completion_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица этапов проекта
CREATE TABLE project_stages (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
    stage_name VARCHAR(100) CHECK (stage_name IN ('бриф', 'концепция', '3D-визуализация', 'чертежи', 'реализация')),
    status VARCHAR(20) CHECK (status IN ('ожидание', 'в работе', 'на согласовании', 'утвержден')),
    start_date DATE,
    end_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица файлов
CREATE TABLE files (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
    stage_id INTEGER REFERENCES project_stages(id) ON DELETE SET NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    file_type VARCHAR(50),
    uploaded_by INTEGER REFERENCES users(id),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица смет
CREATE TABLE estimates (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
    estimate_number VARCHAR(50) UNIQUE NOT NULL,
    total_amount DECIMAL(15,2) DEFAULT 0,
    status VARCHAR(20) CHECK (status IN ('черновик', 'утверждена', 'оплачена', 'просрочена')),
    valid_until DATE,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица позиций сметы
CREATE TABLE estimate_items (
    id SERIAL PRIMARY KEY,
    estimate_id INTEGER REFERENCES estimates(id) ON DELETE CASCADE,
    item_type VARCHAR(50) CHECK (item_type IN ('работа', 'материал', 'мебель', 'оборудование', 'услуги')),
    description TEXT NOT NULL,
    quantity INTEGER DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    amount DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    notes TEXT
);

-- Таблица счетов
CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
    estimate_id INTEGER REFERENCES estimates(id) ON DELETE SET NULL,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('ожидание', 'частично оплачен', 'оплачен', 'просрочен')),
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица портфолио
CREATE TABLE portfolio (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    property_type VARCHAR(50),
    area DECIMAL(10,2),
    style VARCHAR(50),
    year_completed INTEGER,
    is_public BOOLEAN DEFAULT TRUE,
    views_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица материалов
CREATE TABLE materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(50) CHECK (category IN ('отделка', 'напольные', 'стены', 'потолок', 'текстиль', 'декор')),
    supplier VARCHAR(100),
    price DECIMAL(10,2),
    unit VARCHAR(20),
    in_stock BOOLEAN DEFAULT TRUE,
    photo_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица материалов в проектах
CREATE TABLE project_materials (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id) ON DELETE CASCADE,
    material_id INTEGER REFERENCES materials(id) ON DELETE SET NULL,
    quantity DECIMAL(10,2),
    unit VARCHAR(20),
    price_at_purchase DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('запланирован', 'заказан', 'доставлен', 'использован'))
);

-- Индексы для оптимизации
CREATE INDEX idx_projects_client ON projects(client_id);
CREATE INDEX idx_projects_designer ON projects(designer_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_clients_status ON clients(status);
CREATE INDEX idx_invoices_due_date ON invoices(due_date);
CREATE INDEX idx_portfolio_style ON portfolio(style);