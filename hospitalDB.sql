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
	, fechanac DATE
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

--50. Eliminar una base de datos de pruebas
USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'Prueba')
	BEGIN
		ALTER DATABASE Prueba SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE Prueba
	END
GO

CREATE DATABASE Prueba
GO

DROP DATABASE Prueba
GO

USE HospitalDB
GO

--51. Insertar 5 especialidades médicas
INSERT INTO Empleados.Especialidades (nombre) VALUES 
	('Cardiología'),
	('Pediatría'),
	('Neurología'),
	('Dermatología'),
	('Traumatología')
GO


--52, 59. Insertar 10 médicos
INSERT INTO Empleados.Medicos (nombres, apellidos, correo, edad, salario, idEspecialidad, experiencia, turno) VALUES
	('Carlos', 'Pérez', 'carlos.perez@hospital.com', 45, 850.50, 1, '15 años en cardiología clínica', 'Matutino'),
	('Ana', 'Gómez', 'ana.gomez@hospital.com', 38, 720.00, 2, '10 años en pediatría neonatal', 'Diurno'),
	('Luis', 'Martínez', 'luis.martinez@hospital.com', 50, 950.00, 3, '20 años en neurocirugía', 'Nocturno'),
	('María', 'Rodríguez', 'maria.rodriguez@hospital.com', 41, 680.75, 4, '8 años en dermatología estética', 'Matutino'),
	('Jorge', 'López', 'jorge.lopez@hospital.com', 47, 890.00, 5, '12 años en traumatología deportiva', 'Diurno'),
	('Sofía', 'Sánchez', 'sofia.sanchez@hospital.com', 35, 710.25, 1, '5 años en insuficiencia cardíaca', 'Nocturno'),
	('Pedro', 'Ramírez', 'pedro.ramirez@hospital.com', 52, 980.00, 2, '22 años en pediatría integral', 'Matutino'),
	('Elena', 'Torres', 'elena.torres@hospital.com', 39, 790.50, 3, '9 años en enfermedades neuromusculares', 'Diurno'),
	('David', 'Flores', 'david.flores@hospital.com', 43, 650.00, 4, '11 años en cáncer de piel', 'Nocturno'),
	('Laura', 'Castro', 'laura.castro@hospital.com', 46, 875.30, 5, '14 años en cirugía de reemplazo articular', 'Matutino')
GO

--53, 58. Insertar 20 pacientes
INSERT INTO Gestiones.Pacientes (nombres, apellidos, correo, edad, telefono, direccion, genero, tipo_sangre, fechanac) VALUES
	('Juan', 'Jiménez', 'juan.jimenez@mail.com', 25, '55580101', 'Calle Falsa 123', 1, 'O+', '2001-01-02'),
	('Lucía', 'Díaz', 'lucia.diaz@mail.com', 30, '55590102', 'Av. Central 456', 0, 'A+', '1996-02-03'),
	('Miguel', 'Álvarez', 'miguel.alvarez@mail.com', 45, '55590103', 'Pasaje Los Pinos 789', 1, 'B+', '1981-03-12'),
	('Rosa', 'Moreno', 'rosa.moreno@mail.com', 60, '55530104', 'Alameda Principal 101', 0, 'O-', '1966-04-15'),
	('Daniel', 'Benítez', 'daniel.benitez@mail.com', 18, '55530105', 'Callejón Oscuro 202', 1, 'AB+', '2008-05-07'),
	('Carmen', 'Ruiz', 'carmen.ruiz@mail.com', 34, '55530106', 'Boulevard Norte 303', 0, 'A-', '1992-06-05'),
	('Alejandro', 'Gutiérrez', 'alejandro.gut@mail.com', 22, '55520107', 'Avenida del Sol 404', 1, 'O+', '2004-06-11'),
	('Patricia', 'Ortega', 'patricia.ort@mail.com', 29, '55540108', 'Ruta 66 Kilómetro 5', 0, 'B-', '1997-07-22'),
	('Roberto', 'Rubio', 'roberto.rubio@mail.com', 51, '55510109', 'Calle Las Flores 505', 1, 'A+', '1974-08-27'),
	('Francisca', 'Marín', 'fran.marin@mail.com', 40, '55560110', 'Avenida de la Paz 606', 0, 'O+', '1986-09-20'),
	('Santiago', 'Sanz', 'santiago.sanz@mail.com', 12, '55570111', 'Barrio Universitario 707', 1, 'AB-', '2014-10-08'),
	('Teresa', 'Nuñez', 'teresa.nunez@mail.com', 68, '55550112', 'Residencial El Lago 808', 0, 'O+', '1958-11-26'),
	('Ricardo', 'Medina', 'ricardo.med@mail.com', 37, '52570113', 'Calle del Oro 909', 1, 'A+', '1989-12-25'),
	('Isabel', 'Castillo', 'isabel.cas@mail.com', 55, '5570114', 'Urbanización Real 111', 0, 'B+', '1971-01-28'),
	('Gabriel', 'Cortes', 'gabriel.cortes@mail.com', 27, '5522115', 'Calle de la Luna 222', 1, 'O-', '1999-02-26'),
	('Sara', 'Garrido', 'sara.garrido@mail.com', 31, '55550116', 'Pasaje del Arte 333', 0, 'A+', '1995-03-22'),
	('Alberto', 'Lozano', 'alberto.loz@mail.com', 48, '5550117', 'Avenida Libertad 444', 1, 'O+', '1977-04-15'),
	('Raquel', 'Blanco', 'raquel.blanco@mail.com', 23, '5550118', 'Calle del Pino 555', 0, 'AB+', '2003-05-07'),
	('Enrique', 'Vidal', 'enrique.vidal@mail.com', 62, '5550119', 'Plaza Mayor 666', 1, 'A-', '1964-06-06'),
	('Victoria', 'Prieto', 'victoria.prieto@mail.com', 19, '55566120', 'Paseo Marítimo 777', 0, 'O+', '2007-01-15'),
	('Paciente', 'Prueba', 'mevanaborrar@gmail.com', 1, '88888888', 'UAM', 0, 'AB+', '2007-01-16')
