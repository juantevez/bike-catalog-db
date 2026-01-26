-- V2__create_catalog_tables.sql
-- ============================================================
-- CATÁLOGO: Bicicletas y componentes de fábrica
-- ============================================================

-- Catálogo de bicicletas completas
CREATE TABLE bike_catalog (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL REFERENCES brands(id),
    model_name VARCHAR(150) NOT NULL,
    model_year INT NOT NULL,
    bike_type_id INT NOT NULL REFERENCES bike_types(id),
    size_system_id INT REFERENCES frame_size_systems(id),

    -- Specs visuales (CAPA 1 - crítico para matching)
    frame_material VARCHAR(50),

    -- Specs técnicos básicos
    groupset_brand_id INT REFERENCES brands(id),
    groupset_model VARCHAR(100),
    speed_config_id INT REFERENCES speed_configs(id),
    brake_type VARCHAR(50),

    -- Metadata
    msrp_usd DECIMAL(10,2),
    msrp_ars DECIMAL(12,2),
    weight_kg DECIMAL(4,2),
    product_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(brand_id, model_name, model_year)
);

CREATE INDEX idx_bike_catalog_brand ON bike_catalog(brand_id);
CREATE INDEX idx_bike_catalog_year ON bike_catalog(model_year);
CREATE INDEX idx_bike_catalog_type ON bike_catalog(bike_type_id);

-- Colorways disponibles por modelo
CREATE TABLE bike_catalog_colorways (
    id SERIAL PRIMARY KEY,
    bike_catalog_id INT NOT NULL REFERENCES bike_catalog(id) ON DELETE CASCADE,
    colorway_code VARCHAR(50) NOT NULL,
    colorway_name VARCHAR(100),
    primary_color_id INT REFERENCES standard_colors(id),
    secondary_color_id INT REFERENCES standard_colors(id),
    accent_color_id INT REFERENCES standard_colors(id),
    finish VARCHAR(30),
    image_url TEXT,
    is_default BOOLEAN DEFAULT FALSE,

    UNIQUE(bike_catalog_id, colorway_code)
);

CREATE INDEX idx_colorways_bike ON bike_catalog_colorways(bike_catalog_id);
CREATE INDEX idx_colorways_primary ON bike_catalog_colorways(primary_color_id);

-- Componentes de fábrica por modelo de bici
CREATE TABLE bike_catalog_components (
    id SERIAL PRIMARY KEY,
    bike_catalog_id INT NOT NULL REFERENCES bike_catalog(id) ON DELETE CASCADE,
    component_type VARCHAR(50) NOT NULL,
    -- 'WHEELS', 'SADDLE', 'HANDLEBAR', 'STEM', 'SEATPOST', 'PEDALS', 'TIRES'

    brand_id INT REFERENCES brands(id),
    model VARCHAR(100),

    -- Atributos visuales (lo que importa para matching)
    visual_attributes JSONB DEFAULT '{}',
    /*
    Para WHEELS: {"profile": "low", "profile_mm": 30, "color": "black", "decal_color": "white"}
    Para SADDLE: {"color": "black", "rail_color": "silver"}
    Para HANDLEBAR: {"type": "drop", "color": "black"}
    Para BAR_TAPE: {"color": "black"}
    */

    -- Atributos técnicos (CAPA 2)
    technical_attributes JSONB DEFAULT '{}',
    /*
    Para WHEELS: {"rim_width_mm": 21, "brake_type": "disc", "axle": "TA_12x142"}
    Para SADDLE: {"width_mm": 142, "padding": "medium"}
    */

    UNIQUE(bike_catalog_id, component_type)
);

CREATE INDEX idx_catalog_components_bike ON bike_catalog_components(bike_catalog_id);
CREATE INDEX idx_catalog_components_type ON bike_catalog_components(component_type);

-- ============================================================
-- CATÁLOGO DETALLADO DE COMPONENTES (para búsqueda y CAPA 3)
-- ============================================================

-- Catálogo de ruedas completas (de fábrica)
CREATE TABLE wheel_catalog (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL REFERENCES brands(id),
    model VARCHAR(100) NOT NULL,
    wheel_type VARCHAR(20) NOT NULL,
    bike_type_id INT REFERENCES bike_types(id),

    -- Visual (CAPA 1)
    profile_category VARCHAR(20),
    profile_mm INT,
    rim_color VARCHAR(50),
    decal_color VARCHAR(50),
    hub_color VARCHAR(50),

    -- Técnico (CAPA 2)
    rim_material VARCHAR(50),
    rim_width_internal_mm DECIMAL(4,1),
    rim_width_external_mm DECIMAL(4,1),
    brake_compatibility VARCHAR(50),
    axle_front VARCHAR(50),
    axle_rear VARCHAR(50),
    weight_grams INT,
    tubeless_ready BOOLEAN,

    msrp_usd DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(brand_id, model)
);

CREATE INDEX idx_wheel_catalog_brand ON wheel_catalog(brand_id);
CREATE INDEX idx_wheel_catalog_profile ON wheel_catalog(profile_category);

-- Catálogo de mazas (CAPA 3)
CREATE TABLE hub_catalog (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL REFERENCES brands(id),
    model VARCHAR(100) NOT NULL,
    hub_position VARCHAR(10) NOT NULL,

    -- Specs
    hole_counts INT[] NOT NULL,
    axle_standards VARCHAR(50)[] NOT NULL,
    freehub_type VARCHAR(50),
    engagement_degrees DECIMAL(4,1),
    weight_grams INT,

    -- Visual
    color VARCHAR(50),
    material VARCHAR(50),

    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(brand_id, model, hub_position)
);

-- Catálogo de llantas/aros (CAPA 3)
CREATE TABLE rim_catalog (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL REFERENCES brands(id),
    model VARCHAR(100) NOT NULL,

    -- Dimensiones
    rim_size VARCHAR(20) NOT NULL,
    width_internal_mm DECIMAL(4,1),
    width_external_mm DECIMAL(4,1),
    depth_mm INT,
    hole_counts INT[] NOT NULL,

    -- Specs
    material VARCHAR(50),
    brake_track VARCHAR(50),
    tubeless_ready BOOLEAN,
    weight_grams INT,

    -- Visual
    color VARCHAR(50),
    decal_color VARCHAR(50),

    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(brand_id, model, rim_size)
);

-- Catálogo de asientos
CREATE TABLE saddle_catalog (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL REFERENCES brands(id),
    model VARCHAR(100) NOT NULL,

    -- Visual
    color VARCHAR(50),
    rail_material VARCHAR(50),
    rail_color VARCHAR(50),

    -- Specs
    width_mm INT,
    length_mm INT,
    weight_grams INT,
    cutout BOOLEAN,
    padding_level VARCHAR(20),

    intended_use VARCHAR(50),

    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(brand_id, model)
);

CREATE TABLE frame_materials (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    density_kg_m3 DECIMAL(8,2),
    tensile_strength_mpa DECIMAL(8,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_frame_materials_name ON frame_materials(name);

COMMENT ON TABLE frame_materials IS 'Materiales de cuadro con propiedades físicas';
