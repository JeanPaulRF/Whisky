USE ScotlandStore
GO

-- USER

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

			INSERT INTO User_(username, @pssb, key_, administrator, idClient, idUserType)
			VALUES(@username, @pass, @key, @administrator, @idClient, @idUserType)

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


CREATE PROCEDURE isUserCorrect(
	@username VARCHAR(16),
	@pass VARCHAR(64),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			IF EXISTS (SELECT CONVERT(varchar(64), DECRYPTBYPASSPHRASE(key_, pass)) FROM User_ WHERE username=@username)
			BEGIN
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

CREATE PROCEDURE ShowInventory(@idClient int, @outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

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
				AND p.special = 0
				AND i2.idProduct = p.id
				END
			ELSE --if has high suscription
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

			DECLARE @fecha DATE = CONVERT(DATE, GETDATE());

			UPDATE Inventory
			SET quantity = quantity-@quantity
			WHERE idProduct = @idProduct

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





--PRODUCTS








