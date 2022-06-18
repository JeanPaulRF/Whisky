
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
	_special BOOLEAN,
	_active BOOLEAN)  
AS 
$$
	BEGIN
		INSERT INTO product(name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special,active_)
		VALUES(_name_, _aged, _idSupplier, _presentation, _currency, _cost_, _idTypeProduct, _special,_active);
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;

--read a product
CREATE OR REPLACE FUNCTION ReadProduct(_name_ VARCHAR(16))
RETURNS TABLE(
	id INT,
	name_ VARCHAR(16),
	aged VARCHAR(16),
	idSupplier INT,
	presentation VARCHAR(64),
	currency VARCHAR(16),
	cost_ INT,
	idTypeProduct INT,
	special BOOLEAN
)  
AS 
$$
	BEGIN
		RETURN QUERY
		SELECT id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special
		From Product
		WHERE name_ = _name_
		AND active_ = true;
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
		UPDATE Product
		SET name_ = _name_, 
			aged = _aged, 
			idSupplier = _idSupplier, 
			presentation = _presentation, 
			currency = _currency, 
			cost_ = _cost_, 
			idTypeProduct = _idTypeProduct, 
			special = _special
		WHERE name_ = _nameOld;
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
		UPDATE Product
		SET active_ = false --set it inactive
		WHERE name_ = _name_;
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;







--CRUD ProductType

--Procedure that createa a productType
CREATE OR REPLACE PROCEDURE CreateProductType(_name_ VARCHAR(64))  
AS 
$$
	BEGIN
		INSERT INTO ProductType(name_, active_) VALUES(_name_, true);
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--read a productType
CREATE OR REPLACE FUNCTION ReadProductType(_name_ VARCHAR(64)) 
RETURNS TABLE(name_ VARCHAR(64))
AS 
$$
	BEGIN
		RETURN QUERY
		SELECT id, name_
		From ProductType
		WHERE name_ = _name_
		AND active_ = true;
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--update a productType
CREATE OR REPLACE PROCEDURE UpdateProductType(
	_nameOld VARCHAR(64),
	_name_ VARCHAR(64))  
AS 
$$
	BEGIN
		UPDATE ProductType
		SET name_ = _name_ 
		WHERE name_ = _nameOld;
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;

--delete a productType
CREATE OR REPLACE PROCEDURE DeleteProductType(_name_ VARCHAR(16))  
AS 
$$
	BEGIN
		UPDATE ProductType
		SET activate_ = false --set it inactive
		WHERE name_ = _name_;
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;





--CRUD Worker

--Procedure that createa a worker
CREATE OR REPLACE PROCEDURE CreateWorker(
	_salaryLocal INT,
	_salaryDolar INT,
	_name_ VARCHAR(64),
	_uid VARCHAR(16),
	_email VARCHAR(64),
	_telephone VARCHAR(16),
	_idWorkerType INT)  
AS 
$$
	BEGIN
		INSERT INTO Worker(salaryLocal, salaryDolar, name_, uid, email, telephone, idWorkerType, active_)
		VALUES(_salaryLocal, _salaryDolar, _name_, _uid, _email, _telephone, _idWorkerType, true);
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;

--read a worker
CREATE OR REPLACE FUNCTION ReadWorker(_name_ VARCHAR(64))
RETURNS TABLE(
	id INT,
	salaryLocal INT,
	salaryDolar INT,
	name_ VARCHAR(64),
	uid VARCHAR(16),
	email VARCHAR(64),
	telephone VARCHAR(16),
	idWorkerType INT
)  
AS 
$$
	BEGIN
		RETURN QUERY
		SELECT id, salaryLocal, salaryDolar, name_, uid, email, telephone, idWorkerType
		From Worker
		WHERE name_ = _name_
		AND active_ = true;
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--update a worker
CREATE OR REPLACE PROCEDURE UpdateWorker(
	_nameOld VARCHAR(64),
	_salaryLocal INT,
	_salaryDolar INT,
	_name_ VARCHAR(64),
	_uid VARCHAR(16),
	_email VARCHAR(64),
	_telephone VARCHAR(16),
	_idWorkerType INT)  
AS 
$$
	BEGIN
		UPDATE Worker
		SET salaryLocal = _salaryLocal,
			salaryDolar = _salaryDolar,
			name_ = _name_,
			uid = _uid,
			email = _email,
			telephone = _telephone,
			idWorkerType = _idWorkerType
		WHERE name_ = _nameOld;
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;

--delete a worker
CREATE OR REPLACE PROCEDURE DeleteWorker(_name_ VARCHAR(64))  
AS 
$$
	BEGIN
		UPDATE Worker
		SET active_ = false --set it inactive
		WHERE name_ = _name_;
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;





--QUERIES


--shows the products by name
CREATE OR REPLACE FUNCTION GetProductsByName(_name_ VARCHAR(16), _special BOOLEAN)  
RETURNS TABLE(
	id INT,
	name_ VARCHAR(16),
	aged VARCHAR(16),
	supplierName VARCHAR(16),
	presentation VARCHAR(64),
	currency VARCHAR(16),
	cost_ INT,
	nameTypeProduct VARCHAR(64))
