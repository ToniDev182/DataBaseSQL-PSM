DROP PROCEDURE if EXISTS Proponer_ofertas;
DROP FUNCTION if EXISTS Precio_actual;
DROP FUNCTION if EXISTS Stock_actual;
DROP TRIGGER if EXISTS Trg_Reponer;
DROP PROCEDURE if EXISTS Nueva_venta;

DELIMITER $$

CREATE PROCEDURE Proponer_ofertas()
BEGIN
DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE prodRef VARCHAR(5);
DECLARE ultima_venta DATE;
DECLARE porcentaje_oferta INT;
    
DECLARE cur_ofertas CURSOR FOR SELECT referencia, ultima_venta FROM producto;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
OPEN cur_ofertas;
    
bucle: LOOP
FETCH cur_ofertas INTO prodRef, ultima_venta;
IF done THEN
LEAVE bucle;
END IF;
        
IF ultima_venta < CURDATE() - INTERVAL 1 YEAR THEN
SET porcentaje_oferta = 50;
ELSEIF ultima_venta < CURDATE() - INTERVAL 6 MONTH THEN
SET porcentaje_oferta = 25;
ELSEIF ultima_venta < CURDATE() - INTERVAL 3 MONTH THEN
SET porcentaje_oferta = 10;
ELSE
SET porcentaje_oferta = 0;
END IF;
        
IF porcentaje_oferta > 0 THEN
INSERT INTO propuesta_oferta (referencia, oferta, fecha_oferta)
SELECT prodRef, porcentaje_oferta, CURDATE()
WHERE NOT EXISTS (
SELECT 1 FROM propuesta_oferta
WHERE referencia = prodRef
);
END IF;
END LOOP;
    
CLOSE cur_ofertas;
END$$


DELIMITER $$

CREATE FUNCTION Stock_actual(refer VARCHAR(5)) RETURNS INT
BEGIN

DECLARE stock INT;
SELECT stock_actual INTO stock FROM producto WHERE referencia = ref;
RETURN stock;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION Precio_actual(refer VARCHAR(5)) RETURNS DECIMAL(6,2)
BEGIN

DECLARE precio DECIMAL(6,2);
SELECT precio INTO precio FROM producto WHERE referencia = ref;
RETURN precio;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER Trg_Reponer
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN


-- IF NEW.stock_actual < NEW.stock_minimo THEN
-- INSERT INTO alerta_reposicion (referencia, cod_fabricante, telefono)
-- SELECT NEW.referencia, f.codigo, f.telefono
-- FROM fabricante f
-- WHERE f.codigo = NEW.cod_fabricante
-- END IF;
-- END$$ 

DELIMITER ;

  DELIMITER $$
  
CREATE PROCEDURE Nueva_venta(IN prod_ref VARCHAR(5), IN cantidad INT)
BEGIN
DECLARE stock INT;
DECLARE precio DECIMAL(6,2);
DECLARE mensaje VARCHAR(255);

IF cantidad <= 0 THEN
SET mensaje = ' no puede ser menor o igual a 0';
SELECT mensaje AS mensaje_salida;
END IF;
    
SELECT Stock_actual(prod_ref) INTO stock;
IF stock IS NULL THEN
SET mensaje = 'no existe';
ELSEIF cantidad > stock THEN
SET mensaje = 'No puede realizarse la venta, no hay stock suficiente';
ELSE
SELECT Precio_actual(prod_ref) INTO precio;
INSERT INTO venta (referencia, precio_venta, cantidad, fecha_venta)
VALUES (prod_ref, precio, cantidad, CURDATE());
UPDATE producto SET stock_actual = stock_actual - cantidad
WHERE referencia = prod_ref;
SET mensaje = 'se ha llevado a cabo con éxito';
END IF;
    
SELECT mensaje AS mensaje_salida;
END$$

DELIMITER ;