-- 2. Asegurar que exista la Provincia (admin_level_1)
-- Usamos 'PROVINCE' como tipo según tu check constraint
INSERT INTO admin_level_1 (id, country_id, name, type, iso_code)
VALUES (1, 1, 'Buenos Aires', 'PROVINCE', 'AR-B')
ON CONFLICT (id) DO NOTHING;

-- 3. Insertar Partidos (admin_level_2) vinculados a la provincia (ID: 1)
INSERT INTO admin_level_2 (id, admin_level_1_id, name, type) VALUES
(1, 1, 'La Matanza', 'PARTIDO'),
(2, 1, 'Morón', 'PARTIDO'),
(3, 1, 'Tres de Febrero', 'PARTIDO'),
(4, 1, 'Lomas de Zamora', 'PARTIDO'),
(5, 1, 'Quilmes', 'PARTIDO'),
(6, 1, 'Lanús', 'PARTIDO'),
(7, 1, 'General San Martín', 'PARTIDO'),
(8, 1, 'Vicente López', 'PARTIDO'),
(9, 1, 'San Isidro', 'PARTIDO'),
(10, 1, 'Tigre', 'PARTIDO')
ON CONFLICT (id) DO NOTHING;

-- 4. Insertar Localidades (localities)
INSERT INTO localities (admin_level_2_id, name, type, postal_code) VALUES
(1, 'San Justo', 'CITY', '1754'),
(1, 'Ramos Mejía', 'CITY', '1704'),
(2, 'Morón', 'CITY', '1708'),
(2, 'Castelar', 'CITY', '1712'),
(3, 'Caseros', 'CITY', '1678'),
(4, 'Lomas de Zamora', 'CITY', '1832'),
(5, 'Quilmes', 'CITY', '1878'),
(6, 'Lanús West', 'CITY', '1824'),
(7, 'Villa Ballester', 'CITY', '1653'),
(8, 'Olivos', 'CITY', '1636'),
(9, 'San Isidro', 'CITY', '1642'),
(10, 'Tigre', 'CITY', '1648');
