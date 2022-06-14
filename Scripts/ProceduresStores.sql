USE ScotlandStore
GO

-- USER
--create a user

CREATE PROCEDURE CreateUser_(
	@username VARCHAR(16),
	@pass VARCHAR(64),
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
			SET @pssb = (ENCRYPTBYPASSPHRASE(@key, @pass))

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
			IF EXISTS (SELECT id FROM User_ WHERE username=@username)
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
				select i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_,
					i2.image_ 
					from inventory i, openquery(MASTERDBPOSTGRES,'Select * from product;') p, 
						openquery(MASTERDBPOSTGRES,'Select * from producttype;') t, openquery(MASTERDBPOSTGRES,'Select * from image_;') i2 
					where quantity > 0
						AND p.id = i.idProduct
						AND p.idTypeProduct = t.id
						AND p.special = 0 --just the no special
						AND i2.idProduct = p.id
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
					t.name_,
					i2.image_ 
					from inventory i, openquery(MASTERDBPOSTGRES,'Select * from product;') p, 
						openquery(MASTERDBPOSTGRES,'Select * from producttype;') t, openquery(MASTERDBPOSTGRES,'Select * from image_;') i2 
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
--FUNCTIONALITIES
--buy a product
CREATE or alter PROCEDURE BuyWhisky(
	@idStore int,
	@idClient int,
	@idProduct int,
	@quantity int,
	@delivery int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			
			--define date
			DECLARE @date DATE = CONVERT(DATE, GETDATE());
			print @date
			--decrease the quantity of the product
			UPDATE Inventory
			SET quantity = quantity-@quantity
			WHERE idProduct = @idProduct

			--insert the sale
			insert into openquery(MASTERDBPOSTGRES, 'SELECT idstore, idclient,idproduct,quantity,date_,deliverycost FROM Sale') 
				VALUES (@idStore,@idClient,@idClient,@quantity,@date,@delivery)

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








