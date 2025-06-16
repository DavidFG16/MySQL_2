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