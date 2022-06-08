USE ScotlandStore
GO


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


EXEC CreateProduct 'luis', 'viejo', 1, 'buena', 'dolar', 10, 1, 0, 0

CREATE PROCEDURE GetProductByDistance(
	@idClient int,
	@name int,
	@special bit,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @temp TABLE(
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

			INSERT INTO @temp(id,
			name_,
			aged,
			idSupplier,
			presentation,
			currency,
			cost_,
			idTypeProduct,
			special,
			active_)
			SELECT * FROM OPENQUERY([MASTERDBPOSTGRES], 'SELECT 
				name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special, active_ FROM Product' )

			SELECT 
			c.location1.STDistance(s.location1) as Distance,
			i.quantity,
			t.id,
			t.name_,
			t.aged,
			--t.idSupplier,
			t.presentation,
			t.currency,
			t.cost_
			--t.idTypeProduct
			FROM @temp t, Client c, Store s, Inventory i
			WHERE active_ = 1
			AND (special = @special OR special = 0)
			AND i.idProduct = t.id

			UNION ALL

			SELECT 
			c.location1.STDistance(s.location1) as Distance,
			i.quantity,
			t.id,
			t.name_,
			t.aged,
			--t.idSupplier,
			t.presentation,
			t.currency,
			t.cost_
			--t.idTypeProduct
			FROM @temp t, Client c, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Inventory i
			WHERE active_ = 1
			AND (special = @special OR special = 0)
			AND i.idProduct = t.id

			UNION ALL

			SELECT 
			c.location1.STDistance(s.location1) as Distance,
			i.quantity,
			t.id,
			t.name_,
			t.aged,
			--t.idSupplier,
			t.presentation,
			t.currency,
			t.cost_
			--t.idTypeProduct
			FROM @temp t, Client c, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Inventory i
			WHERE active_ = 1
			AND (special = @special OR special = 0)
			AND i.idProduct = t.id

			ORDER BY Distance DESC

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



CREATE PROCEDURE GetProductByDistance(
	@uidClient int,
	@nameStore VARCHAR(32),
	@special bit,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(32),
			distance FLOAT)

			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM Inventory i, Store s, Client c
			WHERE i.idStore=s.id

			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			DECLARE @idSuscription INT
			SET @idSuscription = (SELECT idSuscription FROM Client WHERE uid=@uidClient)

			IF 2 > @idSuscription --if has none or low suscription
				BEGIN
				SELECT i.nameStore,
					i.distance
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_,
					i2.image_
				FROM @temp i,
					[MASTERDBPOSTGRES].MasterDB.[public].product p,
					[MASTERDBPOSTGRES].MasterDB.[public].producttype t,
					[MASTERDBPOSTGRES].MasterDB.[public].image_ i2
				WHERE quantity>0
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND p.special = 0
				AND i2.idProduct = p.id
				ORDER BY i.distance ASC
				END
			ELSE --if has high suscription
				BEGIN
				SELECT i.nameStore,
					i.distance
					i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_,
					i2.image_
				FROM @temp i,
					[MASTERDBPOSTGRES].MasterDB.[public].product p,
					[MASTERDBPOSTGRES].MasterDB.[public].producttype t,
					[MASTERDBPOSTGRES].MasterDB.[public].image_ i2
				WHERE quantity>0
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND i2.idProduct = p.id
				ORDER BY i.distance ASC
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