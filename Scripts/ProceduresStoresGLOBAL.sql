USE ScotlandStore
GO

--PROXIMITY
--shows all the invetories by distance
CREATE PROCEDURE GetEntireInventory(
	@uidClient int,
	@special bit,
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
			nameStore VARCHAR(32),
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

			--get the client suscription
			DECLARE @idSuscription INT
			SET @idSuscription = (SELECT idSuscription FROM Client WHERE uid=@uidClient)

			IF 2 > @idSuscription --if has none or low suscription shows normal products from temp
				BEGIN
				SELECT i.nameStore,
					i.distance,
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
			ELSE --if has high suscription shows normal and special products from temp
				BEGIN
				SELECT i.nameStore,
					i.distance,
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

--shows the products by name and the distance
CREATE PROCEDURE GetProductByName(
	@uidClient int,
	@nameProduct VARCHAR(32),
	@special bit,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--temp table to get all the products whit the same name
			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(32),
			distance FLOAT)

			--get the products from scotland
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [ScotlandStore].dbo.Inventory i, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Client c
			WHERE i.idStore=s.id

			--get the products from usa
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the products from ireland
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the suscription
			DECLARE @idSuscription INT
			SET @idSuscription = (SELECT idSuscription FROM Client WHERE uid=@uidClient)

			IF 2 > @idSuscription --if has none or low suscription shows normal products
				BEGIN
				SELECT i.nameStore,
					i.distance,
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
				AND p.name_ = @nameProduct
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND p.special = 0
				AND i2.idProduct = p.id
				ORDER BY i.distance ASC
				END
			ELSE --if has high suscription shows normal and special products
				BEGIN
				SELECT i.nameStore,
					i.distance,
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
				AND p.name_ = @nameProduct
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

--show products by name and distance
CREATE PROCEDURE GetProductByType(
	@uidClient int,
	@typeProduct VARCHAR(32),
	@special bit,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--temp table to get all the products and distance
			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(32),
			distance FLOAT)

			--get the products from scotland
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [ScotlandStore].dbo.Inventory i, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Client c
			WHERE i.idStore=s.id

			--get the products from usa
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the products from ireland
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get suscription of the client
			DECLARE @idSuscription INT
			SET @idSuscription = (SELECT idSuscription FROM Client WHERE uid=@uidClient)

			IF 2 > @idSuscription --if has none or low suscription
				BEGIN
				SELECT i.nameStore,
					i.distance,
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
				AND t.name_ = @typeProduct
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND p.special = 0
				AND i2.idProduct = p.id
				ORDER BY i.distance ASC
				END
			ELSE --if has high suscription
				BEGIN
				SELECT i.nameStore,
					i.distance,
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
				AND t.name_ = @typeProduct
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


--shows the products by cost and distance
CREATE PROCEDURE GetProductByCost(
	@uidClient int,
	@cost INT,
	@special bit,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			--temp table to get all the products
			DECLARE @temp TABLE(
			id INT,
			quantity INT,
			idProduct INT,
			nameStore VARCHAR(32),
			distance FLOAT)

			--get the products from scotland
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [ScotlandStore].dbo.Inventory i, [ScotlandStore].dbo.Store s, [ScotlandStore].dbo.Client c
			WHERE i.idStore=s.id

			--get the products from usa
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [USAStore].dbo.Inventory i, [USAStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the products from ireland
			INSERT INTO @temp(id, quantity, idProduct, nameStore, distance)
			SELECT i.id, i.quantity, i.idProduct, s.name_, c.location1.STDistance(s.location1)
			FROM [IrelandStore].dbo.Inventory i, [IrelandStore].dbo.Store s, Client c
			WHERE i.idStore=s.id

			--get the client suscription
			DECLARE @idSuscription INT
			SET @idSuscription = (SELECT idSuscription FROM Client WHERE uid=@uidClient)

			IF 2 > @idSuscription --if has none or low suscription
				BEGIN
				SELECT i.nameStore,
					i.distance,
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
				AND p.cost_ = @cost
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND p.special = 0
				AND i2.idProduct = p.id
				ORDER BY p.cost_ ASC
				END
			ELSE --if has high suscription
				BEGIN
				SELECT i.nameStore,
					i.distance,
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
				AND p.cost_ = @cost
				AND p.id = i.idProduct
				AND p.idTypeProduct = t.id
				AND i2.idProduct = p.id
				ORDER BY p.cost_ ASC
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



