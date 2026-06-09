--Parte I. Creación de Base de Datos y Tablas (DDL)
USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'EmpresaSQL')
	BEGIN
		ALTER DATABASE EmpresaSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE EmpresaSQL
	END
GO

CREATE DATABASE EmpresaSQL
GO

USE EmpresaSQL
GO

CREATE SCHEMA Empresa
GO

CREATE SCHEMA Personal
GO

CREATE TABLE Empresa.TDepartamento (
	nDepartamentoID INT IDENTITY(1,1) CONSTRAINT PK_depid PRIMARY KEY
	, cNombreDepartamento NVARCHAR(60) NOT NULL CONSTRAINT UQ_depnombre UNIQUE
	, created_at DATETIME NOT NULL DEFAULT GETDATE()
	, updated_at DATETIME NOT NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL
)
GO

CREATE TABLE Personal.TCargo (
	nCargoID INT IDENTITY(1,1) CONSTRAINT PK_cargoid PRIMARY KEY
	, cNombreCargo NVARCHAR(60) NOT NULL CONSTRAINT UQ_cargonombre UNIQUE
	, created_at DATETIME NOT NULL DEFAULT GETDATE()
	, updated_at DATETIME NOT NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL
)
GO

CREATE TABLE Personal.TEmpleado (
	nEmpleadoID INT IDENTITY(1,1) CONSTRAINT PK_emplid PRIMARY KEY
	, cNIF NVARCHAR(9) UNIQUE
	, cNombre NVARCHAR(60) NOT NULL
	, cApellido NVARCHAR(60) NOT NULL
	, nDepartamentoID INT CONSTRAINT FK_depid FOREIGN KEY REFERENCES Empresa.TDepartamento(nDepartamentoID)
	, nCargoID INT CONSTRAINT FK_cargoid REFERENCES Personal.TCargo(nCargoID)
	, dFechaContratacion DATE NOT NULL CONSTRAINT DF_fechacontrat DEFAULT GETDATE()
	, nSalario DECIMAL(8, 2) CONSTRAINT CK_salario CHECK(nSalario > 300)
	, created_at DATETIME NOT NULL DEFAULT GETDATE()
	, updated_at DATETIME NOT NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL
)
GO

CREATE TABLE Empresa.TProyecto (
	nProyectoID INT IDENTITY(1,1) CONSTRAINT PK_proyid PRIMARY KEY
	, cNombre NVARCHAR(80) NOT NULL
	, dFechaInicio DATE NOT NULL
	, dFechaFinalizacion DATE NULL
	, created_at DATETIME NOT NULL DEFAULT GETDATE()
	, updated_at DATETIME NOT NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL
)
GO

CREATE TABLE Empresa.TEmpleadoProyecto (
	nProyectoID INT CONSTRAINT FK_proyid FOREIGN KEY REFERENCES Empresa.TProyecto(nProyectoID)
	, nEmpleadoID INT CONSTRAINT FK_empid FOREIGN KEY REFERENCES Personal.TEmpleado(nEmpleadoID)
	PRIMARY KEY (nProyectoID, nEmpleadoID)
	, created_at DATETIME NOT NULL DEFAULT GETDATE()
	, updated_at DATETIME NOT NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL
)
GO

--Parte II. Modificación de Estructuras (ALTER)
ALTER TABLE Personal.TEmpleado
	ADD cEmail NVARCHAR(120) CONSTRAINT CK_empemail CHECK(cEmail LIKE '%_@__%.__%')
	, cTelefono NVARCHAR(60)
	, cDireccion NVARCHAR(120)
	, nEdad INT
	, bActivo BIT DEFAULT 1
	, cGenero CHAR
	, dFechaNacimiento DATE
GO

ALTER TABLE Personal.TEmpleado
	ALTER COLUMN cNombre NVARCHAR(100)
GO

ALTER TABLE Personal.TEmpleado
	ALTER COLUMN cApellido NVARCHAR(100)
GO

ALTER TABLE Personal.TEmpleado
	ADD CONSTRAINT CK_empedadval CHECK(nEdad BETWEEN 18 AND 65)
	, CONSTRAINT UQ_empemail UNIQUE(cEmail)
	, CONSTRAINT CK_empgenero CHECK(cGenero IN ('M', 'F'))
	, CONSTRAINT CK_empfechanac CHECK(dFechaNacimiento > GETDATE())
GO

