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

DELIMITER //
CREATE PROCEDURE ps_actualizar_precio_productos(IN p_producto_id INT, IN p_nuevo_precio DECIMAL(10,2))
BEGIN
    DECLARE _pro_pre_id INT; -- Producto Presentacion Id
    DECLARE _rows_loop INT DEFAULT 0;
    DECLARE _counter_loop INT DEFAULT 0;

    DECLARE cur_pro CURSOR FOR
        SELECT presentacion_id FROM producto_presentacion WHERE producto_id = p_producto_id AND presentacion_id <> 1;

    -- Actualizar 
    UPDATE producto_presentacion SET precio = p_nuevo_precio WHERE producto_id = p_producto_id AND presentacion_id = 1;
    -- Validacion del UPDATE
    IF ROW_COUNT() <= 0 THEN 
        SELECT 'No se encontro el producto' AS Error;
    ELSE
        -- Asignar la cantidad de filas o registros Para el loop 
        SET _rows_loop = (SELECT COUNT(*) FROM producto_presentacion WHERE producto_id = p_producto_id AND presentacion_id <> 1);

        OPEN cur_pro;
        leer_pro : LOOP 
            FETCH cur_pro INTO _pro_pre_id;
            SET _counter_loop = _counter_loop +1;

            UPDATE producto_presentacion 
            SET precio = p_nuevo_precio + (p_nuevo_precio * 0.11)
            WHERE producto_id = p_producto_id AND presentacion_id = _pro_pre_id;

            -- Validar LOOP
            IF _counter_loop >= _rows_loop THEN
                LEAVE leer_pro;
            END IF;

        END LOOP leer_pro;

        CLOSE cur_pro;

        IF ROW_COUNT() > 0 THEN
            SELECT 'Producto Actualizado' AS Message;
        ELSE
            SELECT 'No se actualizo el precio de las otras presentaciones del producto' AS Error;
        END IF;

    END IF;

END //
DELIMITER //

CALL ps_actualizar_precio_productos(1, 3000);

SELECT * FROM producto_presentacion