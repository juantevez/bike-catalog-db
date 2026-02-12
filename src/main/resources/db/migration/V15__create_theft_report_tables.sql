-- V15__create_theft_report_tables.sql
-- Tablas para reportes de robo y avistamientos

DROP TABLE IF EXISTS theft_reports CASCADE;

-- Reportes de robo
CREATE TABLE theft_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bicycle_id UUID NOT NULL REFERENCES registered_bicycles(id),
    reported_by UUID NOT NULL,

    -- Estado del reporte
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    -- Datos del robo
    theft_date DATE NOT NULL,
    theft_time_approx VARCHAR(50),
    theft_location_id INT REFERENCES localities(id),
    theft_address VARCHAR(255),
    theft_description TEXT,

    -- Contacto
    contact_phone VARCHAR(50),
    contact_email VARCHAR(255),
    contact_public BOOLEAN DEFAULT false,

    -- Recompensa
    reward_offered BOOLEAN DEFAULT false,
    reward_amount DECIMAL(12,2),
    reward_currency VARCHAR(3) DEFAULT 'ARS',

    -- Auditoría
    reported_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    found_at TIMESTAMP,
    closed_at TIMESTAMP,

    CONSTRAINT chk_theft_status CHECK (status IN ('ACTIVE', 'FOUND', 'CLOSED')),
    CONSTRAINT chk_reward CHECK (
        (reward_offered = false) OR
        (reward_offered = true AND reward_amount IS NOT NULL AND reward_amount > 0)
    )
);

-- Avistamientos reportados por terceros
CREATE TABLE theft_sightings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theft_report_id UUID NOT NULL REFERENCES theft_reports(id) ON DELETE CASCADE,

    -- Datos del avistamiento
    sighting_date DATE NOT NULL,
    sighting_time_approx VARCHAR(50),
    sighting_location_id INT REFERENCES localities(id),
    sighting_address VARCHAR(255),
    description TEXT,

    -- Contacto del reportante (opcional, puede ser anónimo)
    reporter_name VARCHAR(100),
    reporter_contact VARCHAR(255),
    is_anonymous BOOLEAN DEFAULT false,

    -- Auditoría
    reported_at TIMESTAMP DEFAULT NOW(),
    is_verified BOOLEAN DEFAULT false,
    verified_at TIMESTAMP,

    CONSTRAINT chk_anonymous CHECK (
        (is_anonymous = true) OR
        (is_anonymous = false AND (reporter_name IS NOT NULL OR reporter_contact IS NOT NULL))
    )
);

-- Índices
CREATE INDEX idx_theft_reports_bicycle ON theft_reports(bicycle_id);
CREATE INDEX idx_theft_reports_status ON theft_reports(status);
CREATE INDEX idx_theft_reports_location ON theft_reports(theft_location_id);
CREATE INDEX idx_theft_reports_date ON theft_reports(theft_date DESC);
CREATE INDEX idx_theft_reports_reported_at ON theft_reports(reported_at DESC);

CREATE INDEX idx_sightings_report ON theft_sightings(theft_report_id);
CREATE INDEX idx_sightings_date ON theft_sightings(sighting_date DESC);

-- Índice para búsqueda full-text en descripción
CREATE INDEX idx_theft_reports_description ON theft_reports
    USING gin(to_tsvector('spanish', COALESCE(theft_description, '')));


COMMENT ON TABLE theft_reports IS 'Reportes de robo de bicicletas';
COMMENT ON TABLE theft_sightings IS 'Avistamientos de bicicletas robadas reportados por terceros';
--COMMENT ON VIEW v_stolen_bikes_public IS 'Vista pública de bicicletas robadas para búsqueda';
