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

--4.2 Creación de tablas
CREATE TABLE Pacientes.Pacientes
GO

CREATE TABLE Medicos.Medicos
GO

CREATE TABLE Medicos.Especialidades
GO

CREATE TABLE Pacientes.Citas
GO

CREATE TABLE Hospital.Habitaciones
GO

CREATE TABLE Hospital.Medicamentos
GO

CREATE TABLE Hospital.Tratamientos
GO

