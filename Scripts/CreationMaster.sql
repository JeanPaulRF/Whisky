-- Database: MasterDB

-- DROP DATABASE IF EXISTS "MasterDB";

CREATE DATABASE "MasterDB"
    WITH 
    OWNER = admin123
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	

-- TABLES
CREATE TABLE Worker (
	id serial PRIMARY KEY,
	salaryLocal INT,
	salaryDolar INT,
	name_ VARCHAR(64),
	uid VARCHAR(16),
	email VARCHAR(64),
	telephone VARCHAR(16),
	idWorkerType INT
);

CREATE TABLE Product (
	id serial PRIMARY KEY,
	name_ VARCHAR(10),
	aged VARCHAR(10),
	idSupplier VARCHAR(10),
	presentation VARCHAR(64),
	currency VARCHAR(10),
	cost_ NUMERIC,
	idTypeProduct INT,
	idImage INT,
	special BOOLEAN
);

CREATE TABLE Supplier (
	id serial PRIMARY KEY,
	name_ VARCHAR(32)
);

CREATE TABLE Image_ (
	id serial PRIMARY KEY,
	idProduct INT,
	image_ bytea
);

CREATE TABLE ProdcutType (
	id INT PRIMARY KEY,
	name_ VARCHAR(64)
);

CREATE TABLE WorkerType (
	id serial PRIMARY KEY,
	name_ VARCHAR(64)
);

CREATE TABLE Sale (
	id serial PRIMARY KEY,
	date_ DATE,
	total INT,
	deliveryCost INT
);

CREATE TABLE SaleXProduct (
	id serial PRIMARY KEY,
	idProduct INT,
	idSale INT
);

CREATE TABLE Review (
	id serial PRIMARY KEY,
	idProducto INT,
	idCliente INT,
	commentary VARCHAR(256),
	date_ DATE,
	stars INT
);


--FK's
--Worker->WorkerType
ALTER TABLE Worker 
ADD CONSTRAINT fk_Worker_WorkerType
FOREIGN KEY (idWorkerType) 
REFERENCES WorkerType (id);

--Product->ProductType
ALTER TABLE Product
ADD CONSTRAINT fk_Product_ProductType
FOREIGN KEY (idProductType) 
REFERENCES ProductType (id);

--Product->Image
ALTER TABLE Product
ADD CONSTRAINT fk_Product_Image
FOREIGN KEY (idImage) 
REFERENCES Image_ (id);

--Product->Supplier
ALTER TABLE Product
ADD CONSTRAINT fk_Product_Supplier
FOREIGN KEY (idSupplier) 
REFERENCES Supplier (id);

--ProductXSale->Product
ALTER TABLE ProductXSale
ADD CONSTRAINT fk_ProductXSale_Product
FOREIGN KEY (idProduct) 
REFERENCES Product (id);

--ProductXSale->Sale
ALTER TABLE ProductXSale
ADD CONSTRAINT fk_ProductXSale_Sale
FOREIGN KEY (idSale) 
REFERENCES Sale (id);



CREATE OR REPLACE FUNCTION getProduct(id_ int) RETURNS int AS $$
BEGIN
	SELECT * FROM Product WHERE id = id_
	RETURN 0;
EXCEPTION
	WHEN no_data_found THEN --Si no encuentra datos
		--Mostrar error
		RETURN 50005;
END;
$$ LANGUAGE plpgsql;



INSERT INTO Supplier(name_) VALUES('bimbo');


SELECT * FROM Supplier