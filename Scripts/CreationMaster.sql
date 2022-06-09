
--Postgres
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
	name_ VARCHAR(16),
	aged VARCHAR(16),
	idSupplier INT,
	presentation VARCHAR(64),
	currency VARCHAR(16),
	cost_ INT,
	idTypeProduct INT,
	special BOOLEAN,
    active_ BOOLEAN
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

CREATE TABLE ProductType (
	id INT PRIMARY KEY,
	name_ VARCHAR(64)
);

CREATE TABLE WorkerType (
	id serial PRIMARY KEY,
	name_ VARCHAR(64)
);

CREATE TABLE Sale (
	id serial PRIMARY KEY,
	idStore INT,
	idClient INT,
	idProduct INT,
	quantity INT,
	date_ DATE,
	deliveryCost INT
);


CREATE TABLE Review (
	id serial PRIMARY KEY,
	idProducto INT,
	userName VARCHAR(32),
	commentary VARCHAR(256),
	date_ DATE,
	stars INT,
	storeNameUser VARCHAR(32)
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
FOREIGN KEY (idTypeProduct) 
REFERENCES ProductType (id);

--Image->Product
ALTER TABLE Image_
ADD CONSTRAINT fk_Image_Product
FOREIGN KEY (idProduct) 
REFERENCES Product (id);

--Product->Supplier
ALTER TABLE Product
ADD CONSTRAINT fk_Product_Supplier
FOREIGN KEY (idSupplier) 
REFERENCES Supplier (id);

--Sale->Product
ALTER TABLE Sale
ADD CONSTRAINT fk_Sale_Product
FOREIGN KEY (idProduct) 
REFERENCES Product (id);


--Insert Product Types
INSERT INTO ProductType(id, name_) VALUES(1, 'Single Malt');
INSERT INTO ProductType(id, name_) VALUES(2, 'Blended Scotch');
INSERT INTO ProductType(id, name_) VALUES(3, 'Irish');
INSERT INTO ProductType(id, name_) VALUES(4, 'Blended Malt');
INSERT INTO ProductType(id, name_) VALUES(5, 'Bourbon');
INSERT INTO ProductType(id, name_) VALUES(6, 'Tennessee Whiskey');

--Insert Suppliers
INSERT INTO Supplier(name_) VALUES('bimbo');




