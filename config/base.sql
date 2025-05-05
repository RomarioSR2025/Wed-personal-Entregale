CREATE DATABASE tiendamangas;
USE tiendamangas;


CREATE TABLE IF NOT EXISTS mangas (
    idmanga      INT AUTO_INCREMENT PRIMARY KEY,
    titulo       VARCHAR(100) NOT NULL,
    autor        VARCHAR(100) NOT NULL,
    genero       VARCHAR(50),
    volumen      INT,
    precio       DECIMAL(10, 2) NOT NULL,
    stock        INT NOT NULL,
    tipo_manga   ENUM('Shonen', 'Shojo', 'Seinen', 'Josei', 'Kodomo') DEFAULT 'Shonen',  -- Agregamos columna para tipo de manga
    CONSTRAINT uk_titulo_vol UNIQUE (titulo, volumen)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS clientes (
    idcliente    INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL,
    apellido     VARCHAR(50) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    telefono     VARCHAR(20),
    direccion    VARCHAR(200),
    tipo_cliente ENUM('Regular', 'VIP', 'Nuevo') DEFAULT 'Regular'  -- Agregamos columna para tipo de cliente
) ENGINE = INNODB;


CREATE TABLE IF NOT EXISTS pedidos (
    idpedido     INT AUTO_INCREMENT PRIMARY KEY,
    idcliente    INT NOT NULL,
    idmanga      INT NOT NULL,
    cantidad     INT NOT NULL,
    fecha        DATE NOT NULL,
    precio_unit  DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (idcliente) REFERENCES clientes(idcliente),
    CONSTRAINT fk_pedido_manga FOREIGN KEY (idmanga) REFERENCES mangas(idmanga)
) ENGINE = INNODB;

 ALTER TABLE pedidos ADD COLUMN precio_total DECIMAL(10,2) NOT NULL AFTER precio_unit;


INSERT INTO mangas (titulo, autor, genero, volumen, precio, stock, tipo_manga) VALUES
    ('Naruto', 'Masashi Kishimoto', 'Shonen', 1, 10.99, 50, 'Shonen'),
    ('Sailor Moon', 'Naoko Takeuchi', 'Shojo', 1, 8.99, 30, 'Shojo'),
    ('Attack on Titan', 'Hajime Isayama', 'Seinen', 1, 12.99, 40, 'Seinen'),
    ('Nana', 'Ai Yazawa', 'Josei', 1, 9.99, 20, 'Josei');


INSERT INTO clientes (nombre, apellido, email, telefono, direccion, tipo_cliente) VALUES
    ('Juan', 'Pérez', 'juan.perez@email.com', '555-1234', 'Calle Ficticia 123', 'Regular'),
    ('Ana', 'Gómez', 'ana.gomez@email.com', '555-5678', 'Avenida Central 45', 'VIP'),
    ('Luis', 'Martínez', 'luis.martinez@email.com', '555-9876', 'Calle Luna 80', 'Nuevo');


INSERT INTO pedidos (idcliente, idmanga, cantidad, fecha, precio_unit) VALUES
    (1, 1, 2, CURDATE(), 10.99),
    (1, 2, 1, CURDATE(), 12.99),
    (2, 1, 3, CURDATE(), 10.99);


SELECT
    P.idpedido,
    C.nombre AS cliente_nombre,
    C.apellido AS cliente_apellido,
    C.tipo_cliente,
    M.titulo AS manga_titulo,
    M.tipo_manga,  
    M.volumen,
    P.cantidad,
    P.fecha,
    P.precio_unit
FROM pedidos P
INNER JOIN clientes C ON P.idcliente = C.idcliente
INNER JOIN mangas M ON P.idmanga = M.idmanga;