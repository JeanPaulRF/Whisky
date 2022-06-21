USE ScotlandStore
GO

--USE USAStore
GO

--USE IrelandStore
GO



--CRUD Suscription

--create suscription
CREATE PROCEDURE CreateSuscription(
	@id INT,
	@name_ VARCHAR(32),
	@discountBuy INT,
	@discountDelivery INT,
	@cost_ INT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			INSERT INTO Suscription(id, name_, discountBuy, discountDelivery, cost_)
			VALUES(@id, @name_, @discountBuy, @discountDelivery, @cost_)

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO

--read suscription
CREATE PROCEDURE ReadSuscription(
	@name_ VARCHAR(32),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			SELECT id, name_, discountBuy, discountDelivery, cost_
			FROM Suscription
			WHERE name_ = @name_

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO

--update suscription
CREATE PROCEDURE UpdateSuscription(
	@nameOld VARCHAR(32),
	@name_ VARCHAR(32),
	@discountBuy INT,
	@discountDelivery INT,
	@cost_ INT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			UPDATE Suscription
			SET name_ = @name_,
				discountBuy = @discountBuy,
				discountDelivery = @discountDelivery,
				cost_ = @cost_
			WHERE name_ = @nameOld

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO

--delete suscription
CREATE PROCEDURE DeleteSuscription(
	@name_ VARCHAR(32),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			UPDATE Suscription
			SET active_ = 0
			WHERE name_ = @name_

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO



-- USER
--create a user

CREATE PROCEDURE CreateUser_(
	@username VARCHAR(16),
	@pass VARCHAR(64),
	@administrator BIT,
	@idClient INT,
	@idUserType INT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY		
		BEGIN TRANSACTION T1

			DECLARE @pssb VARBINARY(64)
			SET @pssb = (ENCRYPTBYPASSPHRASE('encryption', @pass))

			INSERT INTO User_(username, pass, key_, administrator, idClient, idUserType)
			VALUES(@username, @pssb, 'encryption', @administrator, @idClient, @idUserType)

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


--shows a user
CREATE PROCEDURE ReadUser(
	@username VARCHAR(16),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			SELECT unencripted=CONVERT(varchar(64), DECRYPTBYPASSPHRASE(key_, pass)), * FROM User_ WHERE username=@username

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO

--check the user and password
CREATE or alter PROCEDURE isUserCorrect(
	@username VARCHAR(16),
	@pass VARCHAR(64),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @temp TABLE(result bit)
			
			--check the user exists
			IF EXISTS (SELECT id FROM User_ WHERE username=@username)
			BEGIN
				--check the password exists
				IF @pass = (SELECT CONVERT(varchar(64), DECRYPTBYPASSPHRASE(key_, pass)) FROM User_ WHERE username=@username)
				BEGIN
				INSERT INTO @temp(result) VALUES(1);
				END

				ELSE
				BEGIN
				INSERT INTO @temp(result) VALUES(0);
				END
			END

			SELECT result FROM @temp
			
		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO

--INVENTORY
--shows the inventory
CREATE PROCEDURE ShowInventory(@idClient int, @outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			
			--temp table to insert all the products
			DECLARE @product TABLE(
			id INT,
			name_ VARCHAR(16),
			aged VARCHAR(16),
			idSupplier INT,
			presentation VARCHAR(64),
			currency VARCHAR(16),
			cost_ INT,
			idTypeProduct INT,
			special BIT,
			active_ BIT)

			--insert all the productos in masterDB
			INSERT INTO @product(id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_)
			SELECT id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_
			FROM OPENQUERY([MASTERDBPOSTGRES], 'SELECT * FROM Product')

			--if low or non suscription shows normal products
			IF 2 > (SELECT idSuscription FROM Client WHERE id=@idClient)
				BEGIN
				select i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_
					from inventory i, openquery(MASTERDBPOSTGRES,'Select * from product;') p, 
						openquery(MASTERDBPOSTGRES,'Select * from producttype;') t
					where quantity > 0
						AND p.id = i.idProduct
						AND p.idTypeProduct = t.id
						AND p.special = 0 --just the no special
				END
			ELSE ----if high suscription shows normal and special products
				BEGIN
				select i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_ 
					from inventory i, openquery(MASTERDBPOSTGRES,'Select * from product;') p, 
						openquery(MASTERDBPOSTGRES,'Select * from producttype;') t
				WHERE quantity>0
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				END

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


--FUNCTIONALITIES
--buy a product
CREATE PROCEDURE UpdateInventory(
	@idProduct int,
	@quantity int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--decrease the quantity of the product
			UPDATE Inventory
			SET quantity = quantity-@quantity
			WHERE idProduct = @idProduct


		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
		print 'error'
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


--CLIENT
--set the client suscription
CREATE PROCEDURE SetSuscription(
	@idCliente int,
	@name_ varchar(32),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			UPDATE Client
			SET idSuscription = s.id
			FROM Suscription s, Client c
			WHERE c.id=@idCliente
			AND s.name_=@name_

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF

END;
GO



--shows the client suscription
CREATE PROCEDURE GetSuscription(
	@idClient int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			SELECT idSuscription FROM Client WHERE id=@idClient

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF

END;
GO


--show the user type
CREATE PROCEDURE GetUserType(
	@idCliente int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			SELECT u.idUserType FROM User_ u WHERE u.idClient=@idCliente

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF

END;
GO



--get the distance between the client and the store
CREATE PROCEDURE GetDistance(
	@idClient INT,
	@storeName VARCHAR(32),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--declare variable for distance
			DECLARE @distante FLOAT

			--Set the distance depends on the country
			IF @storeName = 'Scotland'
				BEGIN
				SET @distante = 
				(SELECT c.location1.STDistance(s.location1) 
				FROM [ScotlandStore].dbo.Store s, Client c
				WHERE c.id=@idClient AND s.name_=@storeName)
				END;
			ELSE
				BEGIN
				IF @storeName = 'Usa'
					BEGIN
					SET @distante = 
					(SELECT c.location1.STDistance(s.location1) 
					FROM [USAStore].dbo.Store s, Client c
					WHERE c.id=@idClient AND s.name_=@storeName)
					END;
				ELSE
					BEGIN
					SET @distante = 
					(SELECT c.location1.STDistance(s.location1) 
					FROM [IrelandStore].dbo.Store s, Client c
					WHERE c.id=@idClient AND s.name_=@storeName)
					END;
				END;

			SELECT @distante

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF

END;
GO



--PROXIMITY
--shows all the invetories by distance
CREATE PROCEDURE GetEntireInventory(
	@uidClient VARCHAR(16),
	@ascending BIT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--temp table to get all the inventories
			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(16),
			distance FLOAT)

			--get the scotland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [ScotlandStore].dbo.Inventory i, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Client c
			WHERE i.idStore=s.id

			--get the usa inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the ireland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--temp table to insert all the products
			DECLARE @product TABLE(
			id INT,
			name_ VARCHAR(16),
			aged VARCHAR(16),
			idSupplier INT,
			presentation VARCHAR(64),
			currency VARCHAR(16),
			cost_ INT,
			idTypeProduct INT,
			special BIT,
			active_ BIT)

			--insert all the productos in masterDB
			INSERT INTO @product(id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_)
			SELECT id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_
			FROM OPENQUERY([MASTERDBPOSTGRES], 'SELECT * FROM Product')

			--get the client suscription and check for special products
			DECLARE @special BIT
			IF (SELECT idSuscription FROM Client WHERE uid=@uidClient) >= 2
				BEGIN
				SET @special = 1
				END
			ELSE 
				BEGIN 
				SET @special = 0
				END

			--returns all the products depends on the inventory with the distance
			IF @ascending=1 --if shows ascending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.id = i.idProduct
				AND p.special <= @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance ASC
				END

			ELSE --if shows descending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.id = i.idProduct
				AND p.special <= @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance DESC
				END

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


--shows the products by name and the distance
CREATE PROCEDURE GetProductByName(
	@uidClient int,
	@nameProduct VARCHAR(32),
	@ascending BIT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--temp table to get all the inventories
			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(16),
			distance FLOAT)

			--get the scotland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [ScotlandStore].dbo.Inventory i, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Client c
			WHERE i.idStore=s.id

			--get the usa inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the ireland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--temp table to insert all the products
			DECLARE @product TABLE(
			id INT,
			name_ VARCHAR(16),
			aged VARCHAR(16),
			idSupplier INT,
			presentation VARCHAR(64),
			currency VARCHAR(16),
			cost_ INT,
			idTypeProduct INT,
			special BIT,
			active_ BIT)

			--insert all the productos in masterDB
			INSERT INTO @product(id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_)
			SELECT id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_
			FROM OPENQUERY([MASTERDBPOSTGRES], 'SELECT * FROM Product')

			--get the client suscription and check for special products
			DECLARE @special BIT
			IF (SELECT idSuscription FROM Client WHERE uid=@uidClient) >= 2
				BEGIN
				SET @special = 1
				END
			ELSE 
				BEGIN 
				SET @special = 0
				END

			--returns all the products depends on the inventory with the distance
			IF @ascending=1 --if shows ascending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.id = i.idProduct
				AND p.special = @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance ASC
				END

			ELSE --if shows descending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.name_ = @nameProduct
				AND p.id = i.idProduct
				AND p.special = @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance DESC
				END

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


--show products by name and distance
CREATE PROCEDURE GetProductByType(
	@uidClient int,
	@typeProduct VARCHAR(32),
	@ascending BIT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--temp table to get all the inventories
			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(16),
			distance FLOAT)

			--get the scotland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [ScotlandStore].dbo.Inventory i, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Client c
			WHERE i.idStore=s.id

			--get the usa inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the ireland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--temp table to insert all the products
			DECLARE @product TABLE(
			id INT,
			name_ VARCHAR(16),
			aged VARCHAR(16),
			idSupplier INT,
			presentation VARCHAR(64),
			currency VARCHAR(16),
			cost_ INT,
			idTypeProduct INT,
			special BIT,
			active_ BIT)

			--insert all the productos in masterDB
			INSERT INTO @product(id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_)
			SELECT id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_
			FROM OPENQUERY([MASTERDBPOSTGRES], 'SELECT * FROM Product')

			--get the client suscription and check for special products
			DECLARE @special BIT
			IF (SELECT idSuscription FROM Client WHERE uid=@uidClient) >= 2
				BEGIN
				SET @special = 1
				END
			ELSE 
				BEGIN 
				SET @special = 0
				END

			--returns all the products depends on the inventory with the distance
			IF @ascending=1 --if shows ascending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.idTypeProduct = @typeProduct
				AND p.id = i.idProduct
				AND p.special <= @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance ASC
				END

			ELSE --if shows descending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.idTypeProduct = @typeProduct
				AND p.id = i.idProduct
				AND p.special <= @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance DESC
				END

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO



--shows the products by cost and distance
CREATE PROCEDURE GetProductByCost(
	@uidClient int,
	@cost INT,
	@ascending BIT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--temp table to get all the inventories
			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(16),
			distance FLOAT)

			--get the scotland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [ScotlandStore].dbo.Inventory i, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Client c
			WHERE i.idStore=s.id

			--get the usa inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the ireland inventory
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--temp table to insert all the products
			DECLARE @product TABLE(
			id INT,
			name_ VARCHAR(16),
			aged VARCHAR(16),
			idSupplier INT,
			presentation VARCHAR(64),
			currency VARCHAR(16),
			cost_ INT,
			idTypeProduct INT,
			special BIT,
			active_ BIT)

			--insert all the productos in masterDB
			INSERT INTO @product(id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_)
			SELECT id, name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_
			FROM OPENQUERY([MASTERDBPOSTGRES], 'SELECT * FROM Product')

			--get the client suscription and check for special products
			DECLARE @special BIT
			IF (SELECT idSuscription FROM Client WHERE uid=@uidClient) >= 2
				BEGIN
				SET @special = 1
				END
			ELSE 
				BEGIN 
				SET @special = 0
				END

			--returns all the products depends on the inventory with the distance
			IF @ascending=1 --if shows ascending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.cost_ = @cost
				AND p.id = i.idProduct
				AND p.special <= @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance ASC
				END

			ELSE --if shows descending
				BEGIN
				SELECT 
					i.nameStore,
					i.distance,
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					p.idTypeProduct,
					p.idSupplier
				FROM @temp i, @product p
				WHERE i.quantity>0 --if there are enough
				AND p.cost_ = @cost
				AND p.id = i.idProduct
				AND p.special <= @special --if is special or not
				AND p.active_ = 1 --if is active
				ORDER BY i.distance DESC
				END

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO



--DISCOUNT

--return the sale discount
CREATE PROCEDURE GetSaleDiscount(
	@idCliente int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			SELECT s.discountBuy FROM Client c, Suscription s WHERE c.id=@idCliente AND c.idSuscription = s.id

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF

END;
GO


--return the delivery discount
CREATE PROCEDURE GetDeliveryDiscount(
	@idCliente int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			SELECT s.discountDelivery FROM Client c, Suscription s WHERE c.id=@idCliente AND c.idSuscription = s.id

		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF

END;
GO