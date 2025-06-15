DELIMITER $$
DROP PROCEDURE IF EXISTS ps_top_ventas_pedidos_loop $$
CREATE PROCEDURE IF NOT EXISTS ps_top_ventas_pedidos_loop()
BEGIN
    DECLARE _total DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE _total_filas INT DEFAULT 0;
    DECLARE _fila INT DEFAULT 0;
    DECLARE _fila_offset INT DEFAULT 1;

    SET _total_filas = (SELECT COUNT(*) FROM pedido);

    -- SET _total = (SELECT total FROM pedido ORDER BY total DESC LIMIT 1);

    -- SELECT id AS Id_Pedido, total AS Total, IF(total >= 50000.00,'TOP','NO TOP') AS Status, _total as 'TOTAL_CAL' FROM pedido ORDER BY total DESC;

    ciclo : LOOP
       
        -- Traer datos
        SET _total = (SELECT total FROM pedido LIMIT _fila, _fila_offset);

        IF _total >= 50000 THEN
            SELECT id AS Id_Pedido, total AS Total, 'TOP' AS Status, _total as 'TOTAL_CAL' FROM pedido LIMIT _fila, _fila_offset;
        ELSE
            SELECT id AS Id_Pedido, total AS Total, 'NO TOP' AS Status, _total as 'TOTAL_CAL' FROM pedido LIMIT _fila, _fila_offset;
        END IF ;

        -- Incremento y fin del ciclo
        IF _total_filas > 0 AND (_fila  + 1) < _total_filas THEN
            SET _fila = _fila + 1;
        ELSE
            LEAVE ciclo ;
        END IF ;

    END LOOP ciclo;
END $$

DELIMITER ;

CALL ps_top_ventas_pedidos_loop();


DELIMITER $$
DROP PROCEDURE IF EXISTS ps_top_ventas_pedidos $$
CREATE PROCEDURE IF NOT EXISTS ps_top_ventas_pedidos()
BEGIN
    DECLARE _id INT DEFAULT 0;
    DECLARE _total DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE cursor_pedido CURSOR FOR SELECT id AS Id_Pedido, total AS Total FROM pedido ORDER BY total DESC;

    OPEN cursor_pedido;

    c_pedidos: LOOP
        FETCH cursor_pedido INTO _id, _total;

        IF _total >= 50000 THEN
            SELECT id AS Id_Pedido, total AS Total, 'TOP' AS Status FROM pedido WHERE id = _id;
        ELSE  
            SELECT id AS Id_Pedido, total AS Total, 'NO TOP' AS Status FROM pedido WHERE id = _id;
        END IF ;
    END LOOP c_pedidos;

    CLOSE cursor_pedido;

END $$

DELIMITER ;

CALL ps_top_ventas_pedidos();

SELECT * FROM pedido LIMIT 2, 1;



-- CURSOR SOLUCION
DELIMITER $$

DROP PROCEDURE IF EXISTS ps_top_ventas_pedidos $$
CREATE PROCEDURE ps_top_ventas_pedidos()
BEGIN
    DECLARE v_id INT DEFAULT 0;
    DECLARE v_total DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_done INT DEFAULT FALSE;

    DECLARE cursor_pedido CURSOR FOR SELECT id, total FROM pedido ORDER BY total DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    OPEN cursor_pedido;

    c_pedidos: LOOP
        FETCH cursor_pedido INTO v_id, v_total;
        IF v_done THEN
            LEAVE c_pedidos;
        END IF;
        
        IF v_total >= 50000 THEN
            SELECT v_id AS Id_Pedido, v_total AS Total, 'TOP' AS Status;
        ELSE
            SELECT v_id AS Id_Pedido, v_total AS Total, 'NO TOP' AS Status;
        END IF;
    END LOOP c_pedidos;

    CLOSE cursor_pedido;
END $$

DELIMITER ;

CALL ps_top_ventas_pedidos();

