-- Crear la base de datos
CREATE DATABASE tiendamangas;
USE tiendamangas;

-- Tabla de géneros de manga
CREATE TABLE generos (
    id_genero      INT PRIMARY KEY AUTO_INCREMENT,
    nombre         VARCHAR(100) NOT NULL,
    descripcion    TEXT
) ENGINE = INNODB;

-- Tabla de mangas
CREATE TABLE mangas (
    id_manga       INT PRIMARY KEY AUTO_INCREMENT,
    titulo         VARCHAR(255) NOT NULL,
    autor          VARCHAR(255) NOT NULL,
    editorial      VARCHAR(255),
    año_publicacion INT,
    volumen        INT,  -- Para indicar el número del volumen
    precio         DECIMAL(10, 2) NOT NULL,
    stock          INT NOT NULL,
    id_genero      INT,
    FOREIGN KEY (id_genero) REFERENCES generos(id_genero) -- Relación con la tabla generos
) ENGINE = INNODB;

-- Tabla de clientes
CREATE TABLE clientes (
    id_cliente     INT PRIMARY KEY AUTO_INCREMENT,
    nombre         VARCHAR(100) NOT NULL,
    apellido       VARCHAR(100) NOT NULL,
    email          VARCHAR(100) UNIQUE NOT NULL,
    telefono       VARCHAR(20),
    direccion      TEXT
) ENGINE = INNODB;

-- Tabla de pedidos
CREATE TABLE pedidos (
    id_pedido      INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente     INT NOT NULL,
    fecha_pedido   DATE NOT NULL,
    total          DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) -- Relación con la tabla clientes
) ENGINE = INNODB;

-- Tabla de detalle de pedidos
CREATE TABLE detalle_pedido (
    id_detalle     INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido      INT NOT NULL,
    id_manga       INT NOT NULL,
    cantidad       INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_manga) REFERENCES mangas(id_manga) -- Relación con la tabla mangas
) ENGINE = INNODB;

INSERT INTO generos (nombre, descripcion)
VALUES 
('Shonen', 'Mangas dirigidos principalmente a un público joven masculino'),
('Shojo', 'Mangas dirigidos principalmente a un público joven femenino'),
('Seinen', 'Mangas dirigidos a un público adulto masculino'),
('Josei', 'Mangas dirigidos a un público adulto femenino');

INSERT INTO mangas (titulo, autor, editorial, año_publicacion, volumen, precio, stock, id_genero)  VALUES
('Naruto', 'Masashi Kishimoto', 'Shueisha', 1999, 72, 10.99, 50, 1), 
('Sailor Moon', 'Naoko Takeuchi', 'Kodansha', 1991, 18, 8.99, 30, 2), 
('Attack on Titan', 'Hajime Isayama', 'Kodansha', 2009, 34, 12.99, 40, 3), 
('Nana', 'Ai Yazawa', 'Shueisha', 2000, 21, 9.99, 20, 4);

INSERT INTO clientes (nombre, apellido, email, telefono, direccion) VALUES
('Juan', 'Pérez', 'juan.perez@email.com', '555-1234', 'Calle Ficticia 123, Ciudad');

INSERT INTO pedidos (id_cliente, fecha_pedido, total) VALUES
(1, '2025-04-28', 21.98);

INSERT INTO detalle_pedido (id_pedido, id_manga, cantidad, precio_unitario) VALUES
(1, 1, 2, 10.99),  
(1, 2, 1, 8.99),
(1, 4, 1, 9.99);

SELECT p.id_pedido, c.nombre AS cliente, m.titulo, dp.cantidad, dp.precio_unitario
FROM detalle_pedido dp
JOIN pedidos p ON dp.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN mangas m ON dp.id_manga = m.id_manga
WHERE p.id_pedido = 1;