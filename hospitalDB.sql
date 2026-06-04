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
CREATE SCHEMA Pacientes
GO

CREATE SCHEMA Medicos
GO

CREATE SCHEMA Hospital
GO

--4. Creación de tabla Pacientes
CREATE TABLE Pacientes.Pacientes (
	idPaciente INT IDENTITY(1,1) CONSTRAINT PK_idPaciente PRIMARY KEY --11. PK Pacientes
)
GO

--5. Creación de tabla Medicos
CREATE TABLE Medicos.Medicos
	idMedico INT IDENTITY(1,1) CONSTRAINT PK_idMedico PRIMARY KEY --12. PK Medicos
GO

--6. Creación de tabla Especialidades
CREATE TABLE Medicos.Especialidades
GO

--7. Creación de tabla Citas
CREATE TABLE Pacientes.Citas
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

