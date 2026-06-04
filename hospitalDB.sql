--MÓDULO 1: CREACIÓN DE LA BASE DE DATOS 
USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'HospitalDB')
	BEGIN
		ALTER DATABASE HospitalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE HospitalDB
	END
GO

--1. Crear una base de datos llamada HospitalDB
CREATE DATABASE HospitalDB
GO

--2. Mostrar todas las bases de datos existentes.
SELECT * FROM sys.databases
GO

--3. Seleccionar HospitalDB para trabajar
USE HospitalDB
GO

--4.1 Creación de esquemas
CREATE SCHEMA Gestiones
GO

CREATE SCHEMA Empleados
GO

CREATE SCHEMA Hospital
GO

--4. Creación de tabla Pacientes
CREATE TABLE Gestiones.Pacientes (
	idPaciente INT IDENTITY(1,1) CONSTRAINT PK_idPaciente PRIMARY KEY --11. PK Pacientes
	, nombres NVARCHAR(60) NOT NULL --13. nombre NOT NULL
	, apellidos NVARCHAR(60) NOT NULL
	, correo NVARCHAR(100) CONSTRAINT UQ_correo_pac UNIQUE --15. correo UNIQUE
	, edad TINYINT CONSTRAINT CK_edad_val_pac CHECK(edad > 0) --17. CHECK para edad mayor o igual a 0.
	, fechaRegistro DATETIME NOT NULL DEFAULT GETDATE() --19. Agregar DEFAULT para fecha de registro.
	, fechaActualizado DATETIME NULL DEFAULT GETDATE()
	, fechaEliminado DATETIME NULL
)
GO

--6. Creación de tabla Especialidades
CREATE TABLE Empleados.Especialidades (
	idEspecialidad INT IDENTITY(1,1) CONSTRAINT PK_Especialidad PRIMARY KEY
	, nombre NVARCHAR(30) NOT NULL
)
GO

--5. Creación de tabla Medicos
CREATE TABLE Empleados.Medicos (
	idMedico INT IDENTITY(1,1) CONSTRAINT PK_idMedico PRIMARY KEY --12. PK Medicos
	, nombres NVARCHAR(60) NOT NULL --14. nombre NOT NULL 
	, apellidos NVARCHAR(60) NOT NULL
	, correo NVARCHAR(100) CONSTRAINT UQ_correo_med UNIQUE --16. correo UNIQUE
	, edad DATE CONSTRAINT CK_edad_val_med CHECK(edad > 0) --17. CHECK para edad mayor o igual a 0.
	, salario DECIMAL(5,2) CONSTRAINT CK_salario_val CHECK(salario > 0) --18. CHECK salario mayor a 0.
	, idEspecialidad INT CONSTRAINT FK_idEspecialidad REFERENCES Empleados.Especialidades(idEspecialidad) --20. FOREIGN KEY entre Médicos y Especialidades.
	, fechaRegistro DATETIME NOT NULL DEFAULT GETDATE() --19. Agregar DEFAULT para fecha de registro.
	, fechaActualizado DATETIME NULL DEFAULT GETDATE()
	, fechaEliminado DATETIME NULL
)
GO

--7. Creación de tabla Citas
CREATE TABLE Gestiones.Citas
GO

--8. Creación de tabla Habitaciones
CREATE TABLE Hospital.Habitaciones
GO

--9. Creación de tabla Medicamentos
CREATE TABLE Hospital.Medicamentos
GO

--10. Creación de tabla Tratamientos
CREATE TABLE Hospital.Tratamientos
GO


--, fechanac DATE CONSTRAINT CK_edad_val_med CHECK(fechanac >= GETDATE()) --17. CHECK para edad mayor o igual a 0.