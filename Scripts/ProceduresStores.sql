USE ScotlandStore
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

			UPDATE Inventory
			SET quantity = quantity-@quantity
			WHERE idProduct = @idProduct

			INSERT INTO OPENQUERY([MASTERDBPOSTGRES], 'SELECT date_, total')

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

INSERT INTO [MASTERDBPOSTGRES].MasterDB.[public].producttype (id, name_) VALUES(6, 'hola')



sp_addlinkedserver @server= 'MasterDB', 
	@srvproduct= 'product_name',
	@provider= 'provider_name', 
	@datasrc= 'data_source',
	@location= 'location',
	@provstr= 'provider_string',
	@catalog= 'catalog'

USE Master
GO

EXEC sp_addlinkedserver @server='MasterPostgreSQL',
@provider='SQLNCLI',
@datasrc='whiskypostgres.ckane6ejq4bl.us-west-1.rds.amazonaws.com,5432',
@catalog='CData PostgreSQL Sys',
@srvproduct='';
GO

USE Master
GO
EXEC sp_addlinkedsrvlogin @rmtsrvname='MasterPostgreSQL',
@rmtuser='admin123',
@rmtpassword='admin123',
@useself='FALSE',
@locallogin=NULL;
GO

SELECT * FROM OPENQUERY(MasterPostgreSQL, 'select * from Supplier');



USE master;
GRANT ALTER ANY LINKED SERVER TO admin;
GO
USE master;
GRANT ALTER ANY LOGIN SERVER TO admin; 