GO

--54, 60, 61. Insertar 15 citas
INSERT INTO Gestiones.Citas (fecha, idPaciente, idMedico, estado, costo) VALUES
	(GETDATE(), 1, 1, 'Confirmada', 45.00),
	(GETDATE(), 2, 2, 'En proceso', 50.00),
	(GETDATE(), 3, 3, 'Completada', 65.50),
	(GETDATE(), 4, 4, 'Confirmada', 40.00),
	(GETDATE(), 5, 5, 'Agendada', 55.00),
	(GETDATE(), 6, 6, 'Reprogramada', 45.00),
	(GETDATE(), 7, 7, 'Confirmada', 50.00),
	(DATEADD(day, 2, GETDATE()), 8, 8, 'Agendada', 60.00),
	(DATEADD(day, 4, GETDATE()), 9, 9, 'Agendada', 40.00),
	(DATEADD(day, 5, GETDATE()), 10, 10, 'Agendada', 55.00),
	(DATEADD(day, 7, GETDATE()), 11, 1, 'Confirmada', 45.00),
	(DATEADD(day, 9, GETDATE()), 12, 2, 'Agendada', 50.00),
	(DATEADD(day, 12, GETDATE()), 13, 3, 'Agendada', 65.50),
	(DATEADD(day, 15, GETDATE()), 14, 4, 'Agendada', 40.00),
	(DATEADD(day, 20, GETDATE()), 15, 5, 'Agendada', 55.00)
GO

--55, 62, 63. Insertar 10 habitaciones
INSERT INTO Hospital.Habitaciones (codigo, idPaciente, disponibilidad) VALUES
	('HAB-101', 1, 0),
	('HAB-102', 2, 0),
	('HAB-103', 3, 0),
	('HAB-104', 4, 0),
	('HAB-105', 5, 0),
	('HAB-201', NULL, 1),
	('HAB-202', NULL, 1),
	('HAB-203', NULL, 1),
	('HAB-204', NULL, 1),
	('HAB-205', NULL, 1)
GO

--56, 64, 65. Insertar 10 tratamientos
INSERT INTO Hospital.Tratamientos (descripcion, estado, idPaciente) VALUES
	('Tratamiento de hipertensión arterial crónica', 'Activo', 1),
	('Quimioterapia preventiva etapa inicial', 'Activo', 2),
	('Fisioterapia por fractura de fémur', 'Activo', 3),
	('Antibióticos endovenosos por infección', 'Activo', 4),
	('Control metabólico de diabetes tipo 2', 'Activo', 5),
	('Rehabilitación post-infarto agudo', 'Finalizado', 6),
	('Tratamiento dermatológico para dermatitis', 'Finalizado', 7),
	('Manejo del dolor por migraña crónica', 'Finalizado', 8),
	('Corrección de postura y columna', 'Finalizado', 9),
	('Tratamiento antiviral por hepatitis', 'Finalizado', 10),
	('Tratamiento para sindrome del papu', 'Activo', 10)
GO

