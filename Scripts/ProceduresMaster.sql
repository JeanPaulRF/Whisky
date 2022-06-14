


--Postgres
--CRUD Product

--Procedure that createa a product
CREATE OR REPLACE PROCEDURE CreateProduct(
	_name_ VARCHAR(16),
	_aged VARCHAR(16),
	_idSupplier INT,
	_presentation VARCHAR(64),
	_currency VARCHAR(16),
	_cost_ INT,
	_idTypeProduct INT,
	_special BOOLEAN)  
AS 
$$
	BEGIN
		INSERT INTO Producto(name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special)
		VALUES(_name_, _aged, _idSupplier, _presentation, _currency, _cost_, _idTypeProduct, _special)
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;

--read a product
CREATE OR REPLACE PROCEDURE ReadProduct(_name_ VARCHAR(16))  
AS 
$$
	BEGIN
		SELECT name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special
		From Producto
		WHERE name_ = _name_
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--update a product
CREATE OR REPLACE PROCEDURE UpdateProduct(
	_nameOld VARCHAR(16),
	_name_ VARCHAR(16),
	_aged VARCHAR(16),
	_idSupplier INT,
	_presentation VARCHAR(64),
	_currency VARCHAR(16),
	_cost_ INT,
	_idTypeProduct INT,
	_special BOOLEAN)  
AS 
$$
	BEGIN
		UPDATE Producto
		SET name_ = _name_, 
			aged = _aged, 
			idSupplier = _idSupplier, 
			presentation = _presentation, 
			currency = _currency, 
			cost_ = _cost_, 
			idTypeProduct = _idTypeProduct, 
			special = _special
		WHERE name_ = _nameOld
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;

--delete a product
CREATE OR REPLACE PROCEDURE DeleteProduct(_name_ VARCHAR(16))  
AS 
$$
	BEGIN
		UPDATE Producto
		SET activate_ = 0, --set it inactive
		WHERE name_ = _nameOld
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;





--shows the products by type
CREATE OR REPLACE PROCEDURE GetProductsByType(_name_, VARCHAR(16), _special BOOLEAN)  
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
			_name_,
		FROM Product p, ProductType t, Supplier s
		WHERE t.name_ = _name_
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = _special OR p.special = 0) --check the suscription whit the special products
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


-- shows the products by cost
CREATE OR REPLACE PROCEDURE GetProductsByCost(_cost_, INT, _special BOOLEAN)  
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
		AND (p.special = _special OR p.special = 0) --check the suscription whit the special products
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--Shows the best selling products
CREATE OR REPLACE PROCEDURE GetProductsByBestSeller(_special BOOLEAN)
AS 
$$
	BEGIN
		SELECT 
			SUM(v.quantity)*COUNT(id FROM Sale WHERE id = p.id) as Sales --number of sales of the product
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
		AND (p.special = _special OR p.special = 0) --check the suscription whit the special products
		AND v.idProduct = p.id
		ORDER BY Sales DESC -- order it by the number of sales
		
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--Create the review of a product
CREATE OR REPLACE PROCEDURE SetReview
(_username VARCHAR(32), _review VARCHAR(256), _idProduct INT, _stars INT, _storeNameUser VARCHAR(32))
AS 
$$
	BEGIN
		INSERT INTO Review(idProduct, userName, commentary, date_, stars, storeNameUser)
		SELECT _idProduct, _userName, _review, NOW()::DATE, _stars, _storenameUser
		
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--Insert an image of a product
CREATE OR REPLACE PROCEDURE insertImage(_image_ bytea, _idProduct integer)
AS
$$
	BEGIN
		insert into image_(idProduct,image_) VALUES (_idProduct, _image_);
	END;
$$
LANGUAGE plpgsql;



--Create evaluation of a worker
CREATE OR REPLACE PROCEDURE CreateEvaluation
(_workerName VARCHAR(32), _userName VARCHAR(32), _commentary VARCHAR(256), _stars INT, _storeUserName VARCHAR(32))
AS 
$$
	BEGIN
		INSERT INTO EvaluationWorker(idWorker, userName, commentary, date_, stars, storeNameUser)
		SELECT w.id, _userName, _commentary, NOW()::DATE, _stars, _storeUserName
		FROM Worker w
		WHERE w._workerName = name_;
		
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--Create the review of a product
CREATE OR REPLACE PROCEDURE CreateAnswerEvaluation
(_idEvaluation INT, _workerName VARCHAR(32), _commentary VARCHAR(256), _storeUserName VARCHAR(32))
AS 
$$
	BEGIN
		INSERT INTO EvaluationAnswer(idEvaluation, idWorker, commentary, date_, storeNameUser)
		SELECT _idEvaluation, w.id, _commentary, NOW()::DATE, _storeUserName
		FROM Worker w,
		WHERE w._workerName = name_
		AND w.idWorkerType = 1;
		
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;




--Procedure that create a sale
CREATE OR REPLACE PROCEDURE BuyWhisky(
	_storename VARCHAR(32),
	_idCliente int,
	_idProduct int,
	_idWorker int,
	_quantity int)  
AS 
$$
	BEGIN
		--insert the sale
		INSERT INTO Sale (storeName, idClient, idProduct, idWorker, quantity, date_)
		VALUES (_storename, _idCliente, _idProduct, _idWorker, _quantity, NOW()::DATE)
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;











