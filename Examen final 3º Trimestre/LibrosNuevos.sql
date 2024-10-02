-- 1 procedimiento crear_libros_nuevos
DROP PROCEDURE IF EXISTS crear_libros_nuevos;
DROP FUNCTION If EXISTS  existe_libro; 
DROP PROCEDURE IF EXISTS insertar_libros_nuevos;
DROP PROCEDURE IF EXISTS actualizar_libros;
DROP TRIGGER IF EXISTS trig_insert_libros;
DROP TRIGGER IF EXISTS trig_update_libros;
DROP TABLE if EXISTS libros_nuevos;

DELIMITER //

CREATE PROCEDURE crear_libros_nuevos()
BEGIN
CREATE TABLE IF NOT EXISTS libros_nuevos (
titulo VARCHAR(40) NOT NULL,
autor VARCHAR(30) NOT NULL,
editorial VARCHAR(20) NOT NULL,
precio DECIMAL(5,2) NOT NULL,
unidades INT NOT NULL,
pendiente TINYINT DEFAULT 1,
enlibros DATE
);
END //

DELIMITER ;

-- 2 procedimieto nsertar_libros_nuevos
DELIMITER //

CREATE PROCEDURE insertar_libros_nuevos()
BEGIN

insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Alicia en el pais de las maravillas','Lewis Carroll','Emece',20.00, 9);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Alicia en el pais de las maravillas','Lewis Carroll','Plaza',35.00, 50);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Aprenda PHP','Mario Molina','Siglo XXI',40.00, 3);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('El aleph','Borges','Emece',10.00, 18);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Ilusiones','Richard Bach','Planeta',15.00, 22);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Java en 10 minutos','Mario Molina','Siglo XXI',50.00, 7);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Martin Fierro','Jose Hernandez','Planeta',20.00, 3);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Martin Fierro','Jose Hernandez','Emece',30.00, 70);
insert into libros_nuevos(titulo,autor,editorial,precio,unidades)
VALUES('Uno','Richard Bach','Planeta',10.00, 120);
END // 

DELIMITER ; 
-- 3 Crear existe_libro
DELIMITER // 

CREATE FUNCTION existe_libro(titulo VARCHAR(100), autor VARCHAR(50), editorial VARCHAR(20)) RETURNS BOOLEAN
BEGIN
DECLARE contador INT;
SELECT COUNT(*) INTO contador
FROM libros
WHERE titulo = titulo AND autor = autor AND editorial = editorial;
RETURN contador > 0;
END //

DELIMITER ;

-- 4 Crer el procedimiento actualizar_libros
DELIMITER //

CREATE PROCEDURE actualizar_libros()
BEGIN

-- declaramos un done que necesitaremos para salir el bucle
DECLARE done INT DEFAULT 0;
 -- declaramos el resto de atributos 
DECLARE titulo_var VARCHAR(40);
DECLARE autor_var VARCHAR(30);
DECLARE editorial_var VARCHAR(20);
DECLARE precio_var DECIMAL(5,2);
DECLARE unidades_var INT;
-- declaramos el cursor para recorer la tabla "libros_nuevos"
DECLARE cursor_libros CURSOR FOR
SELECT titulo, autor, editorial, precio, unidades FROM libros_nuevos WHERE pendiente = 1;
-- creamos un hadler(manejador) llamdo "done"(hecho) cuando no se encuentre un libro salga del bucle
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
-- iniciamos el cursor
OPEN cursor_libros;
    -- para realizar esta parte me he basado en las acitividades propuestas realizdas en clase
	 -- se que no lo hemos visto en clase espeficicamente, igual que el uso del handler pero en este tipo 
	 -- de ejercicios con cursor, es algo que he aprendido, ademas te lo comenté el miercoles en clase. 
lee_loop: LOOP
 -- realizamos un fetch par almacenar
FETCH cursor_libros INTO titulo_var, autor_var, editorial_var, precio_var, unidades_var;
        
IF done THEN
LEAVE lee_loop;
END IF;
 -- si existe el libro, sumo las unidades
 IF existe_libro(titulo_var, autor_var, editorial_var) THEN
 UPDATE libros
SET stock = stock + unidades_var
 WHERE titulo = titulo_var AND autor = autor_var AND editorial = editorial_var;
  -- si no insertalo en la tabla libros
  ELSE
INSERT INTO libros (titulo, autor, editorial, stock)
 VALUES (titulo_var, autor_var, editorial_var, unidades_var);
 END IF;
END LOOP;
    
 CLOSE cursor_libros;
END //

DELIMITER ;

-- 5 Crear triggers para actualizar el campo "pendiente" de la tabla "libros_nuevos"
DELIMITER //

CREATE TRIGGER trig_insert_libros
AFTER INSERT ON libros
FOR EACH ROW
BEGIN
UPDATE libros_nuevos
SET pendiente = 0
WHERE titulo = NEW.titulo AND autor = NEW.autor AND editorial = NEW.editorial;
END //

CREATE TRIGGER trig_update_libros
AFTER UPDATE ON libros
FOR EACH ROW
BEGIN
UPDATE libros_nuevos
SET pendiente = 0
WHERE titulo = NEW.titulo AND autor = NEW.autor AND editorial = NEW.editorial;
END //

DELIMITER ;