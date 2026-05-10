-- DESAFÍO PRÁCTICO 2 - SQL
-- Estudiante: Elias
-- Profesor: Julio Castillo

-- Preparación del entorno de trabajo
DROP DATABASE IF EXISTS TiendaRopa_Sucre;
CREATE DATABASE TiendaRopa_Sucre;
USE TiendaRopa_Sucre;

-- Definición de la estructura de tablas (DDL)

-- Registro de datos personales y de contacto de los clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(100),
    correo VARCHAR(100),
    telefono VARCHAR(20)
) ENGINE=InnoDB;

-- Catálogo de productos, precios y disponibilidad de inventario
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion TEXT,
    precio DECIMAL(10,2),
    categoria VARCHAR(50),
    stock INT
) ENGINE=InnoDB;

-- Gestión de pedidos realizados por los clientes
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    estado VARCHAR(20),
    total DECIMAL(10,2),
    CONSTRAINT fk_cliente_pedido FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
) ENGINE=InnoDB;

-- Detalle de artículos vendidos en cada pedido
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_venta DECIMAL(10,2),
    CONSTRAINT fk_pedido_venta FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_producto_venta FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) ENGINE=InnoDB;

-- Inserción de registros iniciales para pruebas (DML)
INSERT INTO clientes VALUES 
(1, 'Elias', 'Guerreiro', 'Barquisimeto', 'elias@mail.com', '0412-1234567'),
(2, 'Maria', 'Perez', 'Cabudare', 'maria@mail.com', '0424-7654321');

INSERT INTO productos VALUES 
(10, 'Camiseta Blanca', 'Algodón 100%', 20.00, 'Camisetas', 50),
(11, 'Jean Blue', 'Denim Slim Fit', 40.00, 'Pantalones', 30);

INSERT INTO pedidos VALUES 
(101, 1, CURDATE(), 'Completado', 22.00), -- Pedido reciente
(102, 2, '2025-01-01', 'Pendiente', 40.00); -- Pedido antiguo

INSERT INTO ventas VALUES 
(501, 101, 10, 1, 22.00);

-- Bloque de Consultas y Operaciones Avanzadas

-- Identificación de clientes activos con actividad en los últimos 30 días
SELECT DISTINCT c.nombre, c.apellido, c.direccion, c.correo 
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Ajuste inflacionario: incremento del 10% en la categoría de Camisetas
UPDATE productos 
SET precio = precio * 1.10 
WHERE categoria = 'Camisetas';

-- Depuración de registros: eliminación de pedidos que no generaron ventas
DELETE FROM pedidos 
WHERE id_pedido NOT IN (SELECT id_pedido FROM ventas);

-- Optimización de acceso a datos mediante una Vista Relacional
CREATE VIEW vista_clientes_pedidos AS
SELECT CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo, p.fecha, p.total
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- Verificación de la vista generada
SELECT * FROM vista_clientes_pedidos;