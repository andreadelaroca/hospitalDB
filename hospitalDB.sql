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
	, edad INT CONSTRAINT CK_edad_val_pac CHECK(edad > 0) --17. CHECK para edad mayor o igual a 0.
	, fechaRegistro DATETIME NOT NULL DEFAULT GETDATE() --19. Agregar DEFAULT para fecha de registro.
	, fechaActualizado DATETIME NULL DEFAULT GETDATE()
	, fechaEliminado DATETIME NULL
)
GO

--6. Creación de tabla Especialidades
CREATE TABLE Empleados.Especialidades (
	idEspecialidad INT IDENTITY(1,1) CONSTRAINT PK_Especialidad PRIMARY KEY
	, nombre NVARCHAR(30) NOT NULL
	, fechaRegistro DATETIME NOT NULL DEFAULT GETDATE() --19. Agregar DEFAULT para fecha de registro.
	, fechaActualizado DATETIME NULL DEFAULT GETDATE()
	, fechaEliminado DATETIME NULL
)
GO

--5. Creación de tabla Medicos
CREATE TABLE Empleados.Medicos (
	idMedico INT IDENTITY(1,1) CONSTRAINT PK_idMedico PRIMARY KEY --12. PK Medicos
	, nombres NVARCHAR(60) NOT NULL --14. nombre NOT NULL 
	, apellidos NVARCHAR(60) NOT NULL
	, correo NVARCHAR(100) CONSTRAINT UQ_correo_med UNIQUE --16. correo UNIQUE
	, edad INT CONSTRAINT CK_edad_val_med CHECK(edad > 0) --17. CHECK para edad mayor o igual a 0.
	, salario DECIMAL(5,2) CONSTRAINT CK_salario_val CHECK(salario > 0) --18. CHECK salario mayor a 0.
	, idEspecialidad INT CONSTRAINT FK_idEspecialidad REFERENCES Empleados.Especialidades(idEspecialidad) --20. FOREIGN KEY entre Médicos y Especialidades.
	, fechaRegistro DATETIME NOT NULL DEFAULT GETDATE() --19. Agregar DEFAULT para fecha de registro.
	, fechaActualizado DATETIME NULL DEFAULT GETDATE()
	, fechaEliminado DATETIME NULL
)
GO

--7. Creación de tabla Citas
CREATE TABLE Gestiones.Citas (
	idCita INT IDENTITY(1,1) CONSTRAINT PK_idCita PRIMARY KEY
	, fecha DATETIME NOT NULL
	, idPaciente INT CONSTRAINT FK_idPaciente REFERENCES Gestiones.Pacientes(idPaciente) --21. FOREIGN KEY entre Citas y Pacientes
	, idMedico INT CONSTRAINT FK_idMedico REFERENCES Empleados.Medicos(idMedico) --22. FOREIGN KEY entre Citas y Médicos
	, fechaRegistro DATETIME NOT NULL DEFAULT GETDATE() --19. Agregar DEFAULT para fecha de registro.
	, fechaActualizado DATETIME NULL DEFAULT GETDATE()
	, fechaEliminado DATETIME NULL
)
GO

--8. Creación de tabla Habitaciones
CREATE TABLE Hospital.Habitaciones (
	idHabitacion INT IDENTITY(1,1) CONSTRAINT PK_idHabitacion PRIMARY KEY
	, edificio CHAR NOT NULL
	, codigo VARCHAR(20) NOT NULL
	, idPaciente INT NULL CONSTRAINT FK_idPaciente FOREIGN KEY REFERENCES Gestiones.Pacientes(idPaciente) --25.FOREIGN KEY entre Habitaciones y Pacientes
)
GO

--9. Creación de tabla Tratamientos
CREATE TABLE Hospital.Tratamientos (
	idTratamiento INT IDENTITY(1,1) CONSTRAINT PK_idTratamiento PRIMARY KEY
	, descripcion NVARCHAR(60) NOT NULL
	, estado VARCHAR(20) CONSTRAINT CK_estado_val CHECK(estado IN ('Activo', 'En proceso', 'Finalizado'))
	, idPaciente INT FOREIGN KEY REFERENCES Gestiones.Pacientes(idPaciente) --23. FOREIGN KEY entre Tratamientos y Pacientes
	, fechaRegistro DATETIME NOT NULL DEFAULT GETDATE() --19. Agregar DEFAULT para fecha de registro.
	, fechaActualizado DATETIME NULL DEFAULT GETDATE()
	, fechaEliminado DATETIME NULL
)
GO

