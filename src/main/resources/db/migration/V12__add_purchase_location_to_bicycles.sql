-- V12__add_purchase_location_to_bicycles.sql
-- Agrega lugar de compra a las bicicletas registradas

ALTER TABLE registered_bicycles
    ADD COLUMN purchase_location_id INT REFERENCES localities(id);

ALTER TABLE registered_bicycles
    ADD COLUMN purchase_address VARCHAR(255);

-- Índice para búsquedas por ubicación
CREATE INDEX idx_bicycles_purchase_location ON registered_bicycles(purchase_location_id)
    WHERE purchase_location_id IS NOT NULL;

COMMENT ON COLUMN registered_bicycles.purchase_location_id IS 'Localidad donde se compró la bicicleta';
COMMENT ON COLUMN registered_bicycles.purchase_address IS 'Dirección específica (calle y número)';
