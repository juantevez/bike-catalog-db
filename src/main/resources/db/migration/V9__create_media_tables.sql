-- V9__create_media_tables.sql

-- Fotos de bicicletas con EXIF embebido
CREATE TABLE bicycle_photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bicycle_id UUID NOT NULL REFERENCES registered_bicycles(id) ON DELETE CASCADE,

    -- File info
    file_name VARCHAR(255) NOT NULL,
    content_type VARCHAR(100) NOT NULL,
    file_size_bytes BIGINT NOT NULL,
    file_data BYTEA, -- NULL si usamos storage externo
    storage_path VARCHAR(500), -- Para S3/MinIO futuro

    -- Photo metadata
    photo_type VARCHAR(30) NOT NULL DEFAULT 'GENERAL',
    -- GENERAL, FRONT, SIDE_LEFT, SIDE_RIGHT, SERIAL_NUMBER, DETAIL, DAMAGE, RECEIPT
    is_primary BOOLEAN DEFAULT false,
    description TEXT,

    -- EXIF data (extraído al subir)
    exif_latitude DOUBLE PRECISION,
    exif_longitude DOUBLE PRECISION,
    exif_date_time TIMESTAMP,
    exif_camera_make VARCHAR(100),
    exif_camera_model VARCHAR(100),
    exif_orientation INT,

    -- Audit
    uploaded_at TIMESTAMP DEFAULT NOW(),
    uploaded_by UUID NOT NULL,

    CONSTRAINT chk_photo_type CHECK (photo_type IN (
        'GENERAL', 'FRONT', 'SIDE_LEFT', 'SIDE_RIGHT',
        'SERIAL_NUMBER', 'DETAIL', 'DAMAGE', 'RECEIPT'
    ))
);

-- Índices
CREATE INDEX idx_photos_bicycle ON bicycle_photos(bicycle_id);
CREATE INDEX idx_photos_type ON bicycle_photos(bicycle_id, photo_type);

-- Solo una foto primary por bici
CREATE UNIQUE INDEX idx_photos_primary ON bicycle_photos(bicycle_id)
    WHERE is_primary = true;