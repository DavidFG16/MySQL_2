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
SQL SECURITY INVOKER
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

CALL ps_actualizar_precio_productos(1, 3200);

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


DROP FUNCTION IF EXISTS fn_id_unico_factura

CREATE FUNCTION fn_id_unico_factura()
RETURNS VARCHAR(11)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE codigo VARCHAR(11); -- Almacena el ID (FACT-######)
    DECLARE existe INT; -- Verifica si el código ya existe

    -- Bucle para generar un ID único
    REPEAT
        -- Generar número aleatorio de 6 dígitos con prefijo FACT-
        SET codigo = CONCAT('FACT-', LPAD(FLOOR(RAND() * 1000000), 6, '0'));
        -- Verificar si ya existe en la tabla factura
        SELECT COUNT(*) INTO existe
        FROM factura
        WHERE id = codigo;
    UNTIL existe = 0
    END REPEAT;

    -- Devolver el ID único
    RETURN codigo;
END $$

DELIMITER ;

SELECT * FROM factura;
--------------------------------------------------------------------------------








-- Usuario y Seguridad en MySQL

-- Se esta creando con un Plugin - Default => caching_sha2_password
|
CREATE USER 'vendedor'@'localhost' IDENTIFIED BY 'v3nD3d0r.';

GRANT SELECT ON pizzas.* TO 'vendedor'@'localhost';

GRANT INSERT, UPDATE ON pizzas.cliente TO 'vendedor'@'localhost';

GRANT INSERT, UPDATE ON pizzas.pedido TO 'vendedor'@'localhost';

GRANT INSERT, UPDATE ON pizzas.detalle_pedido TO 'vendedor'@'localhost';

GRANT INSERT, UPDATE ON pizzas.detalle_pedido_producto TO 'vendedor'@'localhost';

GRANT INSERT, UPDATE ON pizzas.detalle_pedido_combo TO 'vendedor'@'localhost';

GRANT INSERT ON pizzas.factura TO 'vendedor'@'localhost';

GRANT DELETE ON pizzas.pedido TO 'vendedor'@'localhost';

-- Procedimientos EXECUTE => Para procedimientos de almacenado y Funciones definidas por el usuario
GRANT EXECUTE ON PROCEDURE pizzas.ps_actualizar_precio_productos TO 'vendedor'@'localhost';

GRANT EXECUTE ON FUNCTION pizzas.fn_calcular_subtotal_pedido TO 'vendedor'@'localhost';

REVOKE SELECT ON pizzas.* FROM 'vendedor'@'localhost';

SHOW GRANTS FOR 'vendedor'@'localhost'

FLUSH PRIVILEGES

----------------------------------------------------------------------------------
CREATE USER 'analista'@'localhost' IDENTIFIED WITH sha256_password BY 'aN@l1sta.'

-----------------------------------------------------------------------------------
-- INYECCION SQL

'SELECT * FROM users WHERE email = '+email+'\ AND password ='+1234''

-- Evitar INYECCION SQL

PREPARE stm FROM 'SELECT * FROM cliente WHERE telefono = ?';

SET @id = '30012345671234\\';

EXECUTE stm USING @telefono;

DEALLOCATE PREPARE stm

-- LIMITE DE QUERIES POR HORA 
ALTER USER 'analista'@'localhost' WITH MAX_QUERIES_PER_HOUR 6;







