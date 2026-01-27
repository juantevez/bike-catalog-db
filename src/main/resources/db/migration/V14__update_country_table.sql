-- 1. Eliminar la vista para romper la dependencia temporalmente
DROP VIEW IF EXISTS v_localities_full;

-- 2. Modificar los tipos de datos en la tabla base
ALTER TABLE countries 
    ALTER COLUMN iso_code_2 TYPE VARCHAR(2),
    ALTER COLUMN iso_code_3 TYPE VARCHAR(3);

-- 3. Recrear la vista con la nueva estructura
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
