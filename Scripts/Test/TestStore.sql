USE ScotlandStore
GO

--create client
INSERT INTO Client(name_, idSuscription, telephone, uid, email, quantityBuy, location1)
VALUES('enrique', 4, '72657265', '1000222', 'enrique@gmail.com', 0, geometry::STGeomFromText('POINT(10 11)', 0))

SELECT * FROM Client



--USER
USE ScotlandStore
GO
EXEC CreateUser_ 'kiko', 'Kiko123*', 1, 4, 1, 0

EXEC ReadUser 'kiko', 0

EXEC isUserCorrect 'kiko', 'Kiko123*', 0

EXEC GetUserType 4, 0




--CRUD Suscription
EXEC CreateSuscription 5, 'normal', 10, 15, 2000, 0

EXEC ReadSuscription 'normal', 0

EXEC UpdateSuscription 'normal', 'standard', 5, 10, 2500, 0

EXEC DeleteSuscription 'standard', 0



--INVENTORY
EXEC ShowInventory 4, 0

--resta
EXEC UpdateInventory 1, 2, 0

SELECT * FROM Inventory


--Suscription
EXEC SetSuscription 4, 'Tier Master Distiller', 0

EXEC GetSuscription 4, 0



--DISTANCE 
USE ScotlandStore
GO
EXEC GetDistance 4, 'Usa', 0


--QUERIES
--Asc
EXEC GetEntireInventory '1000222', 0, 0

--Desc
EXEC GetEntireInventory '1000222', 0, 0

EXEC GetProductByName '1000222', 0, 0

EXEC GetProductByType '1000222', 0, 0

EXEC GetProductByCost '1000222', 0, 0




--DISCOUNT
EXEC GetSaleDiscount 4, 0

EXEC GetDeliveryDiscount 4, 0