-- V3__create_user_bicycles.sql
-- ============================================================
-- DOMINIO: Bicicletas registradas por usuarios
-- ============================================================

-- Bicicletas registradas (Aggregate Root)
CREATE TABLE registered_bicycles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,

    -- === ORIGEN ===
    registration_type VARCHAR(20) NOT NULL DEFAULT 'CATALOG',
    -- 'CATALOG' (eligió del catálogo), 'MANUAL' (cargó a mano)
    catalog_bike_id INT REFERENCES bike_catalog(id),
    selected_colorway_id INT REFERENCES bike_catalog_colorways(id),

    -- === CAPA 1: IDENTIFICACIÓN VISUAL (siempre requerido) ===
    frame_brand_id INT REFERENCES brands(id),
    frame_model VARCHAR(150),
    frame_year INT,
    bike_type_id INT REFERENCES bike_types(id),

    -- Talle
    frame_size_id INT REFERENCES frame_sizes(id),
    frame_size_raw VARCHAR(20),

    -- Colores (crítico para matching)
    primary_color_id INT REFERENCES standard_colors(id),
    primary_color_custom VARCHAR(50),
    secondary_color_id INT REFERENCES standard_colors(id),
    accent_color_id INT REFERENCES standard_colors(id),
    color_description TEXT,

    -- Identificador único
    serial_number VARCHAR(100),
    serial_number_location VARCHAR(50),

    -- === CAPA 2: COMPONENTES PRINCIPALES ===
    components JSONB DEFAULT '{}',
    /*
    {
      "wheels_front": {
        "source": "catalog",
        "catalog_id": 123,
        "brand": "Zipp", "model": "303",
        "profile": "high", "color": "black"
      },
      "wheels_rear": { ... },
      "saddle": {
        "source": "override",
        "brand": "Fizik", "model": "Antares",
        "color": "white"
      },
      "handlebar": {
        "source": "factory",
        "type": "drop", "color": "black"
      },
      "bar_tape": { "color": "red" },
      "pedals": {
        "type": "clipless",
        "brand": "Shimano", "model": "SPD-SL",
        "color": "black"
      }
    }
    */

    -- === CAPA 3: DETALLE EXPERTO (opcional) ===
    detailed_specs JSONB DEFAULT '{}',
    /*
    {
      "custom_wheels_front": {
        "hub": {"brand": "DT Swiss", "model": "350", "holes": 32},
        "rim": {"brand": "HED", "model": "Belgium Plus", "holes": 32},
        "spokes": {"brand": "Sapim", "model": "CX-Ray", "count": 32}
      },
      "groupset": {
        "brand": "Shimano", "model": "Ultegra R8000",
        "speeds": "2x11"
      },
      "crankset": {
        "model": "Ultegra FC-R8000",
        "length_mm": 172.5,
        "chainrings": "52-36"
      },
      "bottom_bracket": {
        "brand": "Wheels Mfg",
        "standard": "T47"
      }
    }
    */

    -- === MARCAS DISTINTIVAS ===
    distinguishing_marks JSONB DEFAULT '[]',
    /*
    [
      {"type": "scratch", "location": "top_tube", "description": "rayón 5cm lado izq"},
      {"type": "sticker", "location": "down_tube", "description": "sticker carrera X"},
      {"type": "custom", "location": "stem", "description": "iniciales grabadas JM"}
    ]
    */

    -- === FOTOS ===
    photos JSONB DEFAULT '[]',
    /*
    [
      {"url": "...", "type": "side_full", "is_primary": true, "uploaded_at": "..."},
      {"url": "...", "type": "serial_number"},
      {"url": "...", "type": "detail"},
      {"url": "...", "type": "distinguishing_mark"}
    ]
    */

    -- === METADATA ===
    purchase_date DATE,
    purchase_price DECIMAL(12,2),
    purchase_currency VARCHAR(3) DEFAULT 'ARS',
    estimated_current_value DECIMAL(12,2),
    insurance_policy_number VARCHAR(100),

    notes TEXT,

    -- === ESTADO ===
    status VARCHAR(20) DEFAULT 'ACTIVE',
    -- 'ACTIVE', 'STOLEN', 'SOLD', 'INACTIVE'

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices para búsqueda
CREATE INDEX idx_reg_bicycles_user ON registered_bicycles(user_id);
CREATE INDEX idx_reg_bicycles_status ON registered_bicycles(status);
CREATE INDEX idx_reg_bicycles_brand ON registered_bicycles(frame_brand_id);
CREATE INDEX idx_reg_bicycles_type ON registered_bicycles(bike_type_id);
CREATE INDEX idx_reg_bicycles_color ON registered_bicycles(primary_color_id);
CREATE INDEX idx_reg_bicycles_serial ON registered_bicycles(serial_number) WHERE serial_number IS NOT NULL;
CREATE INDEX idx_reg_bicycles_components ON registered_bicycles USING GIN(components);

-- Historial de cambios de componentes
CREATE TABLE bicycle_component_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bicycle_id UUID NOT NULL REFERENCES registered_bicycles(id) ON DELETE CASCADE,

    component_type VARCHAR(50) NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    -- 'UPGRADE', 'REPLACEMENT', 'REPAIR', 'INITIAL'

    previous_value JSONB,
    new_value JSONB NOT NULL,

    change_date DATE,
    reason TEXT,
    receipt_photo_url TEXT,

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_component_history_bike ON bicycle_component_history(bicycle_id);
CREATE INDEX idx_component_history_type ON bicycle_component_history(component_type);
