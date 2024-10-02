-- Base de datos libreria
DROP DATABASE IF EXISTS Libreria;
CREATE DATABASE Libreria CHARACTER SET utf8mb4;
USE Libreria;

-- Tabla libros, que contiene stock de libros de la libreria
CREATE TABLE libros (
IDlibro INT PRIMARY KEY,
titulo VARCHAR(100) NOT NULL,
autor VARCHAR(50),
editorial varchar(20),
stock int);

-- Inserción de Datos
INSERT INTO libros VALUES(1,'El nombre de la rosa','Umberto Eco','RBA',1);
INSERT INTO libros VALUES(2,'El legado de los huesos','Dolores Redondo','Ed. Planeta',3);
INSERT INTO libros VALUES(3,'La casa de Bernarda Alba','Federico García Lorca','Ed. Casals',2);
INSERT INTO libros VALUES(4,'Orgullo y prejuicio','Jane Austen','Alba Editorial',1);
INSERT INTO libros VALUES(5,'Cien años de soledad','Gabriel García Márquez','Debolsillo',2);
INSERT INTO libros VALUES(6,'Alicia en el país de las maravillas','Lewis Carroll','Emece',2);
INSERT INTO libros VALUES(7,'Los pilares de la tierra','Kent Follett','Plaza & Janés',2);