--10. Creación de tabla Medicamentos
CREATE TABLE Hospital.Medicamentos (
	idMedicamento INT IDENTITY(1,1) CONSTRAINT PK_idMedicamento PRIMARY KEY
	, idTratamiento INT CONSTRAINT FK_idTratamiento FOREIGN KEY REFERENCES Hospital.Tratamientos(idTratamiento) -- 24. FOREIGN KEY entre Medicamentos y Tratamientos.
	, nombre NVARCHAR(50) NOT NULL
	, estado VARCHAR(20) CONSTRAINT CK_estado_med_val CHECK(estado IN ('Vigente', 'Vencido'))
	, dosis DECIMAL (4,2) NOT NULL CONSTRAINT CK_dosis_val CHECK(dosis > 0)
)
GO

--26, 27, 28, 29, 30 Agregación de columnas a tabla Pacientes
ALTER TABLE Gestiones.Pacientes
	ADD telefono VARCHAR(60) NOT NULL
	, direccion NVARCHAR(120) NOT NULL
	, genero BIT NOT NULL
	, tipo_sangre VARCHAR(4) CONSTRAINT CK_tipo_sangre_val CHECK(tipo_sangre IN ('%A%', '%B%', 'O%', '%+', '%-'))
	, fechanac DATE CONSTRAINT CK_edad_val_med CHECK(fechanac >= GETDATE())
GO

--31, 32. Modificación de tabla Pacientes
ALTER TABLE Gestiones.Pacientes
	ALTER COLUMN nombres NVARCHAR(40) NOT NULL 
GO

ALTER TABLE Gestiones.Pacientes
	ALTER COLUMN direccion NVARCHAR(100) NOT NULL
GO

--33, 34 Agregación de columnas a tabla Medicos
ALTER TABLE Empleados.Medicos
	ADD experiencia NVARCHAR(120) NOT NULL
	, turno VARCHAR(10) CONSTRAINT CK_turno_val CHECK(turno IN ('Matutino', 'Diurno', 'Nocturno'))
GO

--35, 37, 38. Agregar columna observaciones
ALTER TABLE Gestiones.Citas
	ADD observaciones NVARCHAR(120) NOT NULL
	, estado VARCHAR(20) CONSTRAINT CK_estado_val CHECK(estado IN ('Agendada', 'Confirmada', 'En proceso', 'Completada', 'Cancelada', 'Inasistencia', 'Reprogramada'))
	, costo INT NOT NULL
GO

--36. Eliminar columna observaciones
ALTER TABLE Gestiones.Citas
	DROP COLUMN observaciones
GO

--39. Modificar tipo el dato costo
ALTER TABLE Gestiones.Citas
	ALTER COLUMN costo DECIMAL(4,2) NOT NULL
GO

--40. Agregar columna disponibilidad a Habitaciones
ALTER TABLE Hospital.Habitaciones
	ADD disponibilidad BIT DEFAULT 1
GO

--41. Eliminar una tabla temporal
DROP TABLE IF EXISTS tempdb.sys.tables
GO

--42. Eliminar una restricción CHECK
ALTER TABLE Gestiones.Pacientes
	DROP CONSTRAINT CK_tipo_sangre_val
GO

--43. Eliminar una restricción UNIQUE
ALTER TABLE Empleados.Medicos
	ADD idPaciente INT CONSTRAINT FK_idPaciente_med FOREIGN KEY REFERENCES Gestiones.Pacientes(idPaciente)
GO

ALTER TABLE Empleados.Medicos
	DROP CONSTRAINT Fk_idPaciente_med
GO

--44. Eliminar una columna
ALTER TABLE Hospital.Habitaciones
	DROP COLUMN edificio
GO

--45. Eliminar una tabla de pruebas
CREATE TABLE Hospital.Pruebas (
	nombres NVARCHAR(20)
)
GO

DROP TABLE IF EXISTS Hospital.Pruebas
GO

--46. Crear y eliminar una tabla Auditoria
CREATE TABLE Hospital.Auditoria (
	idAuditoria INT IDENTITY(1,1) PRIMARY KEY
	, operacion NVARCHAR(30) NOT NULL
)
GO

DROP TABLE IF EXISTS Hospital.Auditoria
GO

--47. Crear y eliminar una tabla Logs
CREATE TABLE Logs (
	idLogs INT IDENTITY(1,1) PRIMARY KEY
	, operacion NVARCHAR(30) NOT NULL
)
GO

DROP TABLE Logs
GO

--48. Eliminar una FOREIGN KEY
ALTER TABLE Hospital.Tratamientos
	ADD idMedico INT CONSTRAINT FK_idMedico_trat FOREIGN KEY REFERENCES Empleados.Medicos (idMedico)
GO

ALTER TABLE Hospital.Tratamientos
	DROP CONSTRAINT FK_idMedico_trat
GO

--49. Eliminar una tabla MedicamentosPrueba
CREATE TABLE Hospital.MedicamentosPrueba (
	medicamento NVARCHAR(20)
)
GO

DROP TABLE Hospital.MedicamentosPrueba
GO