ALTER TABLE Personal.TEmpleado
	DROP cDireccion
GO

ALTER TABLE Personal.TEmpleado
	ALTER COLUMN cTelefono VARCHAR(60)
GO

CREATE TABLE Empresa.TSucursal (
	nSucursalID INT IDENTITY(1,1) CONSTRAINT PK_sucid PRIMARY KEY
	, cDireccion NVARCHAR(120)
)
GO

--Parte III. Inserción de Datos (INSERT)
INSERT INTO Empresa.TDepartamento(cNombreDepartamento) VALUES
	('Gerencia General'), ('Mercadeo')
	, ('Recursos Humanos'), ('Contabilidad y Finanzas')
	, ('Comercial')
GO

INSERT INTO Personal.TCargo(cNombreCargo) VALUES
	('Gerente General'), ('Analista de Mercado')
	, ('Contador'), ('Asesor de Reclutamiento')
	, ('Auditor')
GO

INSERT INTO Personal.TEmpleado(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, cGenero, dFechaNacimiento) VALUES 
	('12345678A', 'Andrea', 'de la Roca', 1, 1, 100000, 'asodelaroca@uamv.edu.ni', '11111111', 19, 'F', '2007-01-15')
	, ('22345678B', 'Johnny', 'Calero', 2, 2, 301, 'jacq@uamv.edu.ni', '22222222', 19, 'M', '2006-11-16')
	, ('32345678C', 'Noa', 'Reyes', 4, 3, 100000, 'naam@gmail.com', '33333333', 19, 'F', '2007-03-20')
	, ('42345678D', 'Bandrea', 'be la Roca', 4, 3, 20000, 'si@uamv.edu.ni', '44444444', 80, 'F', '2006-01-16')
	, ('52345678E', 'Candrea', 'ce la Roca', 4, 5, 40000, 'no@gmail.com', '55555555', 36, 'F', '2000-08-27')
	, ('62345678F', 'Dandrea', 'e la Roca', 5, 5, 350000, 'talvez@gmail.com', '66666666', 27, 'M', '1999-12-30')
	, ('72345678E', 'Endrea', 'la Roca', 1, 2, 100000, '67@mgial.com', '77777777', 20, 'F', '1987-06-07')
	, ('82345678G', 'Fandrea', 'fe la Roca', 3, 3, 302, 'aaaa@gmail.ni', '88888888', 35, 'M', '1999-02-13')
	, ('92345678H', 'Handrea', 'he la Roca', 5, 4, 7000, 'gmail@uamv.edu.ni', '99999999', 25, 'M', '2003-05-05')
	, ('02345678J', 'Jandrea', 'je la Roca', 2, 2, 3000, 'uam@uamv.edu.ni', '00000000', 64, 'F', '2000-04-04')
GO

INSERT INTO Empresa.TProyecto(cNombre, dFechaInicio) VALUES
	('Proyecto 67', '2000-05-05')
	, ('Proyecto Bubulabubu chocorron', '2002-06-06')
	, ('Proyecto César', '2003-07-07')
GO

INSERT INTO Empresa.TEmpleadoProyecto(nProyectoID, nEmpleadoID) VALUES
	(1, 1), (1, 2), (1, 3)
	, (2, 4), (2, 5), (2, 6)
	, (3, 7), (3, 8), (3, 9), (3, 10)
GO

--Parte IV. Actualización de Datos (UPDATE)
UPDATE Personal.TEmpleado SET nSalario = nSalario + (nSalario * 0.1)
GO

UPDATE Personal.TEmpleado SET nSalario = nSalario + (nSalario * 0.2) WHERE nDepartamentoID = 1
GO

UPDATE Personal.TEmpleado SET cEmail = 'pepetilin@gmail.com' WHERE nEmpleadoID = 1
GO

UPDATE Personal.TEmpleado SET nCargoID = 1 WHERE nEmpleadoID = 3
GO

UPDATE Personal.TEmpleado SET nDepartamentoID = 2 WHERE nEmpleadoID IN (3, 4)
GO

UPDATE Personal.TEmpleado SET bActivo = 0 WHERE nSalario < 500
GO

UPDATE Empresa.TProyecto SET dFechaFinalizacion = '2030-01-01' WHERE nProyectoID = 1
GO

INSERT INTO Empresa.TEmpleadoProyecto(nEmpleadoID, nProyectoID) VALUES (1, 5)
GO