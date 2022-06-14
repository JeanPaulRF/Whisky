
--Postgres
-- Database: MasterDB

-- DROP DATABASE IF EXISTS "MasterDB";
/*
CREATE DATABASE "MasterDB"
    WITH 
    OWNER = admin123
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
*/

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
	name_ VARCHAR(64),
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
	id serial PRIMARY KEY,
	name_ VARCHAR(64)
);

CREATE TABLE WorkerType (
	id serial PRIMARY KEY,
	name_ VARCHAR(64)
);

CREATE TABLE Sale (
	id serial PRIMARY KEY,
	storeName VARCHAR(64),
	idClient INT,
	idProduct INT,
	idWorker INT,
	quantity INT,
	date_ DATE
);


CREATE TABLE Review (
	id serial PRIMARY KEY,
	idProduct INT,
	userName VARCHAR(32),
	commentary VARCHAR(256),
	date_ DATE,
	stars INT,
	storeNameUser VARCHAR(32)
);


CREATE TABLE EvaluationWorker(
	id serial PRIMARY KEY,
	idWorker INT,
	userName VARCHAR(32),
	commentary VARCHAR(256),
	date_ DATE,
	stars INT,
	storeNameUser VARCHAR(32)
);


CREATE TABLE EvaluationAnswer(
	id serial PRIMARY KEY,
	idEvaluation INT,
	idWorker INT,
	commentary VARCHAR(256),
	date_ DATE,
	storeNameUser VARCHAR(32)
);


CREATE TABLE Delivery(
	id serial PRIMARY KEY,
	idWorker INT,
	idClient INT,
	idSale INT,
	storeName VARCHAR(32),
	cost_ INT
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

--Sale->Worker
ALTER TABLE Sale
ADD CONSTRAINT fk_Sale_Worker
FOREIGN KEY (idWorker) 
REFERENCES Worker (id);

--Review->Product
ALTER TABLE Review
ADD CONSTRAINT fk_Review_Product
FOREIGN KEY (idProduct) 
REFERENCES Product (id);

--EvaluationWorker->Worker
ALTER TABLE EvaluationWorker
ADD CONSTRAINT fk_EvaluationWorker_Worker
FOREIGN KEY (idWorker) 
REFERENCES Worker (id);

--EvaluationAnswer->EvaluationWorker
ALTER TABLE EvaluationAnswer
ADD CONSTRAINT fk_EvaluationAnswer_EvaluationWorker
FOREIGN KEY (idEvaluationWorker) 
REFERENCES EvaluationWorker (id);

--EvaluationAnswer->Worker
ALTER TABLE EvaluationAnswer
ADD CONSTRAINT fk_EvaluationAnswer_Worker
FOREIGN KEY (idWorker) 
REFERENCES Worker (id);

--Delivery->Worker
ALTER TABLE Delivery
ADD CONSTRAINT fk_Delivery_Worker
FOREIGN KEY (idWorker) 
REFERENCES Worker (id);

--Delivery->Sale
ALTER TABLE Delivery
ADD CONSTRAINT fk_Delivery_Sale
FOREIGN KEY (idSale) 
REFERENCES Worker (id);


--Insert Product Types
INSERT INTO ProductType(name_) VALUES('Single Malt');
INSERT INTO ProductType(name_) VALUES('Blended Scotch');
INSERT INTO ProductType(name_) VALUES('Irish');
INSERT INTO ProductType(name_) VALUES('Blended Malt');
INSERT INTO ProductType(name_) VALUES('Bourbon');
INSERT INTO ProductType(name_) VALUES('Tennessee Whiskey');

--Insert Suppliers
INSERT INTO Supplier(name_) VALUES('Global whisky');
INSERT INTO Supplier(name_) VALUES('European whisky');
INSERT INTO Supplier(name_) VALUES('Good whisky');

--Insert TypeWorker
INSERT INTO WorkerType(name_) VALUES('Boss');
INSERT INTO WorkerType(name_) VALUES('Superior');
INSERT INTO WorkerType(name_) VALUES('Normal');