SELECT * FROM presentacion

DROP PROCEDURE IF EXISTS ps_actualizar_precio_productos

DELI    MITER //
CREATE PROCEDURE ps_actualizar_precio_productos(IN p_producto_id INT, IN p_nuevo_precio DECIMAL(10,2))
BEGIN
    DECLARE _pro_pre_id INT; -- Producto Presentacion Id
    DECLARE _c_update_pro INT DEFAULT 0;
    -- Validar el LOOP
    DECLARE done INT DEFAULT 0;
    DECLARE error_message VARCHAR(255) DEFAULT '';

    DECLARE cur_pro CURSOR FOR
        SELECT presentacion_id FROM producto_presentacion WHERE producto_id = p_producto_id AND presentacion_id <> 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Actualizar 
    UPDATE producto_presentacion SET precio = p_nuevo_precio WHERE producto_id = p_producto_id AND presentacion_id = 1;
    -- Validacion del UPDATE
    IF ROW_COUNT() <= 0 THEN 
            SET error_message = CONCAT('[40001]', 'No se encontro el producto');
            SIGNAL SQLSTATE VALUE '40001'
            SET MESSAGE_TEXT = error_message;
    ELSE

        OPEN cur_pro;
        leer_pro : LOOP 
            FETCH cur_pro INTO _pro_pre_id;
            -- Validar LOOP
            IF done THEN
                LEAVE leer_pro;
            END IF;

            UPDATE producto_presentacion 
            SET precio = p_nuevo_precio + (p_nuevo_precio*0.11) 
            WHERE producto_id = p_producto_id AND presentacion_id = _pro_pre_id;

            IF ROW_COUNT() > 0 THEN
                SET _c_update_pro = _c_update_pro + 1;
            END IF;

        END LOOP leer_pro;

        CLOSE cur_pro;

        IF ROW_COUNT() > 0 THEN
            SELECT 'Producto Actualizado' AS Message;
        ELSE
            SET error_message = CONCAT('[40001]','No se actualizo el precio de las otras presentaciones del producto');
            SIGNAL SQLSTATE VALUE '40001'
                SET MESSAGE_TEXT = error_message;
        END IF;

    END IF;

END //
DELIMITER //

CALL ps_actualizar_precio_productos(100, 3200);

SELECT * FROM producto_presentacion

DROP FUNCTION IF EXISTS fn_calcular_subtotal_pedido 

DELIMITER $$;

CREATE FUNCTION fn_calcular_subtotal_pedido(p_pedido_id INT)
RETURNS DECIMAL(10,2)
NOT DETERMINISTIC 
READS SQL DATA
BEGIN
    DECLARE v_combo DECIMAL(10,2);
    DECLARE v_producto DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);

    SELECT SUM(dp.cantidad * pp.precio) INTO v_producto
    FROM detalle_pedido AS dp
    INNER JOIN detalle_pedido_producto AS dpp ON dp.id = dpp.detalle_id
    INNER JOIN producto AS p ON dpp.producto_id = p.id
    INNER JOIN producto_presentacion AS pp ON p.id = pp.producto_id
    WHERE dp.pedido_id = p_pedido_id AND pp.presentacion_id = 1;
    
    SELECT SUM(dp.cantidad * c.precio) INTO v_combo
    FROM detalle_pedido AS dp
    INNER JOIN detalle_pedido_combo AS dpc ON dp.id = dpc.detalle_id
    INNER JOIN combo AS c ON dpc.combo_id = c.id
    WHERE dp.pedido_id = p_pedido_id;

    SET v_total = (v_combo + v_producto);
    RETURN (v_total);
END $$

DELIMITER ;


SELECT fn_calcular_subtotal_pedido(1) AS CasiTotal


DELIMITER $$;

CREATE FUNCTION fn_id_unico_factura(f_factura_id INT)
RETURNS DECIMAL(10,2)
NOT DETERMINISTIC 
READS SQL DATA
BEGIN
    DECLARE codigo 

    FLOOR

    RETURN
