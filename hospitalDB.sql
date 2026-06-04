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
CREATE TABLE Pacientes
GO

CREATE TABLE Medicos
GO

CREATE TABLE Especialidades
GO

CREATE TABLE Citas
GO

CREATE TABLE Habitaciones
GO

CREATE TABLE Tratamientos
GO

CREATE TABLE Medicamentos
GO