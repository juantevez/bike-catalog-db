-- V7__seed_standard_colors.sql
-- Colores estándar para identificación visual de bicicletas

INSERT INTO standard_colors (id, name, name_es, hex_code, color_family, display_order) VALUES
-- Básicos
(1, 'Black', 'Negro', '#000000', 'neutral', 1),
(2, 'White', 'Blanco', '#FFFFFF', 'neutral', 2),
(3, 'Gray', 'Gris', '#808080', 'neutral', 3),
(4, 'Silver', 'Plata', '#C0C0C0', 'neutral', 4),

-- Rojos
(5, 'Red', 'Rojo', '#FF0000', 'red', 10),
(6, 'Dark Red', 'Rojo Oscuro', '#8B0000', 'red', 11),
(7, 'Burgundy', 'Borgoña', '#800020', 'red', 12),

-- Azules
(8, 'Blue', 'Azul', '#0000FF', 'blue', 20),
(9, 'Navy Blue', 'Azul Marino', '#000080', 'blue', 21),
(10, 'Light Blue', 'Celeste', '#87CEEB', 'blue', 22),
(11, 'Teal', 'Verde Azulado', '#008080', 'blue', 23),

-- Verdes
(12, 'Green', 'Verde', '#008000', 'green', 30),
(13, 'Dark Green', 'Verde Oscuro', '#006400', 'green', 31),
(14, 'Lime', 'Lima', '#32CD32', 'green', 32),
(15, 'Olive', 'Oliva', '#808000', 'green', 33),

-- Amarillos/Naranjas
(16, 'Yellow', 'Amarillo', '#FFFF00', 'yellow', 40),
(17, 'Orange', 'Naranja', '#FFA500', 'orange', 41),
(18, 'Gold', 'Dorado', '#FFD700', 'yellow', 42),

-- Violetas/Rosas
(19, 'Purple', 'Violeta', '#800080', 'purple', 50),
(20, 'Pink', 'Rosa', '#FFC0CB', 'pink', 51),
(21, 'Magenta', 'Magenta', '#FF00FF', 'pink', 52),

-- Marrones
(22, 'Brown', 'Marrón', '#8B4513', 'brown', 60),
(23, 'Tan', 'Beige', '#D2B48C', 'brown', 61),

-- Metálicos/Especiales
(24, 'Chrome', 'Cromado', '#E8E8E8', 'metallic', 70),
(25, 'Matte Black', 'Negro Mate', '#1C1C1C', 'metallic', 71),
(26, 'Carbon', 'Carbono', '#2F2F2F', 'metallic', 72)

ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    name_es = EXCLUDED.name_es,
    hex_code = EXCLUDED.hex_code,
    color_family = EXCLUDED.color_family,
    display_order = EXCLUDED.display_order;

-- Reset sequence
SELECT setval('standard_colors_id_seq', (SELECT MAX(id) FROM standard_colors));
