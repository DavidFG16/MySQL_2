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