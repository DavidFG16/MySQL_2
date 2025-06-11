CREATE DATABASE practica;
USE practica;

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
('Queso Mozzarella', 100, 500),
('Salsa de Tomate', 200, 300),
('Pepperoni', 150, 600),
('Champiñones', 120, 400),
('Cebolla', 180, 200);

-- 5. Insert into combo (no foreign keys)
INSERT INTO `combo` (`nombre`, `precio`) VALUES
('Combo Pizza Familiar', 2000.00),
('Combo Pizza Personal', 1000.00),
('Combo Pizza y Bebida', 1500.00);

-- 6. Insert into cliente (no foreign keys)
INSERT INTO `cliente` (`nombre`, `telefono`, `direccion`) VALUES
('Juan Pérez', '12345678901', 'Calle Falsa 123, Ciudad'),
('María López', '98765432109', 'Avenida Siempre Viva 456, Ciudad'),
('Carlos Gómez', '55555555555', 'Boulevard Central 789, Ciudad');

-- 7. Insert into producto (depends on tipo_producto, only Pizza and Bebidas)
INSERT INTO `producto` (`nombre`, `precio`, `tipo_producto`) VALUES
('Pizza Margarita', 800.00, 1), -- Pizza
('Pizza Pepperoni', 900.00, 1), -- Pizza
('Coca-Cola', 150.00, 2), -- Bebida
('Agua Mineral', 100.00, 2); -- Bebida

-- 8. Insert into pedido (depends on cliente and metodo_pago)
INSERT INTO `pedido` (`fecha_recogida`, `total`, `cliente_id`, `metodo_pago_id`) VALUES
('2025-06-11 18:00:00', 1100.00, 1, 1),
('2025-06-11 19:30:00', 2000.00, 2, 2),
('2025-06-12 12:00:00', 1200.00, 3, 3);

-- 9. Insert into combo_producto (depends on combo and producto, only Pizza and Bebidas)
INSERT INTO `combo_producto` (`producto_id`, `combo_id`) VALUES
(1, 1), -- Pizza Margarita in Combo Pizza Familiar
(3, 1), -- Coca-Cola in Combo Pizza Familiar
(2, 2), -- Pizza Pepperoni in Combo Pizza Personal
(4, 2), -- Agua Mineral in Combo Pizza Personal
(1, 3), -- Pizza Margarita in Combo Pizza y Bebida
(3, 3); -- Coca-Cola in Combo Pizza y Bebida

-- 10. Insert into producto_presentacion (depends on producto and presentacion)
INSERT INTO `producto_presentacion` (`producto_id`, `presentacion_id`, `precio`) VALUES
(1, 1, 600), -- Pizza Margarita Pequeña
(1, 2, 800), -- Pizza Margarita Mediana
(1, 3, 1000), -- Pizza Margarita Grande
(2, 1, 700), -- Pizza Pepperoni Pequeña
(2, 2, 900), -- Pizza Pepperoni Mediana
(3, 4, 150), -- Coca-Cola Individual
(4, 4, 100); -- Agua Mineral Individual

-- 11. Insert into detalle_pedido (depends on pedido and producto, only Pizza and Bebidas)
INSERT INTO `detalle_pedido` (`cantidad`, `pedido_id`, `producto_id`) VALUES
(2, 1, 1), -- 2 Pizza Margarita in Pedido 1
(1, 1, 3), -- 1 Coca-Cola in Pedido 1
(1, 2, 2), -- 1 Pizza Pepperoni in Pedido 2
(2, 2, 3), -- 2 Coca-Cola in Pedido 2
(3, 3, 4); -- 3 Agua Mineral in Pedido 3

-- 12. Insert into ingredientes_extra (depends on detalle_pedido and ingrediente)
INSERT INTO `ingredientes_extra` (`cantidad`, `detalle_pedido`, `ingrediente_id`) VALUES
(1, 1, 3), -- Extra Pepperoni for Detalle Pedido 1 (Pizza Margarita)
(2, 1, 4), -- Extra Champiñones for Detalle Pedido 1 (Pizza Margarita)
(1, 2, 5); -- Extra Cebolla for Detalle Pedido 2 (Pizza Pepperoni)

-- 13. Insert into factura (depends on pedido and cliente)
INSERT INTO `factura` (`cliente`, `total`, `fecha`, `pedido_id`, `cliente_id`) VALUES
('Juan Pérez', 1100.00, '2025-06-11 18:30:00', 1, 1),
('María López', 2000.00, '2025-06-11 20:00:00', 2, 2),
('Carlos Gómez', 1200.00, '2025-06-12 12:30:00', 3, 3);

INSERT INTO `pedido` (`fecha_recogida`, `total`, `cliente_id`, `metodo_pago_id`) VALUES
('2025-06-12 13:00:00', 60000.00, 1, 1);
INSERT INTO `factura` (`cliente`, `total`, `fecha`, `pedido_id`, `cliente_id`) VALUES
('Juan Pérez', 60000.00, '2025-06-12 13:30:00', 4, 1);