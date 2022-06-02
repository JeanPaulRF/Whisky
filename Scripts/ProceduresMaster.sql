--CRUD Product
CREATE OR REPLACE PROCEDURE CreateProduct(
	@name_ VARCHAR(16),
	@aged VARCHAR(16),
	@idSupplier INT,
	@presentation VARCHAR(64),
	@currency VARCHAR(16),
	@cost_ INT,
	@idTypeProduct INT,
	@special BOOLEAN)  
AS 
$$
	BEGIN
		INSERT INTO Producto(name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special)
		VALUES(@name_, @aged, @idSupplier, @presentation, @currency, @cost_, @idTypeProduct, @special)
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE ReadProduct(@name_ VARCHAR(16))  
AS 
$$
	BEGIN
		SELECT name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special
		From Producto
		WHERE name_ = @name_
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE UpdateProduct(
	@nameOld VARCHAR(16),
	@name_ VARCHAR(16),
	@aged VARCHAR(16),
	@idSupplier INT,
	@presentation VARCHAR(64),
	@currency VARCHAR(16),
	@cost_ INT,
	@idTypeProduct INT,
	@special BOOLEAN)  
AS 
$$
	BEGIN
		UPDATE Producto
		SET name_ = @name_, 
			aged = @aged, 
			idSupplier = @idSupplier, 
			presentation = @presentation, 
			currency = @currency, 
			cost_ = @cost_, 
			idTypeProduct = @idTypeProduct, 
			special = @special
		WHERE name_ = @nameOld
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE DeleteProduct(@name_ VARCHAR(16))  
AS 
$$
	BEGIN
		UPDATE Producto
		SET activate_ = 0, 
		WHERE name_ = @nameOld
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