END $$

DELIMITER ;

SELECT FLOOR(RAND() * 10) AS numero_aleatorio;



-- Ejercicios Taller 
-- **`ps_add_pizza_con_ingredientes`**
-- Crea un procedimiento que inserte una nueva pizza en la tabla `pizza` junto con sus ingredientes en `pizza_ingrediente`.

-- - Parámetros de entrada: `p_nombre_pizza`, `p_precio`, lista de `p_ids_ingredientes`.
-- - Debe recorrer la lista de ingredientes (cursor o ciclo) y hacer los inserts correspondients.



-- **`ps_actualizar_precio_pizza`**
-- Procedimiento que reciba `p_pizza_id` y `p_nuevo_precio` y actualice el precio.

-- - Antes de actualizar, valide con un `IF` que el nuevo precio sea mayor que 0; de lo contrario, lance un `SIGNAL`.   
DELIMITER //

CREATE PROCEDURE ps_actualizar_precio_pizza (
    IN p_pizza_id INT,
    IN p_presentacion_id INT,
    IN p_nuevo_precio DECIMAL(10,2)
)
BEGIN
    -- Validar que el nuevo precio sea mayor a 0
    IF p_nuevo_precio <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio debe ser mayor que 0';
    END IF;

    -- Actualizar el precio en la tabla producto_presentacion
    UPDATE producto_presentacion
    SET precio = p_nuevo_precio
    WHERE producto_id = p_pizza_id AND presentacion_id = p_presentacion_id;

    -- Verificar si se actualizó alguna fila
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró la pizza o presentación especificada';
    END IF;
END //

DELIMITER ;

CALL ps_actualizar_precio_pizza(2, 1, 12.50);


SELECT p.nombre AS nombre_pizza, pr.nombre AS presentacion, pp.precio
FROM producto_presentacion pp
JOIN producto p ON pp.producto_id = p.id
JOIN presentacion pr ON pp.presentacion_id = pr.id
WHERE pp.producto_id = 2 AND pp.presentacion_id = 1;


------------------------------------------------------------------------------------

-- **`ps_generar_pedido`** *(**usar TRANSACTION**)*
-- Procedimiento que reciba:

-- - `p_cliente_id`,
-- - una lista de pizzas y cantidades (`p_items`),
-- - `p_metodo_pago_id`.
--   **Dentro de una transacción**:

-- 1. Inserta en `pedido`.
-- 2. Para cada ítem, inserta en `detalle_pedido` y en `detalle_pedido_pizza`.
-- 3. Si todo va bien, hace `COMMIT`; si falla, `ROLLBACK` y devuelve un mensaje de error.
DELIMITER //

CREATE PROCEDURE ps_generar_pedido (
    IN p_cliente_id INT,
    IN p_metodo_pago_id INT
    -- Aquí definiremos cómo pasar p_items, probablemente usando una tabla temporal
)
BEGIN
    -- Declarar variables necesarias (e.g., para almacenar el nuevo pedido_id)
    DECLARE v_pedido_id INT;
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Si hay error, deshacer cambios y lanzar mensaje
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al generar el pedido';
    END;

    -- Paso 1: Validar que cliente_id y metodo_pago_id existan
    -- (Aquí harías una consulta para verificar)

    -- Paso 2: Insertar en la tabla pedido
    -- (Calcular total y usar NOW() para fecha_recogida)

    -- Paso 3: Obtener el ID del pedido recién creado
    -- (Usar LAST_INSERT_ID())

    -- Paso 4: Iterar sobre los ítems (p_items)
    -- (Insertar en detalle_pedido y detalle_pedido_producto para cada ítem)

    -- Paso 5: Confirmar transacción si todo sale bien
    COMMIT;
END //

DELIMITER ;
Explicación de l












