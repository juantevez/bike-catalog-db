-- V3__create_bikes_table.sql
-- Tabla principal de bicicletas

CREATE TABLE bikes (
    id BIGSERIAL PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    brand_id BIGINT NOT NULL,
    bike_type_id BIGINT NOT NULL,
    frame_material_id BIGINT NOT NULL,
    frame_size_cm DECIMAL(5,2),
    wheel_size_inches DECIMAL(4,1),
    weight_kg DECIMAL(5,2),
    year INTEGER,
    price_usd DECIMAL(10,2),
    description TEXT,
    image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_bikes_brand
        FOREIGN KEY (brand_id)
        REFERENCES brands(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_bikes_type
        FOREIGN KEY (bike_type_id)
        REFERENCES bike_types(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_bikes_material
        FOREIGN KEY (frame_material_id)
        REFERENCES frame_materials(id)
        ON DELETE RESTRICT,

    -- Constraints
    CONSTRAINT chk_bikes_year
        CHECK (year >= 1900 AND year <= EXTRACT(YEAR FROM CURRENT_DATE) + 1),

    CONSTRAINT chk_bikes_price
        CHECK (price_usd >= 0),

    CONSTRAINT chk_bikes_weight
        CHECK (weight_kg > 0 AND weight_kg < 50),

    CONSTRAINT chk_bikes_frame_size
        CHECK (frame_size_cm > 0 AND frame_size_cm < 100),

    CONSTRAINT chk_bikes_wheel_size
        CHECK (wheel_size_inches > 0 AND wheel_size_inches < 40)
);


-- Tabla de categorías de componentes
CREATE TABLE component_categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_brands_name ON brands(name);
CREATE INDEX idx_bike_types_name ON bike_types(name);
CREATE INDEX idx_component_categories_name ON component_categories(name);

-- Comentarios
COMMENT ON TABLE brands IS 'Marcas fabricantes de bicicletas';
COMMENT ON TABLE bike_types IS 'Tipos de bicicletas (Road, Mountain, etc)';
COMMENT ON TABLE frame_materials IS 'Materiales de cuadro con propiedades físicas';
COMMENT ON TABLE component_categories IS 'Categorías de componentes';

-- Índices para mejorar performance
CREATE INDEX idx_bikes_brand_id ON bikes(brand_id);
CREATE INDEX idx_bikes_type_id ON bikes(bike_type_id);
CREATE INDEX idx_bikes_material_id ON bikes(frame_material_id);
CREATE INDEX idx_bikes_year ON bikes(year);
CREATE INDEX idx_bikes_price ON bikes(price_usd);
CREATE INDEX idx_bikes_active ON bikes(is_active);

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para updated_at
CREATE TRIGGER update_bikes_updated_at
    BEFORE UPDATE ON bikes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comentarios de documentación
COMMENT ON TABLE bikes IS 'Catálogo principal de bicicletas';
COMMENT ON COLUMN bikes.model IS 'Modelo de la bicicleta';
COMMENT ON COLUMN bikes.frame_size_cm IS 'Tamaño del cuadro en centímetros';
COMMENT ON COLUMN bikes.wheel_size_inches IS 'Tamaño de rueda en pulgadas (26, 27.5, 29, etc)';
COMMENT ON COLUMN bikes.weight_kg IS 'Peso de la bicicleta en kilogramos';
