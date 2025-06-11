CREATE DATABASE practica;

USE practica;



CREATE TABLE `cliente`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(11) NOT NULL,
    `direccion` VARCHAR(150) NOT NULL
);

CREATE TABLE `combo_producto`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `producto_id` BIGINT NOT NULL,
    `combo_id` BIGINT NOT NULL
);

CREATE TABLE `detalle_pedido`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cantidad` BIGINT NOT NULL,
    `pedido_id` BIGINT NOT NULL,
    `producto_id` BIGINT NOT NULL
);

CREATE TABLE `metodo_pago`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
);

CREATE TABLE `factura`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cliente` VARCHAR(100) NOT NULL,
    `total` DECIMAL(10, 2) NOT NULL,
    `fecha` DATETIME NOT NULL,
    `pedido_id` BIGINT NOT NULL,
    `cliente_id` BIGINT NOT NULL
);

CREATE TABLE `tipo_producto`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
);

CREATE TABLE `presentacion`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
);

CREATE TABLE `producto`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(50) NOT NULL,
    `precio` DECIMAL(10, 2) NOT NULL,
    `tipo_producto` BIGINT NOT NULL
);

CREATE TABLE `pedido`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `fecha_recogida` DATETIME NOT NULL, 
    `total` DECIMAL(10, 2) NOT NULL,
    `cliente_id` BIGINT NOT NULL,
    `metodo_pago_id` BIGINT NOT NULL
);

CREATE TABLE `ingredientes_extra`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cantidad` BIGINT NOT NULL,
    `detalle_pedido` BIGINT NOT NULL,
    `ingrediente_id` BIGINT NOT NULL
);

CREATE TABLE `combo`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(50) NOT NULL,
    `precio` DECIMAL(8, 2) NOT NULL
);

CREATE TABLE `ingrediente`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL, 
    `stock` BIGINT NOT NULL,
    `precio` BIGINT NOT NULL
);

CREATE TABLE `producto_presentacion`(
    `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `producto_id` BIGINT NOT NULL,
    `presentacion_id` BIGINT NOT NULL,
    `precio` BIGINT NOT NULL
);


ALTER TABLE
    `ingredientes_extra` ADD CONSTRAINT `ingredientes_extra_detalle_pedido_foreign` FOREIGN KEY(`detalle_pedido`) REFERENCES `detalle_pedido`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `ingredientes_extra` ADD CONSTRAINT `ingredientes_extra_ingrediente_id_foreign` FOREIGN KEY(`ingrediente_id`) REFERENCES `ingrediente`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `pedido` ADD CONSTRAINT `pedido_metodo_pago_id_foreign` FOREIGN KEY(`metodo_pago_id`) REFERENCES `metodo_pago`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE
    `producto_presentacion` ADD CONSTRAINT `producto_presentacion_producto_id_foreign` FOREIGN KEY(`producto_id`) REFERENCES `producto`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `detalle_pedido` ADD CONSTRAINT `detalle_pedido_producto_id_foreign` FOREIGN KEY(`producto_id`) REFERENCES `producto`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `factura` ADD CONSTRAINT `factura_cliente_id_foreign` FOREIGN KEY(`cliente_id`) REFERENCES `cliente`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `producto_presentacion` ADD CONSTRAINT `producto_presentacion_presentacion_id_foreign` FOREIGN KEY(`presentacion_id`) REFERENCES `presentacion`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `detalle_pedido` ADD CONSTRAINT `detalle_pedido_pedido_id_foreign` FOREIGN KEY(`pedido_id`) REFERENCES `pedido`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `combo_producto` ADD CONSTRAINT `combo_producto_producto_id_foreign` FOREIGN KEY(`producto_id`) REFERENCES `producto`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `factura` ADD CONSTRAINT `factura_pedido_id_foreign` FOREIGN KEY(`pedido_id`) REFERENCES `pedido`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `producto` ADD CONSTRAINT `producto_tipo_producto_foreign` FOREIGN KEY(`tipo_producto`) REFERENCES `tipo_producto`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `pedido` ADD CONSTRAINT `pedido_cliente_id_foreign` FOREIGN KEY(`cliente_id`) REFERENCES `cliente`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE
    `combo_producto` ADD CONSTRAINT `combo_producto_combo_id_foreign` FOREIGN KEY(`combo_id`) REFERENCES `combo`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;