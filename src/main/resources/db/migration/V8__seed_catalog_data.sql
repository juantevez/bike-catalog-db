-- V8__seed_catalog_data.sql
-- Datos de catálogo para testing: marcas, tipos, bikes y colorways

-- ============================================
-- BRANDS (Marcas de bicicletas)
-- ============================================
INSERT INTO brands (id, name, slug, country, logo_url, website, is_active) VALUES
(1, 'Specialized', 'specialized', 'USA', NULL, 'https://specialized.com', true),
(2, 'Trek', 'trek', 'USA', NULL, 'https://trekbikes.com', true),
(3, 'Giant', 'giant', 'Taiwan', NULL, 'https://giant-bicycles.com', true),
(4, 'Cannondale', 'cannondale', 'USA', NULL, 'https://cannondale.com', true),
(5, 'Scott', 'scott', 'Switzerland', NULL, 'https://scott-sports.com', true),
(6, 'Bianchi', 'bianchi', 'Italy', NULL, 'https://bianchi.com', true),
(7, 'Canyon', 'canyon', 'Germany', NULL, 'https://canyon.com', true),
(8, 'Cervelo', 'cervelo', 'Canada', NULL, 'https://cervelo.com', true),
(9, 'Pinarello', 'pinarello', 'Italy', NULL, 'https://pinarello.com', true),
(10, 'BMC', 'bmc', 'Switzerland', NULL, 'https://bmc-switzerland.com', true)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- BRAND CATEGORIES
-- ============================================
INSERT INTO brand_categories (brand_id, category) VALUES
(1, 'FRAME'), (1, 'COMPONENTS'),
(2, 'FRAME'), (2, 'COMPONENTS'),
(3, 'FRAME'), (3, 'COMPONENTS'),
(4, 'FRAME'),
(5, 'FRAME'),
(6, 'FRAME'),
(7, 'FRAME'),
(8, 'FRAME'),
(9, 'FRAME'),
(10, 'FRAME')
ON CONFLICT DO NOTHING;

-- ============================================
-- BIKE TYPES
-- ============================================
INSERT INTO bike_types (id, name, slug, description, icon_name, display_order) VALUES
(1, 'Road', 'road', 'Bicicletas de ruta para asfalto', 'road-bike', 1),
(2, 'Mountain', 'mountain', 'Bicicletas de montaña para trail y XC', 'mountain-bike', 2),
(3, 'Gravel', 'gravel', 'Bicicletas gravel para caminos mixtos', 'gravel-bike', 3),
(4, 'Urban', 'urban', 'Bicicletas urbanas y de paseo', 'urban-bike', 4),
(5, 'BMX', 'bmx', 'Bicicletas BMX freestyle y race', 'bmx-bike', 5),
(6, 'Hybrid', 'hybrid', 'Bicicletas híbridas multiuso', 'hybrid-bike', 6),
(7, 'Time Trial', 'tt', 'Bicicletas de contrarreloj y triatlón', 'tt-bike', 7),
(8, 'Cyclocross', 'cyclocross', 'Bicicletas de ciclocross', 'cx-bike', 8)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- FRAME SIZE SYSTEMS
-- ============================================
INSERT INTO frame_size_systems (id, name, code, description) VALUES
(1, 'Road Standard', 'code-road', 'Sistema estándar para bicis de ruta (cm)'),
(2, 'MTB Standard', 'code-mtb','Sistema estándar para MTB (S/M/L)'),
(3, 'Urban Standard', 'code-urban','Sistema para bicis urbanas')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- FRAME SIZES
-- ============================================
INSERT INTO frame_sizes (id, size_system_id, size_code, size_label, size_cm_equivalent, rider_height_min_cm, rider_height_max_cm, display_order) VALUES
-- Road sizes (cm)
(1, 1, '49', '49cm', 49, 155, 165, 1),
(2, 1, '52', '52cm', 52, 163, 170, 2),
(3, 1, '54', '54cm', 54, 168, 175, 3),
(4, 1, '56', '56cm', 56, 173, 180, 4),
(5, 1, '58', '58cm', 58, 178, 185, 5),
(6, 1, '61', '61cm', 61, 183, 195, 6),
-- MTB sizes (S/M/L)
(7, 2, 'XS', 'Extra Small', 35, 150, 160, 1),
(8, 2, 'S', 'Small', 38, 158, 168, 2),
(9, 2, 'M', 'Medium', 43, 165, 175, 3),
(10, 2, 'L', 'Large', 48, 173, 183, 4),
(11, 2, 'XL', 'Extra Large', 53, 180, 195, 5)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- SPEED CONFIGS
-- ============================================
INSERT INTO speed_configs (id, code, front_gears, rear_gears) VALUES
(1, '1x11', 1, 11),
(2, '1x12', 1, 12),
(3, '2x11', 2, 11),
(4, '2x12', 2, 12),
(5, '3x9', 3, 9),
(6, '1x10', 1, 10),
(7, 'Single', 1, 1)
ON CONFLICT (id) DO NOTHING;


-- ============================================
-- BIKE CATALOG (Modelos de bicicletas)
-- ============================================
INSERT INTO bike_catalog (id, brand_id, model_name, model_year, bike_type_id, size_system_id, frame_material, groupset_brand_id, groupset_model, speed_config_id, brake_type, is_active) VALUES
-- Specialized
(1, 1, 'Tarmac SL7', 2024, 1, 1, 'carbon', 1, 'Shimano Ultegra Di2', 4, 'disc', true),
(2, 1, 'Roubaix', 2024, 1, 1, 'carbon', 1, 'Shimano 105 Di2', 4, 'disc', true),
(3, 1, 'Diverge', 2024, 3, 1, 'carbon', 1, 'SRAM Rival eTap', 2, 'disc', true),
(4, 1, 'Epic', 2024, 2, 2, 'carbon', 1, 'SRAM XX1 Eagle', 2, 'disc', true),

