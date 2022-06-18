-- SQL Server
--DATABASES



CREATE DATABASE [IrelandStore];
GO
USE [IrelandStore]
GO



-- TABLES

CREATE TABLE Store (
	[id] INT,
	[name_] VARCHAR(16),
	[location1] GEOMETRY,
	[location2] AS [location1].STAsText(),

	CONSTRAINT pk_Store PRIMARY KEY (id)
);

CREATE TABLE Inventory (
	[id] INT IDENTITY(1, 1),
	[quantity] INT,
	[idProduct] INT,
	[idStore] INT,

	CONSTRAINT pk_Inventory PRIMARY KEY (id)
);


CREATE TABLE UserType (
	[id] INT,
	[name_] VARCHAR(64),

	CONSTRAINT pk_UserType PRIMARY KEY (id)
);

CREATE TABLE User_ (
	[id] INT IDENTITY(1, 1),
	[username] VARCHAR(16), --
	[pass] VARBINARY(64), --
	[key_] VARCHAR(64), --
	[administrator] BINARY(1),
	[idClient] INT,
	[idUserType] INT,

	CONSTRAINT pk_User PRIMARY KEY (id)
);

CREATE TABLE Client (
	[id] INT IDENTITY(1, 1),
	[name_] VARCHAR(64), --
	[uid] VARCHAR(16),  --
	[email] VARCHAR(64), --
	[telephone] VARCHAR(16), --
	[quantityBuy] INT, --
	[idSuscription] INT, --
	[location1] GEOMETRY,
	[location2] AS [location1].STAsText(),

	CONSTRAINT pk_Client PRIMARY KEY (id)
);

CREATE TABLE Suscription (
	[id] INT,
	[name_] VARCHAR(32),
	[discountBuy] INT,
	[discountDelivery] INT,
	[cost_] INT,
	[active_] BIT DEFAULT(1),

	CONSTRAINT pk_Suscription PRIMARY KEY (id)
);


--FK'S

--Inventory->Store
ALTER TABLE Inventory
ADD CONSTRAINT fk_Inventory_Store
FOREIGN KEY (idStore) 
REFERENCES Store (id);

--User->UserType
ALTER TABLE User_
ADD CONSTRAINT fk_User_UserType
FOREIGN KEY (idUserType) 
REFERENCES UserType (id);

--User->Client
ALTER TABLE User_
ADD CONSTRAINT fk_User_Client
FOREIGN KEY (idClient) 
REFERENCES Client (id);

--Client->Suscription
ALTER TABLE Client
ADD CONSTRAINT fk_Client_Suscription
FOREIGN KEY (idSuscription) 
REFERENCES Suscription (id);


--Insert Data

--Store
INSERT INTO Store(id, name_, location1)
VALUES (3, 'Ireland', geometry::STGeomFromText('POINT(20 20)', 0))

--Inventory
INSERT INTO Inventory(idStore, idProduct, quantity) VALUES(3, 1, 32)
INSERT INTO Inventory(idStore, idProduct, quantity) VALUES(3, 2, 22)
INSERT INTO Inventory(idStore, idProduct, quantity) VALUES(3, 3, 22)
INSERT INTO Inventory(idStore, idProduct, quantity) VALUES(3, 4, 32)
INSERT INTO Inventory(idStore, idProduct, quantity) VALUES(3, 5, 11)

--UserTypes
INSERT INTO UserType(id, name_) VALUES(1, 'admin')
INSERT INTO UserType(id, name_) VALUES(2, 'extern')
INSERT INTO UserType(id, name_) VALUES(3, 'worker')
INSERT INTO UserType(id, name_) VALUES(4, 'user')


--Suscriptions
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(1, 'None', 0, 0)
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(2, 'Tier Short Glass', 5, 0)
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(3, 'Tier Gleincairn', 10, 20)
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(4, 'Tier Master Distiller', 30, 100)


--Clients
INSERT INTO Client(name_, idSuscription, telephone, uid, email, quantityBuy, location1)
VALUES('lucas', 1, '87654321', '44554455', 'lucas@gmail.com', 0, geometry::STGeomFromText('POINT(13 14)', 0))
INSERT INTO Client(name_, idSuscription, telephone, uid, email, quantityBuy, location1)
VALUES('mateo', 1, '12345678', '55445544', 'mateo@gmail.com', 0, geometry::STGeomFromText('POINT(21 21)', 0))
INSERT INTO Client(name_, idSuscription, telephone, uid, email, quantityBuy, location1)
VALUES('lola', 1, '11223344', '66554455', 'lola@gmail.com', 0, geometry::STGeomFromText('POINT(34 1)', 0))


--User
INSERT INTO User_(idClient, username, idUserType, administrator, pass, key_)
VALUES(1, 'lucas123', 1, 1, 'Lucas123*', 'encription')
INSERT INTO User_(idClient, username, idUserType, administrator, pass, key_)
VALUES(2, 'mateo123', 3, 0, 'Mateo123*', 'encription')
INSERT INTO User_(idClient, username, idUserType, administrator, pass, key_)
VALUES(3, 'lola123', 4, 0, 'Lola123*', 'encription')


--Users
/*
EXEC CreateUser_ 'lucas123', 'Lucas123*', 'encription', 1, 1, 1, 0
EXEC CreateUser_ 'mateo123', 'Mateo123*', 'encription', 0, 2, 3, 0
EXEC CreateUser_ 'lola123', 'Lola123*', 'encription', 0, 3, 4, 0
*/