-- Vista para búsqueda pública de bicis robadas
CREATE OR REPLACE VIEW v_stolen_bikes_public AS
SELECT
    tr.id AS report_id,
    tr.bicycle_id,
    tr.theft_date,
    tr.theft_time_approx,
    tr.theft_description,
    tr.reward_offered,
    tr.reward_amount,
    tr.reward_currency,
    tr.reported_at,
    -- Contacto solo si es público
    CASE WHEN tr.contact_public THEN tr.contact_phone ELSE NULL END AS contact_phone,
    CASE WHEN tr.contact_public THEN tr.contact_email ELSE NULL END AS contact_email,
    -- Ubicación del robo
    l.id AS location_id,
    l.name AS locality_name,
    a1.name AS province_name,
    tr.theft_address,
    -- Datos de la bici (no sensibles)
    rb.bike_type_id,
    rb.primary_color_id,
    rb.secondary_color_id,
    b.name AS brand_name
    --rb.model_name,
    --rb.year
FROM theft_reports tr
JOIN registered_bicycles rb ON tr.bicycle_id = rb.id
LEFT JOIN brands b ON rb.frame_brand_id = b.id
LEFT JOIN localities l ON tr.theft_location_id = l.id
LEFT JOIN admin_level_2 a2 ON l.admin_level_2_id = a2.id
LEFT JOIN admin_level_1 a1 ON a2.admin_level_1_id = a1.id
WHERE tr.status = 'ACTIVE'
  AND rb.status = 'STOLEN';

COMMENT ON VIEW v_stolen_bikes_public IS 'Vista pública de bicicletas robadas para búsqueda';