-- Trek
(5, 2, 'Madone', 2024, 1, 1, 'carbon', 1, 'Shimano Dura-Ace Di2', 4, 'disc', true),
(6, 2, 'Domane', 2024, 1, 1, 'carbon', 1, 'Shimano Ultegra Di2', 4, 'disc', true),
(7, 2, 'Checkpoint', 2024, 3, 1, 'aluminum', 1, 'Shimano GRX', 3, 'disc', true),
(8, 2, 'Fuel EX', 2024, 2, 2, 'carbon', 1, 'SRAM GX Eagle', 2, 'disc', true),

-- Giant
(9, 3, 'TCR Advanced', 2024, 1, 1, 'carbon', 1, 'Shimano Ultegra', 3, 'disc', true),
(10, 3, 'Defy Advanced', 2024, 1, 1, 'carbon', 1, 'Shimano 105', 3, 'disc', true),
(11, 3, 'Revolt', 2024, 3, 1, 'aluminum', 1, 'Shimano GRX', 3, 'disc', true),

-- Canyon
(12, 7, 'Aeroad', 2024, 1, 1, 'carbon', 1, 'Shimano Dura-Ace Di2', 4, 'disc', true),
(13, 7, 'Ultimate', 2024, 1, 1, 'carbon', 1, 'SRAM Red eTap', 4, 'disc', true),
(14, 7, 'Grail', 2024, 3, 1, 'carbon', 1, 'SRAM Force eTap', 2, 'disc', true),
(15, 7, 'Spectral', 2024, 2, 2, 'carbon', 1, 'SRAM GX Eagle', 2, 'disc', true)

ON CONFLICT (id) DO NOTHING;

-- ============================================
-- BIKE CATALOG COLORWAYS
-- ============================================
INSERT INTO bike_catalog_colorways (id, bike_catalog_id, colorway_code, colorway_name, primary_color_id, secondary_color_id, accent_color_id, finish, image_url, is_default) VALUES
-- Specialized Tarmac SL7
(1, 1, 'BLK-WHT', 'Gloss Black/White', 1, 2, NULL, 'gloss', NULL, true),
(2, 1, 'RED-BLK', 'Gloss Red/Black', 5, 1, NULL, 'gloss', NULL, false),
(3, 1, 'BLU-SLV', 'Metallic Blue/Silver', 8, 4, NULL, 'metallic', NULL, false),

-- Specialized Roubaix
(4, 2, 'WHT-SLV', 'Pearl White/Silver', 2, 4, NULL, 'pearl', NULL, true),
(5, 2, 'BLK-RED', 'Satin Black/Red', 25, 5, NULL, 'satin', NULL, false),

-- Specialized Diverge
(6, 3, 'GRN-BLK', 'Forest Green/Black', 13, 1, NULL, 'satin', NULL, true),
(7, 3, 'ORG-BLK', 'Orange/Black', 17, 1, NULL, 'gloss', NULL, false),

-- Trek Madone
(8, 5, 'WHT-BLK', 'Trek White/Black', 2, 1, 5, 'gloss', NULL, true),
(9, 5, 'BLK-BLK', 'Matte Black/Gloss Black', 25, 1, NULL, 'matte', NULL, false),
(10, 5, 'RED-WHT', 'Viper Red/White', 5, 2, NULL, 'gloss', NULL, false),

-- Trek Domane
(11, 6, 'BLU-WHT', 'Azure Blue/White', 10, 2, NULL, 'gloss', NULL, true),
(12, 6, 'GRY-BLK', 'Lithium Grey/Black', 3, 1, NULL, 'matte', NULL, false),

-- Canyon Aeroad
(13, 12, 'BLK-BLK', 'Stealth Black', 25, 26, NULL, 'matte', NULL, true),
(14, 12, 'WHT-GLD', 'White/Gold', 2, 18, NULL, 'gloss', NULL, false),

-- Canyon Ultimate
(15, 13, 'BLU-BLK', 'Navy/Black', 9, 1, NULL, 'gloss', NULL, true),
(16, 13, 'GRN-BLK', 'British Racing Green', 13, 1, 18, 'gloss', NULL, false),

-- Canyon Grail
(17, 14, 'GRY-ORG', 'Earl Grey/Orange', 3, 17, NULL, 'matte', NULL, true),
(18, 14, 'BLK-LIM', 'Black/Lime', 1, 14, NULL, 'gloss', NULL, false)

ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Reset sequences
-- ============================================
SELECT setval('brands_id_seq', (SELECT COALESCE(MAX(id), 1) FROM brands));
SELECT setval('bike_types_id_seq', (SELECT COALESCE(MAX(id), 1) FROM bike_types));
SELECT setval('frame_size_systems_id_seq', (SELECT COALESCE(MAX(id), 1) FROM frame_size_systems));
SELECT setval('frame_sizes_id_seq', (SELECT COALESCE(MAX(id), 1) FROM frame_sizes));
SELECT setval('speed_configs_id_seq', (SELECT COALESCE(MAX(id), 1) FROM speed_configs));
SELECT setval('bike_catalog_id_seq', (SELECT COALESCE(MAX(id), 1) FROM bike_catalog));
SELECT setval('bike_catalog_colorways_id_seq', (SELECT COALESCE(MAX(id), 1) FROM bike_catalog_colorways));
