-- SQL Server
--DATABASES

CREATE DATABASE [ScotlandStore];
GO
USE [ScotlandStore]
GO

/*
CREATE DATABASE [USAStore];
GO
USE [USAStore]
GO

CREATE DATABASE [IrelandStore];
GO
USE [IrelandStore]
GO
*/


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

CREATE TABLE errorInformation
(
	[id] INT,
	[name_] varchar(64)
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
	[location1] GEOGRAPHY,
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


--Insert Data in Type Tables

--Store
INSERT INTO Store(id, name_, location1)
VALUES (1, 'Scotland', geometry::STGeomFromText('POLYGON((2 1, 3 1, 3 3, 2 3, 2 1))', 0))

--Inventory


--UserTypes
INSERT INTO UserType(id, name_) VALUES(1, 'admin')
INSERT INTO UserType(id, name_) VALUES(2, 'extern')
INSERT INTO UserType(id, name_) VALUES(3, 'worker')
INSERT INTO UserType(id, name_) VALUES(4, 'user')

--Error code
insert into errorInformation(id,name_) values (0,'The user was found');
insert into errorInformation(id,name_) values (1,'The password is incorrect');
insert into errorInformation(id,name_) values (3,'User not found');

--Suscriptions
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(1, 'None', 0, 0)
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(2, 'Tier Short Glass', 5, 0)
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(3, 'Tier Gleincairn', 10, 20)
INSERT INTO Suscription(id, name_, discountBuy, discountDelivery)
VALUES(4, 'Tier Master Distiller', 30, 100)

