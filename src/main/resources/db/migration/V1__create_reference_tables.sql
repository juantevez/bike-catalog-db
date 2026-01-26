-- V1__create_reference_tables.sql
-- ============================================================
-- CAPA BASE: Tablas de referencia (lookup tables)
-- ============================================================

-- Marcas (compartida por todos los componentes)
CREATE TABLE brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(50),
    website VARCHAR(255),
    logo_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_brands_slug ON brands(slug);
CREATE INDEX idx_brands_active ON brands(is_active) WHERE is_active = TRUE;

-- Categorías de marca (una marca puede estar en varias)
CREATE TABLE brand_categories (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    category VARCHAR(50) NOT NULL,
    -- 'FRAME', 'WHEELS', 'GROUPSET', 'COCKPIT', 'SADDLE', 'ACCESSORIES'

    UNIQUE(brand_id, category)
);

CREATE INDEX idx_brand_categories_cat ON brand_categories(category);

-- Tipos de bicicleta
CREATE TABLE bike_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon_name VARCHAR(50),
    display_order INT DEFAULT 0
);

-- Sistemas de talle según tipo de bici
CREATE TABLE frame_size_systems (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    description TEXT
    -- 'LETTER_MTB', 'CM_ROAD', 'INCH_MTB', 'NUMERIC_TREK'
);

-- Talles disponibles por sistema
CREATE TABLE frame_sizes (
    id SERIAL PRIMARY KEY,
    size_system_id INT NOT NULL REFERENCES frame_size_systems(id),
    size_code VARCHAR(20) NOT NULL,
    size_label VARCHAR(50),
    size_cm_equivalent DECIMAL(5,1),
    rider_height_min_cm INT,
    rider_height_max_cm INT,
    display_order INT DEFAULT 0,

    UNIQUE(size_system_id, size_code)
);

CREATE INDEX idx_frame_sizes_system ON frame_sizes(size_system_id);

-- Colores estándar (para normalizar búsquedas)
CREATE TABLE standard_colors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    name_es VARCHAR(50),
    hex_code VARCHAR(7),
    color_family VARCHAR(30),
    -- 'black', 'white', 'red', 'blue', 'green', 'yellow', 'orange', 'gray', 'silver', 'gold'
    display_order INT DEFAULT 0
);

-- Configuraciones de velocidades
CREATE TABLE speed_configs (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    front_gears INT NOT NULL,
    rear_gears INT NOT NULL,
    total_speeds INT GENERATED ALWAYS AS (front_gears * rear_gears) STORED,

    UNIQUE(front_gears, rear_gears)
);
