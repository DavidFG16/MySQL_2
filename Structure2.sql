CREATE DATABASE profe_database

USE profe_database;

 CREATE TABLE `cliente`(
    `id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(11) NOT NULL,
    `direccion` VARCHAR(150) NOT NULL
);
CREATE TABLE `producto`(
    `id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `tipo_producto_id` INT NOT NULL
);
CREATE TABLE `combo`(
    `id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `precio` DECIMAL(10, 2) NOT NULL
);
CREATE TABLE `detalle_pedido`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cantidad` INT NOT NULL,
    `pedido_id` INT NOT NULL
);
CREATE TABLE `factura`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cliente` VARCHAR(100) NOT NULL,
    `total` DECIMAL(10, 2) NOT NULL,
    `fecha` DATETIME NOT NULL,
    `pedido_id` INT NOT NULL,
    `cliente_id` INT NOT NULL
);
CREATE TABLE `pedido`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `fecha_recogida` DATETIME NOT NULL,
    `total` DECIMAL(10, 2) NOT NULL,
    `cliente_id` INT NOT NULL,
    `metodo_pago_id` INT NOT NULL
);
CREATE TABLE `metodo_pago`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
);
CREATE TABLE `ingredientes_extra`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cantidad` INT NOT NULL,
    `detalle_pedido_id` INT NOT NULL,
    `ingrediente_id` INT NOT NULL
);
CREATE TABLE `tipo_producto`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
);
CREATE TABLE `combo_producto`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `producto_id` INT NOT NULL,
    `combo_id` INT NOT NULL
);
CREATE TABLE `presentacion`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL
);
CREATE TABLE `ingrediente`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `stock` INT NOT NULL,
    `precio` DECIMAL(10, 2) NOT NULL
);
CREATE TABLE `producto_presentacion`(
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `producto_id` INT NOT NULL,
    `presentacion_id` INT NOT NULL,
    `precio` DECIMAL(10, 2) NOT NULL
);
CREATE TABLE `detalle_pedido_producto`(
    `detalle_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `producto_id` INT NOT NULL
);
CREATE TABLE `detalle_pedido_combo`(
    `detalle_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `combo_id` INT NOT NULL
);
ALTER TABLE
    `ingredientes_extra` ADD CONSTRAINT `ingredientes_extra_ingrediente_id_foreign` FOREIGN KEY(`ingrediente_id`) REFERENCES `ingrediente`(`id`);
ALTER TABLE
    `detalle_pedido_combo` ADD CONSTRAINT `detalle_pedido_combo_detalle_id_foreign` FOREIGN KEY(`detalle_id`) REFERENCES `detalle_pedido`(`id`);
ALTER TABLE
    `producto` ADD CONSTRAINT `producto_tipo_producto_id_foreign` FOREIGN KEY(`tipo_producto_id`) REFERENCES `tipo_producto`(`id`);
ALTER TABLE
    `detalle_pedido_producto` ADD CONSTRAINT `detalle_pedido_producto_detalle_id_foreign` FOREIGN KEY(`detalle_id`) REFERENCES `detalle_pedido`(`id`);
ALTER TABLE
    `detalle_pedido_combo` ADD CONSTRAINT `detalle_pedido_combo_combo_id_foreign` FOREIGN KEY(`combo_id`) REFERENCES `combo`(`id`);
ALTER TABLE
    `pedido` ADD CONSTRAINT `pedido_metodo_pago_id_foreign` FOREIGN KEY(`metodo_pago_id`) REFERENCES `metodo_pago`(`id`);
ALTER TABLE
    `factura` ADD CONSTRAINT `factura_cliente_id_foreign` FOREIGN KEY(`cliente_id`) REFERENCES `cliente`(`id`);
ALTER TABLE
    `combo_producto` ADD CONSTRAINT `combo_producto_producto_id_foreign` FOREIGN KEY(`producto_id`) REFERENCES `producto`(`id`);
ALTER TABLE
    `factura` ADD CONSTRAINT `factura_pedido_id_foreign` FOREIGN KEY(`pedido_id`) REFERENCES `pedido`(`id`);
ALTER TABLE
    `detalle_pedido_producto` ADD CONSTRAINT `detalle_pedido_producto_producto_id_foreign` FOREIGN KEY(`producto_id`) REFERENCES `producto`(`id`);
ALTER TABLE
    `detalle_pedido` ADD CONSTRAINT `detalle_pedido_pedido_id_foreign` FOREIGN KEY(`pedido_id`) REFERENCES `pedido`(`id`);
ALTER TABLE
    `producto_presentacion` ADD CONSTRAINT `producto_presentacion_presentacion_id_foreign` FOREIGN KEY(`presentacion_id`) REFERENCES `presentacion`(`id`);
ALTER TABLE
    `producto_presentacion` ADD CONSTRAINT `producto_presentacion_producto_id_foreign` FOREIGN KEY(`producto_id`) REFERENCES `producto`(`id`);
ALTER TABLE
    `ingredientes_extra` ADD CONSTRAINT `ingredientes_extra_detalle_pedido_id_foreign` FOREIGN KEY(`detalle_pedido_id`) REFERENCES `detalle_pedido`(`id`);
ALTER TABLE
    `combo_producto` ADD CONSTRAINT `combo_producto_combo_id_foreign` FOREIGN KEY(`combo_id`) REFERENCES `combo`(`id`);