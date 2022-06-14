CREATE DATABASE Biblioteca
GO
USE Biblioteca
GO

--TABLAS

CREATE TABLE Libro(
	id int IDENTITY(1,1),
	nombre varchar(16),
	codigo varchar(16),
	autor varchar(16),

	CONSTRAINT pk_Libro PRIMARY KEY (id)
);


CREATE TABLE Empleado(
	id int IDENTITY(1,1),
	nombre varchar(16),
	cedula varchar(16),
	CONSTRAINT pk_Empleado PRIMARY KEY (id)
);


CREATE TABLE Prestamo(
	id int IDENTITY(1,1),
	fechaPrestamo date,
	idLibro int,
	idUsuario int,
	cedula int,
	estudiante bit,
	fechaVencimiento date,
	entregado bit,
	multa int,

	CONSTRAINT pk_Prestamo PRIMARY KEY (id)
);





-- RELACIONES SIMPLES

-- Fk Prestamo -> Libro
ALTER TABLE Prestamo
ADD CONSTRAINT fkPrestamo_Libro
FOREIGN KEY(idLibro)
REFERENCES Libro (id);


GO
-- PROCEDIMIENTOS


-- Consulta de libros
CREATE PROCEDURE VerLibro(@nombre varchar(16),@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			
			SELECT id, nombre, autor, codigo
			FROM Libro
			WHERE nombre=@nombre

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

-- Ve todos los libros
CREATE PROCEDURE VerTodosLibro(@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1
			
			SELECT id, nombre, autor, codigo
			FROM Libro
			
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


-- Consulta de prestamos vencidos
CREATE PROCEDURE VerPrestamosVencidos(@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @fecha date = CONVERT(DATE, GETDATE())
			
			SELECT id, idLibro, idUsuario, fechaPrestamo, fechaVencimiento, entregado, multa
			FROM Prestamo
			WHERE fechaVencimiento<@fecha

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


-- Consulta de prestamos activos
CREATE PROCEDURE VerPrestamosActivos(@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @fecha date = CONVERT(DATE, GETDATE())
			
			SELECT id, idLibro, idUsuario, fechaPrestamo, fechaVencimiento, entregado, multa
			FROM Prestamo
			WHERE fechaVencimiento>=@fecha

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

--consulta de prestamos, todo el historial
CREATE PROCEDURE ConsultaDePrestamos(@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION T1

			DECLARE @fecha date = CONVERT(DATE, GETDATE())
			
			SELECT id, idLibro, idUsuario, fechaPrestamo, fechaVencimiento, entregado, multa
			FROM Prestamo

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

--realizar Prestamo
DROP PROCEDURE RealizarPrestamo;  
GO 
CREATE PROCEDURE RealizarPrestamo(@fechaPrestamo date,@idLibro int, 
	@idUsuario int,@cedula int, @estudiante bit,@fechaVencimiento date,@entregado bit, @multa int,@outCodeResult int OUTPUT)

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY		
		BEGIN TRANSACTION T1
			IF(@estudiante = 1)	
				BEGIN
					DECLARE @hayDeuda int
					SET @hayDeuda = (select * from openquery(CONEXION,'Select id from Financiero.morosos;') where id = @idUsuario)	
					IF(@hayDeuda > 0)
						BEGIN
							print 'El estudiante tiene una deuda con financiero y no puede apartar libros';
						END
					ELSE
						BEGIN
							INSERT INTO Prestamo(fechaPrestamo,idLibro,idUsuario,cedula,estudiante,fechaVencimiento,entregado,multa)
								VALUES(@fechaPrestamo,@idLibro, @idUsuario,@cedula, @estudiante,@fechaVencimiento,@entregado, @multa)
						END
				END
			ELSE
				BEGIN
					DECLARE @activo bit
					SET @activo = (Select estado from RecursosHumanosCartago.dbo.PlazaCartago where cedula = @cedula)
					IF(@activo = 1)
						BEGIN
							print'EL profesor se encuentra activo en Cartago'
							INSERT INTO Prestamo(fechaPrestamo,idLibro,idUsuario,cedula,estudiante,fechaVencimiento,entregado,multa)
								VALUES(@fechaPrestamo,@idLibro, @idUsuario,@cedula, @estudiante,@fechaVencimiento,@entregado, @multa)
						END
					ELSE
						BEGIN
							SET @activo = (Select estado from RecursosHumanosSanJose.dbo.PlazaSanJose where cedula = @cedula)
							IF(@activo = 1)
								BEGIN
									print'Profesor activo en San José'
									INSERT INTO Prestamo(fechaPrestamo,idLibro,idUsuario,cedula,estudiante,fechaVencimiento,entregado,multa)
									VALUES(@fechaPrestamo,@idLibro, @idUsuario,@cedula, @estudiante,@fechaVencimiento,@entregado, @multa)
								END
							ELSE
								BEGIN
									SET @activo = (Select estado from RecursosHumanosAlajuela.dbo.PlazaAlajuela where cedula = @cedula)
									IF(@activo = 1)
										BEGIN
											print'Profesor activo en Alajuela'
											INSERT INTO Prestamo(fechaPrestamo,idLibro,idUsuario,cedula,estudiante,fechaVencimiento,entregado,multa)
											VALUES(@fechaPrestamo,@idLibro, @idUsuario,@cedula, @estudiante,@fechaVencimiento,@entregado, @multa)
										END
									ELSE
										BEGIN
											print'El profesor no está activo en ninguna plaza o no se ha encontrado'
										END
								END
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


-- datos de prueba

--Biblioteca.Empleado
	INSERT INTO Empleado(nombre,cedula)
	VALUES ('Jonny Melavo',123432);

	INSERT INTO Empleado(nombre,cedula)
	VALUES ('Jonny Melavo',123432);	


--Biblioteca.Libro

	INSERT INTO Libro(nombre,codigo,autor)
		VALUES ('Algebra Baldor','MA01','Baldor');

	INSERT INTO Libro(nombre,codigo,autor)
		VALUES ('Estadistica 2','MA02','Arturo');

	INSERT INTO Libro(nombre,codigo,autor)
		VALUES ('TASM 101','CO01','Kirstein');

	INSERT INTO Libro(nombre,codigo,autor)
		VALUES ('Bases 3','CO02','Alicia');


	INSERT INTO Libro(nombre,codigo,autor)
		VALUES ('C--','CO03','Araya E');


/*		
--Biblioteca.Prestamo 

	--VALUES(@fechaPrestamo,@idLibro, @idUsuario,@cedula, @estudiante,@fechaVencimiento,@entregado, @multa,outcode)
	
	exec RealizarPrestamo'2008-11-11',1,1,11764,1,'2015-11-30',0,0,0 --este estudiante tiene una deuda
	
	exec RealizarPrestamo'2019-11-11',1,3,11766,1,'2025-11-30',0,0,0 --este estudiante NO tiene una deuda
	
	exec RealizarPrestamo'2008-11-11',1,4,11765,1,'2009-11-30',0,0,0 --este estudiante NO tiene una deuda
	
	exec RealizarPrestamo'2020-10-20',1,1,111555,0,'2024-10-30',0,0,0 --Profesor activo de San Jose
	
	exec RealizarPrestamo'2020-10-20',1,1,111444,0,'2024-10-30',0,0,0 --Profesor inactivo de San Jose

*/

--Consulta de Prestamos activos
--exec VerPrestamosActivos 0

--Consulta de libros
--exec verLibro 'C--',0

--ver todos los libros
--exec VerTodosLibro 0

--ver Prestamos
--exec ConsultaDePrestamos 0

--ver prestamos vencidos
--exec VerPrestamosVencidos 0

