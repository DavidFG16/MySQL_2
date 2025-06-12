CREATE DATABASE profe_database;
USE profe_database;

-- 1. Insert into tipo_producto (no foreign keys, only Pizza and Bebidas)
INSERT INTO `tipo_producto` (`nombre`) VALUES
('Pizza'),
('Bebidas');

-- 2. Insert into presentacion (no foreign keys)
INSERT INTO `presentacion` (`nombre`) VALUES
('Pequeña'),
('Mediana'),
('Grande'),
('Individual');

-- 3. Insert into metodo_pago (no foreign keys)
INSERT INTO `metodo_pago` (`nombre`) VALUES
('Efectivo'),
('Tarjeta de Crédito'),
('Transferencia'),
('PayPal');

-- 4. Insert into ingrediente (no foreign keys)
INSERT INTO `ingrediente` (`nombre`, `stock`, `precio`) VALUES
('Queso Mozzarella', 100, 5.00),
('Salsa de Tomate', 200, 3.00),
('Pepperoni', 150, 6.00),
('Champiñones', 120, 4.00),
('Cebolla', 180, 2.00);

-- 5. Insert into combo (no foreign keys)
INSERT INTO `combo` (`nombre`, `precio`) VALUES
('Combo Pizza Familiar', 20.00),
('Combo Pizza Personal', 10.00),
('Combo Pizza y Bebida', 15.00);

-- 6. Insert into cliente (no foreign keys)
INSERT INTO `cliente` (`nombre`, `telefono`, `direccion`) VALUES
('Juan Pérez', '12345678901', 'Calle Falsa 123, Ciudad'),
('María López', '98765432109', 'Avenida Siempre Viva 456, Ciudad'),
('Carlos Gómez', '55555555555', 'Boulevard Central 789, Ciudad');

-- 7. Insert into producto (depends on tipo_producto, only Pizza and Bebidas)
INSERT INTO `producto` (`nombre`, `tipo_producto_id`) VALUES
('Pizza Margarita', 1), -- Pizza
('Pizza Pepperoni', 1), -- Pizza
('Coca-Cola', 2), -- Bebida
('Agua Mineral', 2); -- Bebida

-- 8. Insert into producto_presentacion (depends on producto and presentacion)
INSERT INTO `producto_presentacion` (`producto_id`, `presentacion_id`, `precio`) VALUES
(1, 1, 6.00), -- Pizza Margarita Pequeña
(1, 2, 8.00), -- Pizza Margarita Mediana
(1, 3, 10.00), -- Pizza Margarita Grande
(2, 1, 7.00), -- Pizza Pepperoni Pequeña
(2, 2, 9.00), -- Pizza Pepperoni Mediana
(3, 4, 1.50), -- Coca-Cola Individual
(4, 4, 1.00); -- Agua Mineral Individual

-- 9. Insert into combo_producto (depends on combo and producto)
INSERT INTO `combo_producto` (`producto_id`, `combo_id`) VALUES
(1, 1), -- Pizza Margarita in Combo Pizza Familiar
(3, 1), -- Coca-Cola in Combo Pizza Familiar
(2, 2), -- Pizza Pepperoni in Combo Pizza Personal
(4, 2), -- Agua Mineral in Combo Pizza Personal
(1, 3), -- Pizza Margarita in Combo Pizza y Bebida
(3, 3); -- Coca-Cola in Combo Pizza y Bebida

-- 10. Insert into pedido (depends on cliente and metodo_pago)
INSERT INTO `pedido` (`fecha_recogida`, `total`, `cliente_id`, `metodo_pago_id`) VALUES
('2025-06-12 18:00:00', 11.00, 1, 1), -- 2 Pizza Margarita Pequeña + 1 Coca-Cola
('2025-06-12 19:30:00', 20.00, 2, 2), -- 1 Combo Pizza Familiar
('2025-06-12 12:00:00', 3.00, 3, 3); -- 3 Agua Mineral

-- 11. Insert into detalle_pedido (depends on pedido)
INSERT INTO `detalle_pedido` (`cantidad`, `pedido_id`) VALUES
(2, 1), -- 2 Pizza Margarita Pequeña
(1, 1), -- 1 Coca-Cola
(1, 2), -- 1 Combo Pizza Familiar
(3, 3); -- 3 Agua Mineral

-- 12. Insert into detalle_pedido_producto (depends on detalle_pedido and producto)
INSERT INTO `detalle_pedido_producto` (`detalle_id`, `producto_id`) VALUES
(1, 1), -- Detalle 1: Pizza Margarita
(2, 3); -- Detalle 2: Coca-Cola

-- 13. Insert into detalle_pedido_combo (depends on detalle_pedido and combo)
INSERT INTO `detalle_pedido_combo` (`detalle_id`, `combo_id`) VALUES
(3, 1); -- Detalle 3: Combo Pizza Familiar

-- 14. Insert into ingredientes_extra (depends on detalle_pedido and ingrediente)
INSERT INTO `ingredientes_extra` (`cantidad`, `detalle_pedido_id`, `ingrediente_id`) VALUES
(1, 1, 3), -- Extra Pepperoni for Pizza Margarita (Detalle 1)
(2, 1, 4); -- Extra Champiñones for Pizza Margarita (Detalle 1)

-- 15. Insert into factura (depends on pedido and cliente)
INSERT INTO `factura` (`cliente`, `total`, `fecha`, `pedido_id`, `cliente_id`) VALUES
('Juan Pérez', 11.00, '2025-06-12 18:30:00', 1, 1),
('María López', 20.00, '2025-06-12 20:00:00', 2, 2),
('Carlos Gómez', 3.00, '2025-06-12 12:30:00', 3, 3);