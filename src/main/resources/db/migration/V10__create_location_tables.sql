-- V10__create_location_tables.sql
-- Estructura extensible para ubicaciones geográficas

-- Países
CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_local VARCHAR(100),
    iso_code_2 CHAR(2) NOT NULL UNIQUE,
    iso_code_3 CHAR(3) NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Nivel 1: Provincias/Estados/Regiones
CREATE TABLE admin_level_1 (
    id SERIAL PRIMARY KEY,
    country_id INT NOT NULL REFERENCES countries(id),
    name VARCHAR(100) NOT NULL,
    iso_code VARCHAR(6),
    type VARCHAR(30) NOT NULL,
    display_order INT,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(country_id, name),
    CONSTRAINT chk_admin1_type CHECK (type IN ('PROVINCE', 'STATE', 'REGION', 'AUTONOMOUS_CITY', 'FEDERAL_DISTRICT'))
);

-- Nivel 2: Departamentos/Partidos/Municipios/Comunas
CREATE TABLE admin_level_2 (
    id SERIAL PRIMARY KEY,
    admin_level_1_id INT NOT NULL REFERENCES admin_level_1(id),
    name VARCHAR(100) NOT NULL,
    type VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(admin_level_1_id, name),
    CONSTRAINT chk_admin2_type CHECK (type IN ('DEPARTMENT', 'PARTIDO', 'MUNICIPALITY', 'COMUNA', 'DISTRICT'))
);

-- Nivel 3: Localidades/Barrios/Ciudades
CREATE TABLE localities (
    id SERIAL PRIMARY KEY,
    admin_level_2_id INT NOT NULL REFERENCES admin_level_2(id),
    name VARCHAR(100) NOT NULL,
    type VARCHAR(30) NOT NULL,
    postal_code VARCHAR(20),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    population INT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(admin_level_2_id, name),
    CONSTRAINT chk_locality_type CHECK (type IN ('CITY', 'TOWN', 'VILLAGE', 'NEIGHBORHOOD', 'BARRIO', 'COMMUNE'))
);

-- Índices para búsquedas
CREATE INDEX idx_admin1_country ON admin_level_1(country_id);
CREATE INDEX idx_admin1_type ON admin_level_1(type);
CREATE INDEX idx_admin2_admin1 ON admin_level_2(admin_level_1_id);
CREATE INDEX idx_localities_admin2 ON localities(admin_level_2_id);
CREATE INDEX idx_localities_postal ON localities(postal_code) WHERE postal_code IS NOT NULL;
CREATE INDEX idx_localities_name ON localities(name);
CREATE INDEX idx_localities_search ON localities USING gin(to_tsvector('spanish', name));

-- Vista útil para obtener localidad con jerarquía completa
CREATE OR REPLACE VIEW v_localities_full AS
SELECT
    l.id AS locality_id,
    l.name AS locality_name,
    l.type AS locality_type,
    l.postal_code,
    l.latitude,
    l.longitude,
    a2.id AS admin_level_2_id,
    a2.name AS admin_level_2_name,
    a2.type AS admin_level_2_type,
    a1.id AS admin_level_1_id,
    a1.name AS admin_level_1_name,
    a1.type AS admin_level_1_type,
    a1.iso_code AS admin_level_1_iso,
    c.id AS country_id,
    c.name AS country_name,
    c.iso_code_2 AS country_iso
FROM localities l
JOIN admin_level_2 a2 ON l.admin_level_2_id = a2.id
JOIN admin_level_1 a1 ON a2.admin_level_1_id = a1.id
JOIN countries c ON a1.country_id = c.id
WHERE l.is_active = true;
