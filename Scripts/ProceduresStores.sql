USE ScotlandStore
GO


--CRUD Productos
CREATE PROCEDURE CreateProduct(
	@name_ VARCHAR(16),
	@aged VARCHAR(16),
	@idSupplier INT,
	@presentation VARCHAR(64),
	@currency VARCHAR(16),
	@cost_ INT,
	@idTypeProduct INT,
	@special BIT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			INSERT INTO OPENQUERY ([MASTERDBPOSTGRES], 
			'SELECT name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special FROM Product')
			VALUES(@name_, @aged, @idSupplier, @presentation, @currency, @cost_, @idTypeProduct, @special)

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

DROP PROCEDURE ReadProduct
CREATE PROCEDURE ReadProduct(
	@name_ VARCHAR(16),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @sql varchar(800)
			SELECT @sql = 'SELECT * FROM OPENQUERY ([MASTERDBPOSTGRES],
			SELECT 
				name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special FROM Product 
			WHERE name_ = ' + @name_

			EXEC (@sql)

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

CREATE PROCEDURE UpdateProduct(
	@nameOld VARCHAR(16),
	@name_ VARCHAR(16),
	@aged VARCHAR(16),
	@idSupplier INT,
	@presentation VARCHAR(64),
	@currency VARCHAR(16),
	@cost_ INT,
	@idTypeProduct INT,
	@special BIT,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @sql varchar(400)
			SELECT @sql = 'UPDATE OPENQUERY ([MASTERDBPOSTGRES], ''
			SELECT 
				name_, aged, idSupplier, presentation, currency, cost_, idTypeProduct, special FROM Product 
			WHERE name_ = ' + @nameOld + ''')
			SET name_ = '+QUOTENAME(@name_,'''')+', 
				aged = '+QUOTENAME(@aged,'''')+', 
				idSupplier = '+QUOTENAME(CONVERT(VARCHAR, @idSupplier),'''')+', 
				presentation = '+QUOTENAME(@presentation,'''')+',  
				currency = '+QUOTENAME(@currency,'''')+', 
				cost_ = '+QUOTENAME(CONVERT(VARCHAR, @cost_),'''')+', 
				idTypeProduct = '+QUOTENAME(CONVERT(VARCHAR, @idTypeProduct),'''')+', 
				special = '+QUOTENAME(CONVERT(VARCHAR, @special),'''')

			EXEC (@sql)

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

CREATE PROCEDURE DeleteProduct(
	@name_ VARCHAR(16),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @sql varchar(200)
			SELECT @sql = 'UPDATE OPENQUERY ([MASTERDBPOSTGRES], ''SELECT active_ FROM Product WHERE name_ = ' + @name_ + ''')
			SET active_ = 0'

			EXEC (@sql)

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

EXEC ReadProduct 'luis', 0





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
					p.idImage
				FROM Inventory i, Client c
					[MASTERDBPOSTGRES].MasterDB.[public].product p,
					[MASTERDBPOSTGRES].MasterDB.[public].producttype t,
				WHERE quantity>0
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND @idClient = c.id
				AND p.special = 0
				END
			ELSE
				BEGIN
				SELECT i.idProduct, 
					i.quantity,
					p.name_,
					p.aged,
					p.presentation,
					p.currency,
					p.cost_,
					t.name_,
					p.idImage
				FROM Inventory i, Client c
					[MASTERDBPOSTGRES].MasterDB.[public].product p,
					[MASTERDBPOSTGRES].MasterDB.[public].producttype t,
				WHERE quantity>0
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND @idClient = c.id
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