--57. Insertar 20 medicamentos
INSERT INTO Hospital.Medicamentos (idTratamiento, nombre, estado, dosis) VALUES
	(1, 'Enalapril 10mg', 'Vigente', 1.00),
	(1, 'Amlodipino 5mg', 'Vigente', 0.50),
	(2, 'Cisplatino 50mg', 'Vigente', 2.25),
	(2, 'Ondansetrón 8mg', 'Vigente', 1.00),
	(3, 'Ibuprofeno 600mg', 'Vigente', 3.00),
	(3, 'Paracetamol 1g', 'Vigente', 4.00),
	(4, 'Ceftriaxona 1g', 'Vigente', 2.00),
	(4, 'Clindamicina 300mg', 'Vigente', 3.00),
	(5, 'Metformina 850mg', 'Vigente', 2.00),
	(5, 'Insulina Glargina', 'Vigente', 0.80),
	(6, 'Aspirina 100mg', 'Vencido', 1.00),
	(6, 'Atorvastatina 20mg', 'Vigente', 1.00),
	(7, 'Betametasona Crema', 'Vigente', 1.50),
	(7, 'Antihistamínico 10mg', 'Vencido', 1.00),
	(8, 'Sumatriptán 50mg', 'Vigente', 0.50),
	(8, 'Naproxeno 500mg', 'Vigente', 2.00),
	(9, 'Tramadol drop 50mg', 'Vencido', 1.20),
	(9, 'Diazepam 5mg', 'Vigente', 0.50),
	(10, 'Ribavirina 200mg', 'Vigente', 3.50),
	(10, 'Interferón Alfa', 'Vigente', 1.00)
GO

--66. Actualizar teléfono de un paciente
UPDATE Gestiones.Pacientes SET telefono = '88888888' WHERE idPaciente = 1
GO

--67. Actualizar dirección de un paciente
UPDATE Gestiones.Pacientes SET direccion = 'Vistas de Esquipulas' WHERE idPaciente = 1
GO

--68. Actualizar salario de un médico.
UPDATE Empleados.Medicos SET salario = 2222.5 WHERE idMedico = 1
GO

--69. Actualizar turno de un médico.
UPDATE Empleados.Medicos SET turno = 'Diurno' WHERE idMedico = 1
GO

--70. Cambiar estado de una cita
UPDATE Gestiones.Citas SET estado = 'En proceso' WHERE idCita = 1
GO

--71. Actualizar costo de consulta
UPDATE Gestiones.Citas SET costo = 10.75 WHERE idCita = 1
GO

--72. Actualizar nombre de especialidad
UPDATE Empleados.Especialidades SET nombre = 'Gastroentología' WHERE idEspecialidad = 1
GO

--73. Actualizar disponibilidad de habitación.
UPDATE Hospital.Habitaciones SET disponibilidad = 1 WHERE idHabitacion = 1
GO

--74. Actualizar tratamiento activo.
UPDATE Hospital.Tratamientos SET estado = 'Activo' WHERE idTratamiento = 6
GO

--75. Actualizar medicamento.
UPDATE Hospital.Medicamentos SET estado = 'Vigente' WHERE idMedicamento = 10
GO

--76. Actualizar correo de paciente.
UPDATE Gestiones.Pacientes SET correo = 'a@gmail.com' WHERE idPaciente = 1
GO

--77. Actualizar correo de médico.
UPDATE Empleados.Medicos SET correo = 'b@gmail.com' WHERE idMedico = 1
GO

--78. Actualizar fecha de cita.
UPDATE Gestiones.Citas SET fecha = '2026-04-08' WHERE idCita = 1
GO

--79. Actualizar experiencia del médico.
UPDATE Empleados.Medicos SET experiencia = '5 años de trabajo en el Hospital Militar en el área de Radiología' WHERE idMedico = 1
GO

--80. Actualizar tipo de sangre
UPDATE Gestiones.Pacientes SET tipo_sangre = 'AB+' WHERE idPaciente = 1
GO

--81. Eliminar un paciente específico.
DELETE FROM Gestiones.Pacientes WHERE idPaciente = 21
GO

--82. Eliminar una cita
DELETE FROM Gestiones.Citas WHERE idCita = 15
GO

--83. Eliminar un medicamento
DELETE FROM Hospital.Medicamentos WHERE idMedicamento = 20
GO

--84. Eliminar una habitación
DELETE FROM Hospital.Habitaciones WHERE idHabitacion = 10
GO

--85. Eliminar un tratamiento
DELETE FROM Hospital.Tratamientos WHERE idTratamiento = 11
GO

--86. Eliminar citas canceladas
DELETE FROM Gestiones.Citas WHERE estado = 'Cancelado'
GO

