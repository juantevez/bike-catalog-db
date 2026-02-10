-- Migración para añadir soporte de archivos a la tabla registered_bicycles
ALTER TABLE registered_bicycles
    ADD COLUMN IF NOT EXISTS purchase_receipt_data BYTEA,
    ADD COLUMN IF NOT EXISTS purchase_receipqt_mime_type VARCHAR(50),
q
    ADD COLUMN IF NOT EXISTS purchase_receipt_url VARCHAR(125);



-- Comentario opcional para documentar las columnas
COMMENT ON COLUMN registered_bicycles.purchase_receipt_data IS 'Contenido binario del recibo (PDF o Imagen)';
COMMENT ON COLUMN registered_bicycles.purchase_receipt_mime_type IS 'Tipo de contenido (e.g., application/pdf, image/jpeg)';
