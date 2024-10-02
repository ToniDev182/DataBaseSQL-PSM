DROP DATABASE IF EXISTS TiendaWeb;
CREATE DATABASE TiendaWeb CHARACTER SET utf8mb4;
USE TiendaWeb;

CREATE TABLE fabricante (
codigo VARCHAR(3) PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
telefono VARCHAR(9) NOT NULL
);

CREATE TABLE producto (
referencia VARCHAR(5) PRIMARY KEY,
descripcion VARCHAR(100) NOT NULL,
precio DECIMAL(6,2) NOT NULL,
stock_actual INTEGER,
stock_minimo INTEGER,
cod_fabricante VARCHAR(3) NOT NULL,
ultima_venta DATE,
FOREIGN KEY (cod_fabricante) REFERENCES fabricante(codigo)
);

CREATE TABLE venta (
id_venta INTEGER AUTO_INCREMENT,
referencia VARCHAR(5) NOT NULL,
precio_venta DECIMAL(6,2) NOT NULL,
cantidad SMALLINT,
fecha_venta DATE NOT NULL,
PRIMARY KEY (id_venta)
);

CREATE TABLE alerta_reposicion (
id_alerta INTEGER AUTO_INCREMENT PRIMARY KEY,
referencia VARCHAR(5) NOT NULL,
cod_fabricante VARCHAR(30) NOT NULL,
telefono VARCHAR(9) NOT NULL);

CREATE TABLE propuesta_oferta (
referencia VARCHAR(5) NOT NULL,
oferta INTEGER NOT NULL,
fecha_oferta DATE NOT NULL);

ALTER TABLE venta
ADD CONSTRAINT venta_FK_producto
FOREIGN KEY (referencia) REFERENCES producto(referencia)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE alerta_reposicion
ADD CONSTRAINT alerta_reposicion_FK_producto
FOREIGN KEY (referencia) REFERENCES producto(referencia)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE propuesta_oferta
ADD CONSTRAINT propuesta_oferta_FK_producto
FOREIGN KEY (referencia) REFERENCES producto(referencia)
ON DELETE RESTRICT
ON UPDATE CASCADE;


INSERT INTO fabricante VALUES ('001','Asus','666111111');
INSERT INTO fabricante VALUES('002','Lenovo','666222222');
INSERT INTO fabricante VALUES('003','Hewlett-Packard','666333333');
INSERT INTO fabricante VALUES('004','Samsung','666444444');
INSERT INTO fabricante VALUES('005','Seagate','666555555');
INSERT INTO fabricante VALUES('006','Kingston','666666666');
INSERT INTO fabricante VALUES('007','Gigabyte','666777777');

INSERT INTO producto VALUES
('00001','Disco duro SATA3 1TB',86.99,4,2,'005','2024-01-07'),
('00002','Memoria RAM DDR4 8GB',120,10,4,'006','2023-02-20'),
('00003','Disco SSD 1 TB',150.99,8,3,'004','2024-05-03'),
('00004','GeForce GTX 1050Ti',185,9,5,'007','2024-04-26'),
('00005','FURY Beast DDR4 3200',755,15,6,'006','2023-11-05'),
('00006','Monitor 24 LED Full HD',202,3,1,'001','2023-12-18'),
('00007','Monitor 27 LED Full HD',245.99,7,2,'001','2024-03-24'),
('00008','Portátil Yoga 520',559,12,5,'002','2022-05-14'),
('00009','Portátil Ideapd 320',444,20,5,'002','2024-02-01'),
('00010','Impresora HP Deskjet 3720',59.99,8,2,'003','2024-05-23'),
('00011','Impresora HP Laserjet Pro M26nw',180,11,6,'003','2024-04-30');

