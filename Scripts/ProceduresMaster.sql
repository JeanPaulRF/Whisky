
--Postgres
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


CREATE OR REPLACE PROCEDURE GetProductsByType(@name_, VARCHAR(16), @special BOOLEAN)  
AS 
$$
	BEGIN
		SELECT 
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			@name_,
		FROM Product p, ProductType t, Supplier s
		WHERE t.name_ = @name_
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = @special OR p.special = 0)
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE GetProductsByCost(@cost_, INT, @special BOOLEAN)  
AS 
$$
	BEGIN
		SELECT 
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			t.name_,
		FROM Product p, ProductType t, Supplier s
		WHERE p.cost_ = cost_
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = @special OR p.special = 0)
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE GetProductsByCost(@cost_, INT, @special BOOLEAN)  
AS 
$$
	BEGIN
		SELECT 
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			t.name_,
		FROM Product p, ProductType t, Supplier s
		WHERE p.cost_ = cost_
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = @special OR p.special = 0)
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE GetProductsByBestSeller(@special BOOLEAN)
AS 
$$
	BEGIN
		SELECT 
			SUM(v.quantity)*COUNT(id FROM Sale WHERE id = p.id) as Sales
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			t.name_,
		FROM Product p, ProductType t, Supplier s, Sale v
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = @special OR p.special = 0)
		AND v.idProduct = p.id
		ORDER BY Sales DESC
		
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;
