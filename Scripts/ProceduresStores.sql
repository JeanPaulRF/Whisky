USE ScotlandStore
GO

-- USER
--create a user
CREATE PROCEDURE CreateUser(
	@username VARCHAR(16),
	@pass VARBINARY(64),
	@key VARCHAR(64),
	@administrator BINARY,
	@idClient INT,
	@idUserType INT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @pssb VARBINARY(64)
			SET @pssb = (ENCRYPTBYPASSPHRASE(@key, @pssb))

			INSERT INTO User_(username, pass, key_, administrator, idClient, idUserType)
			VALUES(@username, @pssb, @key, @administrator, @idClient, @idUserType)

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
CREATE PROCEDURE isUserCorrect(
	@username VARCHAR(16),
	@pass VARCHAR(64),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			
			--check the user exists
			IF EXISTS (SELECT CONVERT(varchar(64), DECRYPTBYPASSPHRASE(key_, pass)) FROM User_ WHERE username=@username)
			BEGIN
				--check the password exists
				IF @pass = (SELECT CONVERT(varchar(64), DECRYPTBYPASSPHRASE(key_, pass)) FROM User_ WHERE username=@username)
				BEGIN
				SELECT 1
				END

				ELSE
				BEGIN
				SELECT 0
				END
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

--INVENTORY
--shows the inventory
CREATE PROCEDURE ShowInventory(@idClient int, @outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			--if low or non suscription shows normal products
			IF 2 > (SELECT idSuscription FROM Client WHERE id=@idClient)
				BEGIN
				SELECT i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_,
					i2.image_
				FROM Inventory i,
					[MASTERDBPOSTGRES].MasterDB.[public].product p,
					[MASTERDBPOSTGRES].MasterDB.[public].producttype t,
					[MASTERDBPOSTGRES].MasterDB.[public].image_ i2
				WHERE quantity>0
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND p.special = 0 --just the no special
				AND i2.idProduct = p.id
				END
			ELSE ----if high suscription shows normal and special products
				BEGIN
				SELECT i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_,
					i2.image_
				FROM Inventory i,
					[MASTERDBPOSTGRES].MasterDB.[public].product p,
					[MASTERDBPOSTGRES].MasterDB.[public].producttype t,
					[MASTERDBPOSTGRES].MasterDB.[public].image_ i2
				WHERE quantity>0
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND i2.idProduct = p.id
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
CREATE PROCEDURE BuyWhisky(
	@idCliente int,
	@idProduct int,
	@quantity int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			
			--define date
			DECLARE @fecha DATE = CONVERT(DATE, GETDATE());

			--decrease the quantity of the product
			UPDATE Inventory
			SET quantity = quantity-@quantity
			WHERE idProduct = @idProduct

			--insert the sale
			INSERT INTO OPENQUERY([MASTERDBPOSTGRES], 'SELECT idProduct, quantity, date_, deliveryCost FROM Sale')
			VALUES (@idProduct, @quantity, @fecha, 0)

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
	@uidClient int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			SELECT idSuscription FROM Client WHERE uid=@uidClient

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


--create a delivery of a sale
CREATE PROCEDURE SetDelivery(
	@idClient INT,
	@idSale INT,
	@storeName VARCHAR(32),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			
			--looks for a random worker for deliver
			DECLARE @idWorker INT
			SET @idWorker = (SELECT * FROM OPENQUERY([MASTERDBPOSTGRES], 'SELECT COUNT(*) FROM Worker'))
			SET @idWorker = (SELECT FLOOR(RAND()*(@idWorker-1+1))+1)

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

			--insert the delivery
			INSERT INTO OPENQUERY([MASTERDBPOSTGRES], 'SELECT idWorker, idClient, idSale, storeName, cost_ FROM Sale')
					VALUES (@idWorker, @idClient, @idSale, @storeName, @distante*10)

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

--PRODUCTS








