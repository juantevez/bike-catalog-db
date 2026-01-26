-- V5__seed_initial_data.sql
-- ============================================================
-- DATOS INICIALES
-- ============================================================


-- Tipos de bicicleta
INSERT INTO bike_types (name, slug, description, display_order) VALUES
('Road', 'road', 'Bicicletas de ruta/carretera', 1),
('MTB', 'mtb', 'Mountain Bike / Bicicleta de montaña', 2),
('Gravel', 'gravel', 'Bicicletas gravel/adventure', 3),
('Urban', 'urban', 'Bicicletas urbanas/commuter', 4),
('Hybrid', 'hybrid', 'Bicicletas híbridas', 5),
('BMX', 'bmx', 'BMX', 6),
('Fixie', 'fixie', 'Fixed gear / Piñón fijo', 7),
('Touring', 'touring', 'Bicicletas de cicloturismo', 8),
('Triathlon', 'triathlon', 'Bicicletas de triatlón/TT', 9),
('Cyclocross', 'cyclocross', 'Bicicletas de ciclocross', 10),
('E-Bike', 'ebike', 'Bicicletas eléctricas', 11),
('Kids', 'kids', 'Bicicletas para niños', 12),
('Cargo', 'cargo', 'Bicicletas de carga', 13);

-- Sistemas de talle
INSERT INTO frame_size_systems (name, code, description) VALUES
('Letras MTB', 'LETTER_MTB', 'XS, S, M, M/L, L, XL, XXL'),
('Centímetros Ruta', 'CM_ROAD', '47-62 cm'),
('Pulgadas MTB', 'INCH_MTB', '13-23 pulgadas'),
('Numérico Simple', 'NUMERIC', 'Talle único o S/M/L genérico');

-- Talles MTB (letras)
INSERT INTO frame_sizes (size_system_id, size_code, size_label, size_cm_equivalent, rider_height_min_cm, rider_height_max_cm, display_order)
SELECT id, 'XS', 'Extra Small', 35.5, 152, 162, 1 FROM frame_size_systems WHERE code = 'LETTER_MTB'
UNION ALL SELECT id, 'S', 'Small', 40.6, 160, 170, 2 FROM frame_size_systems WHERE code = 'LETTER_MTB'
UNION ALL SELECT id, 'M', 'Medium', 45.7, 168, 178, 3 FROM frame_size_systems WHERE code = 'LETTER_MTB'
UNION ALL SELECT id, 'M/L', 'Medium/Large', 48.2, 175, 183, 4 FROM frame_size_systems WHERE code = 'LETTER_MTB'
UNION ALL SELECT id, 'L', 'Large', 50.8, 180, 188, 5 FROM frame_size_systems WHERE code = 'LETTER_MTB'
UNION ALL SELECT id, 'XL', 'Extra Large', 55.9, 185, 195, 6 FROM frame_size_systems WHERE code = 'LETTER_MTB'
UNION ALL SELECT id, 'XXL', 'Extra Extra Large', 61.0, 193, 203, 7 FROM frame_size_systems WHERE code = 'LETTER_MTB';

-- Talles Ruta (cm)
INSERT INTO frame_sizes (size_system_id, size_code, size_label, size_cm_equivalent, rider_height_min_cm, rider_height_max_cm, display_order)
SELECT id, '47', '47 cm', 47, 152, 160, 1 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '49', '49 cm', 49, 157, 165, 2 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '51', '51 cm', 51, 163, 170, 3 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '52', '52 cm', 52, 165, 172, 4 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '54', '54 cm', 54, 170, 178, 5 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '56', '56 cm', 56, 175, 183, 6 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '58', '58 cm', 58, 180, 188, 7 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '60', '60 cm', 60, 185, 193, 8 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '61', '61 cm', 61, 190, 198, 9 FROM frame_size_systems WHERE code = 'CM_ROAD'
UNION ALL SELECT id, '62', '62 cm', 62, 193, 203, 10 FROM frame_size_systems WHERE code = 'CM_ROAD';

-- Configuraciones de velocidades
INSERT INTO speed_configs (code, front_gears, rear_gears) VALUES
('1x10', 1, 10),
('1x11', 1, 11),
('1x12', 1, 12),
('1x13', 1, 13),
('2x10', 2, 10),
('2x11', 2, 11),
('2x12', 2, 12),
('3x7', 3, 7),
('3x8', 3, 8),
('3x9', 3, 9),
('SS', 1, 1);

-- Marcas principales (ejemplo inicial)
INSERT INTO brands (name, slug, country, is_active) VALUES
('Trek', 'trek', 'USA', true),
('Specialized', 'specialized', 'USA', true),
('Giant', 'giant', 'Taiwan', true),
('Cannondale', 'cannondale', 'USA', true),
('Scott', 'scott', 'Switzerland', true),
('Bianchi', 'bianchi', 'Italy', true),
('Cervélo', 'cervelo', 'Canada', true),
('Pinarello', 'pinarello', 'Italy', true),
('Canyon', 'canyon', 'Germany', true),
('BMC', 'bmc', 'Switzerland', true),
('Shimano', 'shimano', 'Japan', true),
('SRAM', 'sram', 'USA', true),
('Campagnolo', 'campagnolo', 'Italy', true),
('Zipp', 'zipp', 'USA', true),
('Enve', 'enve', 'USA', true),
('DT Swiss', 'dt-swiss', 'Switzerland', true),
('Fizik', 'fizik', 'Italy', true),
('Selle Italia', 'selle-italia', 'Italy', true),
('Brooks', 'brooks', 'UK', true),
('PRO', 'pro', 'Netherlands', true);

-- Categorías de marca
INSERT INTO brand_categories (brand_id, category)
SELECT id, 'FRAME' FROM brands WHERE slug IN ('trek', 'specialized', 'giant', 'cannondale', 'scott', 'bianchi', 'cervelo', 'pinarello', 'canyon', 'bmc')
UNION ALL
SELECT id, 'GROUPSET' FROM brands WHERE slug IN ('shimano', 'sram', 'campagnolo')
UNION ALL
SELECT id, 'WHEELS' FROM brands WHERE slug IN ('zipp', 'enve', 'dt-swiss', 'shimano')
UNION ALL
SELECT id, 'SADDLE' FROM brands WHERE slug IN ('fizik', 'selle-italia', 'brooks', 'specialized')
UNION ALL
SELECT id, 'COCKPIT' FROM brands WHERE slug IN ('zipp', 'enve', 'pro', 'specialized', 'cannondale');
