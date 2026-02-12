-- Agregar nuevos campos de ubicación
ALTER TABLE theft_reports
    ADD COLUMN IF NOT EXISTS theft_locality_id INT,
    ADD COLUMN IF NOT EXISTS theft_street_type VARCHAR(20),
    ADD COLUMN IF NOT EXISTS theft_street_name VARCHAR(200),
    ADD COLUMN IF NOT EXISTS theft_street_number VARCHAR(20),
    ADD COLUMN IF NOT EXISTS theft_intersection VARCHAR(200),
    ADD COLUMN IF NOT EXISTS theft_reference VARCHAR(500),
    ADD COLUMN IF NOT EXISTS theft_latitude DOUBLE PRECISION,
    ADD COLUMN IF NOT EXISTS theft_longitude DOUBLE PRECISION,
    ADD COLUMN IF NOT EXISTS theft_location_precision VARCHAR(20);

-- Actualizar el campo status para asegurar que tenga valor por defecto
ALTER TABLE theft_reports
    ALTER COLUMN status SET DEFAULT 'ACTIVE';
