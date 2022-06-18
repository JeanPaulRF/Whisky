
--Postgres
-- Database: MasterDB

-- DROP DATABASE IF EXISTS "MasterDB";
/*
CREATE DATABASE "MasterDB"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
	template = template0
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
	idWorkerType INT,
	active_ BOOLEAN
);

CREATE TABLE Product (
	id serial PRIMARY KEY,
	name_ VARCHAR(32),
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
	name_ VARCHAR(64),
	active_ BOOLEAN
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
	cost_ INT,
	distance REAL,
	date_ DATE
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
FOREIGN KEY (idEvaluation) 
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
INSERT INTO ProductType(name_,active_) VALUES('Single Malt',true);
INSERT INTO ProductType(name_,active_) VALUES('Blended Scotch',true);
INSERT INTO ProductType(name_,active_) VALUES('Irish',true);
INSERT INTO ProductType(name_,active_) VALUES('Blended Malt',true);
INSERT INTO ProductType(name_,active_) VALUES('Bourbon',true);
INSERT INTO ProductType(name_,active_) VALUES('Tennessee Whiskey',true);

--Insert Suppliers
INSERT INTO Supplier(name_) VALUES('Global whisky');
INSERT INTO Supplier(name_) VALUES('European whisky');
INSERT INTO Supplier(name_) VALUES('Good whisky');

--Insert TypeWorker
INSERT INTO WorkerType(name_) VALUES('Boss');
INSERT INTO WorkerType(name_) VALUES('Superior');
INSERT INTO WorkerType(name_) VALUES('Normal');
INSERT INTO WorkerType(name_) VALUES('Deliver');

--Insert Worker
INSERT INTO Worker(salarylocal, salarydolar, name_, uid, email, telephone, idworkertype) 
VALUES(1000, 600, 'Juan', '108880999', 'juan@gmail.com', '88877766', 3);
INSERT INTO Worker(salarylocal, salarydolar, name_, uid, email, telephone, idworkertype) 
VALUES(2000, 900, 'Luis', '213130909', 'luis@gmail.com', '66778899', 2);
INSERT INTO Worker(salarylocal, salarydolar, name_, uid, email, telephone, idworkertype) 
VALUES(1500, 1000, 'Ana', '332326565', 'ana@gmail.com', '76768989', 1);

--Insert Product
INSERT INTO Product(name_, aged, idsupplier, presentation, currency, cost_, idtypeproduct, special, active_) 
VALUES('whisky', '10 years aged', 1, 'glass bottle', 'dolar', 3000, 1, true, true);
INSERT INTO Product(name_, aged, idsupplier, presentation, currency, cost_, idtypeproduct, special, active_) 
VALUES('tequila', '5 years aged', 2, 'plastic bottle', 'dolar', 2000, 2, true, true);
INSERT INTO Product(name_, aged, idsupplier, presentation, currency, cost_, idtypeproduct, special, active_) 
VALUES('ron', '1 years aged', 3, 'barrel', 'dolar', 1000, 3, false, true);
INSERT INTO Product(name_, aged, idsupplier, presentation, currency, cost_, idtypeproduct, special, active_) 
VALUES('vodka', '10 months aged', 2, 'glass bottle', 'dolar', 500, 4, false, true);
INSERT INTO Product(name_, aged, idsupplier, presentation, currency, cost_, idtypeproduct, special, active_) 
VALUES('beer', '5 months aged', 1, 'six pack', 'dolar', 3500, 5, false, true);

