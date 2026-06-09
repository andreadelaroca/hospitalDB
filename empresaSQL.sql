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
	, cNIF NVARCHAR(30) UNIQUE
	, cNombre NVARCHAR(60) NOT NULL
	, cApellido NVARCHAR(60) NOT NULL
	, nDepartamentoID INT CONSTRAINT FK_depid FOREIGN KEY REFERENCES Empresa.TDepartamento(nDepartamentoID)
	, nCargoID INT CONSTRAINT FK_cargoid REFERENCES Personal.TCargo(nCargoID)
	, dFechaContratacion DATE NOT NULL CONSTRAINT DF_fechacontrat DEFAULT GETDATE()
	, nSalario DECIMAL(6, 2) CONSTRAINT CK_salario CHECK(nSalario > 300)
	, created_at DATETIME NOT NULL DEFAULT GETDATE()
	, updated_at DATETIME NOT NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL
)
GO

CREATE TABLE Empresa.TProyecto (
	nProyectoID INT IDENTITY(1,1) CONSTRAINT PK_proyid PRIMARY KEY
	, cNombre NVARCHAR(80) NOT NULL
	, dFechaInicio DATE NOT NULL
	, dFechaFinalizacion DATE
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
	ADD cEmail NVARCHAR(120) CONSTRAINT CK_empemail CHECK(cEmail LIKE '%.%@%')
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