AS 
$$
	BEGIN
		RETURN QUERY
		SELECT 
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			t.name_
		FROM Product p, ProductType t, Supplier s
		WHERE p.name_ = _name_
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = _special OR p.special = false); --check the suscription whit the special products
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--shows the products by type
CREATE OR REPLACE FUNCTION GetProductsByType(_name_ VARCHAR(16), _special BOOLEAN)  
RETURNS TABLE(
	id INT,
	name_ VARCHAR(16),
	aged VARCHAR(16),
	supplierName VARCHAR(16),
	presentation VARCHAR(64),
	currency VARCHAR(16),
	cost_ INT,
	nameTypeProduct VARCHAR(64))
AS 
$$
	BEGIN
		RETURN QUERY
		SELECT 
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			t.name_
		FROM Product p, ProductType t, Supplier s
		WHERE t.name_ = _name_
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = _special OR p.special = false); --check the suscription whit the special products
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


-- shows the products by cost
CREATE OR REPLACE FUNCTION GetProductsByCost(_cost_ INT, _special BOOLEAN) 
RETURNS TABLE(
	id INT,
	name_ VARCHAR(16),
	aged VARCHAR(16),
	supplierName VARCHAR(16),
	presentation VARCHAR(64),
	currency VARCHAR(16),
	cost_ INT,
	nameTypeProduct VARCHAR(64))
AS 
$$
	BEGIN
		RETURN QUERY
		SELECT 
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			t.name_
		FROM Product p, ProductType t, Supplier s
		WHERE p.cost_ = _cost_
		AND p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = _special OR p.special = false); --check the suscription whit the special products
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


--Shows the best selling products
CREATE OR REPLACE FUNCTION GetProductsByBestSeller(_special BOOLEAN)
RETURNS TABLE(
	numSales BIGINT,
	id INT,
	name_ VARCHAR(16),
	aged VARCHAR(16),
	supplierName VARCHAR(16),
	presentation VARCHAR(64),
	currency VARCHAR(16),
	cost_ INT,
	nameTypeProduct VARCHAR(64))
AS 
$$
	BEGIN
		RETURN QUERY
		SELECT 
			SUM(v.quantity)*(SELECT COUNT(*) FROM Sale WHERE Sale.id = p.id), --number of sales of the product
			p.id,
			p.name_,
			p.aged,
			s.name_,
			p.presentation,
			p.currency,
			p.cost_,
			t.name_
		FROM Product p, ProductType t, Supplier s, Sale v
		WHERE p.idTypeProduct = t.id
		AND s.id = p.idSupplier
		AND (p.special = _special OR p.special = false) --check the suscription whit the special products
		AND v.idProduct = p.id
		GROUP BY p.id, t.name_, s.name_, v.* -- order it by the number of sales
		ORDER BY v DESC;
		
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
		SELECT _idProduct, _userName, _review, NOW()::DATE, _stars, _storenameUser;
		
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
		
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
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
		FROM Worker w
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
	_idClient int,
	_idProduct int,
	_idWorker int,
	_quantity int)  
AS 
$$
	BEGIN
		--insert the sale
		INSERT INTO Sale (storeName, idClient, idProduct, idWorker, quantity, date_)
		VALUES (_storename, _idClient, _idProduct, _idWorker, _quantity, NOW()::DATE);
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;



--Procedure that create a delivery
CREATE OR REPLACE PROCEDURE SetDelivery(
	_idClient int,
	_idSale int,
	_storename VARCHAR(32),
	_distance real)  
AS 
$$
	BEGIN
		--looks for a worker for deliver
		--DECLARE _idWorker INT := ;
		--SET @idWorker = (SELECT FLOOR(RAND()*(@idWorker-1+1))+1)
	
		--insert the delivery
		INSERT INTO Delivery(idWorker, idClient, idSale, storeName, cost_, distance, _date)
		VALUES ((SELECT id FROM Worker WHERE idWorkerType=4), _idClient, _idSale, _storename, _distance, NOW()::DATE);
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


drop function getbilling
--BILLING
CREATE OR REPLACE FUNCTION GetBilling(
	_idClient int,
	_storename VARCHAR(32),
	_discount int) 
RETURNS TABLE(
	total numeric,
	cost_ int,
	name_ VARCHAR(64),
	currency VARCHAR(64),
	aged VARCHAR(64),
	presentation VARCHAR(64),
	quantity INT,
	date_ DATE)
AS 
$$
	BEGIN
		
		RETURN QUERY
		--shows bill
		SELECT 
			SUM(p.cost_) * s.quantity * (1- (_discount::decimal/100) ), --sum the total of the product and rest the discount
			p.cost_,
			p.name_,
			p.currency,
			p.aged,
			p.presentation,
			s.quantity,
			s.date_
		FROM Sale s, Product p
		WHERE s.idClient = _idClient
		AND s.idProduct = p.id
		AND s.date_ = (SELECT Sale.date_ FROM Sale 
					   WHERE Sale.idClient=_idClient 
					   AND Sale.storename = _storename
					   ORDER BY id DESC LIMIT 1)
		GROUP BY p.cost_, s.quantity, p.name_, p.currency, p.aged, p.presentation, s.date_;
		
	EXCEPTION
		WHEN no_data_found THEN --Si no encuentra datos
			--Mostrar error
			RAISE EXCEPTION 'Error al procesar :(';
	END;
$$ 
LANGUAGE plpgsql;


SELECT * FROM GetBilling(1, 'Scotland', 5)



			








