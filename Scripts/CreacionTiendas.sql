--DATABASES
/*
CREATE DATABASE [ScotlandStore];
GO
USE [ScotlandStore]
GO
*/
/*
CREATE DATABASE [USAStore];
GO
USE [USAStore]
GO
*/
/*
CREATE DATABASE [IrelandStore];
GO
USE [IrelandStore]
GO
*/


-- TABLES

CREATE TABLE Inventory (
	[id] INT IDENTITY(1, 1),
	[name_] VARCHAR(16),
	[quantity] INT,
	[idProduct] INT,
	[idStore] INT,

	CONSTRAINT pk_Inventory PRIMARY KEY (id)
);

CREATE TABLE Store (
	[id] INT IDENTITY(1, 1),
	[name_] VARCHAR(16),
	[location1] GEOGRAPHY,
	[location2] AS [location1].STAsText(),

	CONSTRAINT pk_Store PRIMARY KEY (id)
);


--FK'S

--Inventory->Store
ALTER TABLE Inventory
ADD CONSTRAINT fk_Inventory_Store
FOREIGN KEY (idStore) 
REFERENCES Store (id);
