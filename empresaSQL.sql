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
	, CONSTRAINT CK_empfechanac CHECK(dFechaNacimiento < GETDATE())
GO

ALTER TABLE Personal.TEmpleado
	DROP COLUMN cDireccion
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
	, ('22345678B', 'Johnny', 'Calero', 2, 2, 500.01, 'jacq@uamv.edu.ni', '22222222', 19, 'M', '2006-11-16')
	, ('32345678C', 'Noa', 'Reyes', 4, 3, 100000, 'naam@gmail.com', '33333333', 19, 'F', '2007-03-20')
	, ('42345678D', 'Bandrea', 'be la Roca', 4, 3, 20000, 'si@uamv.edu.ni', '44444444', 60, 'F', '2006-01-16')
	, ('52345678E', 'Candrea', 'ce la Roca', 4, 5, 40000, 'no@gmail.com', '55555555', 36, 'F', '2000-08-27')
	, ('62345678F', 'Dandrea', 'e la Roca', 5, 5, 350000, 'talvez@gmail.com', '66666666', 27, 'M', '1999-12-30')
	, ('72345678E', 'Endrea', 'la Roca', 1, 2, 100000, '67@mgial.com', '77777777', 20, 'F', '1987-06-07')
	, ('82345678G', 'Fandrea', 'fe la Roca', 3, 3, 501, 'aaaa@gmail.ni', '88888888', 35, 'M', '1999-02-13')
	, ('92345678H', 'Handrea', 'he la Roca', 5, 4, 7000, 'gmail@uamv.edu.ni', '99999999', 25, 'M', '2003-05-05')
	, ('02345678J', 'Jandrea', 'je la Roca', 2, 2, 3000, 'uam@uamv.edu.ni', '00000000', 64, 'F', '2000-04-04')
	, ('00000000X', 'Prueba', 'Prueba', 5, 5, 3000, 'prueba@uamv.edu.ni', '00000001', 20, 'M', '2001-01-01')
GO

INSERT INTO Empresa.TProyecto(cNombre, dFechaInicio) VALUES
	('Proyecto 67', '2000-05-05')
	, ('Proyecto Bubulabubu chocorron', '2002-06-06')
	, ('Proyecto César', '2003-07-07')
	, ('Proyecto Prueba', '2001-02-02')
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

INSERT INTO Empresa.TEmpleadoProyecto(nProyectoID, nEmpleadoID) VALUES (1, 5)
GO

--Parte V. Eliminación de Datos (DELETE)
DELETE FROM Personal.TEmpleado WHERE cNIF = '00000000X'
GO

DELETE FROM Personal.TEmpleado WHERE bActivo = 0
GO

DELETE FROM Empresa.TProyecto WHERE cNombre LIKE '%Prueba%'
GO

DELETE FROM Empresa.TEmpleadoProyecto WHERE nEmpleadoID = 5
GO

DELETE FROM Empresa.TDepartamento WHERE nDepartamentoID NOT IN (SELECT DISTINCT nDepartamentoID FROM Personal.TEmpleado WHERE nEmpleadoID IS NOT NULL)
GO

--Parte VI. Consultas de Verificación
SELECT * FROM Personal.TEmpleado ORDER BY cApellido ASC
GO

SELECT * FROM Personal.TEmpleado WHERE nSalario > 1000
GO

SELECT * FROM Personal.TEmpleado WHERE bActivo = 1
GO

SELECT 
	CONCAT(e.cNombre, ' ', e.cApellido) as Empleado,
	d.cNombreDepartamento as Departamento
FROM Empresa.TDepartamento AS d INNER JOIN Personal.TEmpleado AS e ON d.nDepartamentoID = e.nDepartamentoID
GO

SELECT 
	CONCAT(e.cNombre, ' ', e.cApellido) AS Empleado,
	c.cNombreCargo AS Cargo
FROM Personal.TCargo AS c INNER JOIN Personal.TEmpleado AS e ON c.nCargoID = e.nCargoID
GO

SELECT
	CONCAT(e.cNombre, ' ', e.cApellido) AS Empleado,
	p.cNombre AS Proyecto
FROM Personal.TEmpleado AS e INNER JOIN Empresa.TEmpleadoProyecto AS ep ON e.nEmpleadoID = ep.nEmpleadoID
							INNER JOIN Empresa.TProyecto AS p ON ep.nProyectoID = p.nProyectoID
GO

SELECT
	d.cNombreDepartamento AS Departamento,
	COUNT(e.nEmpleadoID) AS Empleados
FROM Personal.TEmpleado AS e INNER JOIN Empresa.TDepartamento AS d ON e.nDepartamentoID = d.nDepartamentoID
GROUP BY d.cNombreDepartamento
GO

SELECT
	d.cNombreDepartamento AS Departamento,
	AVG(e.nSalario) AS N'Salario promedio'
FROM Personal.TEmpleado AS e INNER JOIN Empresa.TDepartamento AS d ON e.nDepartamentoID = d.nDepartamentoID
GROUP BY d.cNombreDepartamento
GO

SELECT
	d.cNombreDepartamento AS Departamento,
	MIN(e.nSalario) AS N'Salario mínimo',
	MAX(e.nSalario) AS N'Salario máximo'
FROM Personal.TEmpleado AS e INNER JOIN Empresa.TDepartamento AS d ON e.nDepartamentoID = d.nDepartamentoID
GROUP BY d.cNombreDepartamento
GO

SELECT
	p.cNombre AS Proyecto,
	COUNT(ep.nEmpleadoID) as Empleados
FROM Empresa.TEmpleadoProyecto AS ep INNER JOIN Empresa.TProyecto AS p ON ep.nProyectoID = p.nProyectoID
GROUP BY p.cNombre
HAVING COUNT(ep.nEmpleadoID) > 2
GO

SELECT CONCAT(cNombre, ' ', cApellido) AS Empleado
FROM Personal.TEmpleado
WHERE cApellido LIKE 'G%'
GO

SELECT 
	CONCAT(cNombre, ' ', cApellido) AS Empleado,
	nSalario AS Salario
FROM Personal.TEmpleado
ORDER BY nSalario DESC
GO

SELECT TOP 3
	nSalario AS Salario
FROM Personal.TEmpleado
ORDER BY nSalario DESC
GO

SELECT 
	CONCAT(cNombre, ' ', cApellido) AS Empleado,
	nEdad AS Edad
FROM Personal.TEmpleado
WHERE nEdad BETWEEN 25 AND 40
GO

SELECT COUNT(nEmpleadoID) AS N'Empleados activos'
FROM Personal.TEmpleado
WHERE bActivo = 1
GO

SELECT COUNT(nProyectoID) AS Proyectos FROM Empresa.TProyecto
GO

--Parte VII. Administración de Objetos
ALTER TABLE Personal.TEmpleado
	DROP CONSTRAINT CK_empedadval
	, CONSTRAINT UQ_empemail
GO

ALTER TABLE Personal.TEmpleado
	ADD CONSTRAINT CK_empedadval CHECK(nEdad BETWEEN 18 AND 65)
	, CONSTRAINT UQ_empemail UNIQUE(cEmail)
GO

DROP TABLE Empresa.TEmpleadoProyecto
GO

DROP TABLE Empresa.TProyecto
GO

DROP TABLE Personal.TEmpleado
GO

DROP TABLE Personal.TCargo
GO

DROP TABLE Empresa.TDepartamento
GO

DROP TABLE Empresa.TSucursal
GO

USE master
GO

DROP DATABASE EmpresaSQL
GO

--Desafíos adicionales
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

CREATE TABLE TCliente (
	idCliente INT IDENTITY(1,1) CONSTRAINT PK_idcliente PRIMARY KEY
	, nombres NVARCHAR(60) NOT NULL
	, apellidos NVARCHAR(60) NOT NULL
	, organizacion NVARCHAR(100) NOT NULL
	, correo NVARCHAR(120) 
	CONSTRAINT UQ_correo UNIQUE
	CONSTRAINT CK_correo CHECK(correo LIKE  '%_@__%.__%')
	, telefono NVARCHAR(20) CONSTRAINT CK_telefono CHECK(LEN(telefono) >= 8)
	, direccion NVARCHAR(120) NOT NULL
	, sexo CHAR CONSTRAINT CK_sexo CHECK(sexo IN ('M', 'F'))
)
GO

CREATE TABLE TProducto (
	idProducto INT IDENTITY(1,1) CONSTRAINT PK_idprod PRIMARY KEY
	, nombre NVARCHAR(60) NOT NULL
	, precioUnitario DECIMAL(4,2) CONSTRAINT CK_precioval CHECK(precioUnitario > 0)
)
GO

CREATE TABLE TVenta (
	idVenta INT IDENTITY(1,1) CONSTRAINT PK_idventa PRIMARY KEY
	, idCliente INT CONSTRAINT FK_idcliente FOREIGN KEY REFERENCES TCliente(idCliente)
	, idProducto INT CONSTRAINT FK_idproducto FOREIGN KEY REFERENCES TProducto(idProducto)
	, fechaVenta DATE NOT NULL
	, precio DECIMAL(4,2) 
)
GO

INSERT INTO TCliente (nombres, apellidos, organizacion, correo, telefono, direccion, sexo) VALUES
('Juan', 'Pérez', 'Tech Solutions', 'juan.perez@tech.com', '12345678', 'Calle Alta 123', 'M'),
('María', 'Gómez', 'Innovate LLC', 'maria.gomez@innovate.com', '87654321', 'Av. Central 456', 'F'),
('Carlos', 'López', 'DevCorp', 'carlos.lopez@devcorp.net', '99887766', 'Jr. Los Pinos 789', 'M'),
('Ana', 'Martínez', 'Global Trade', 'ana.martinez@global.com', '55443322', 'Av. Larco 101', 'F'),
('Luis', 'Rodríguez', 'Luis Inc', 'luis.rod@gmail.com', '11223344', 'Calle Lima 202', 'M'),
('Elena', 'Zapata', 'SoftNet', 'elena.z@softnet.org', '77665544', 'Av. Primavera 303', 'F'),
('Pedro', 'Castro', 'Inversiones PC', 'pedro.c@inversiones.com', '44556677', 'Calle Real 404', 'M'),
('Sonia', 'Alva', 'Alva Tech', 'sonia.alva@alvatech.com', '22334455', 'Av. Grau 505', 'F'),
('Jorge', 'Peña', 'Constructora JP', 'jorge.p@constructora.com', '66778899', 'Jr. Trujillo 606', 'M'),
('Lucía', 'Díaz', 'Estudio LD', 'lucia.diaz@estudio.com', '88990011', 'Av. Brasil 707', 'F'),
('Roberto', 'Sánchez', 'Sánchez & Asoc', 'roberto.s@sanchez.com', '33445566', 'Calle Ica 808', 'M'),
('Marta', 'Flores', 'Flores SAC', 'marta.f@flores.com', '55667788', 'Av. Tacna 909', 'F'),
('Andrés', 'Mendoza', 'ExportMendoza', 'andres.m@export.com', '22113344', 'Jr. Puno 111', 'M'),
('Silvia', 'Ramos', 'Ramos EIRL', 'silvia.ramos@ramos.com', '99001122', 'Av. Ejercito 222', 'F'),
('Manuel', 'Espinoza', 'Logística ME', 'manuel.e@logistica.com', '44332211', 'Calle Cusco 333', 'M'),
('Patricia', 'Chávez', 'Chávez Corp', 'patricia.ch@corp.com', '66554433', 'Av. Arenales 444', 'F'),
('Fernando', 'Ruiz', 'Ruiz Sistemas', 'fernando.r@sistemas.com', '88776655', 'Jr. Junín 555', 'M'),
('Laura', 'Torres', 'Torres Consulting', 'laura.t@consulting.com', '11447788', 'Av. Arequipa 666', 'F'),
('Ricardo', 'Vargas', 'Vargas & Co', 'ricardo.v@vargas.com', '22558899', 'Calle Loreto 777', 'M'),
('Carmen', 'Rojas', 'Rojas Creativos', 'carmen.r@creativos.com', '33669900', 'Av. Angamos 888', 'F')
GO

INSERT INTO TProducto (nombre, precioUnitario) VALUES 
('Mouse Óptico', 15.50),
('Teclado Mecánico', 45.00),
('Monitor 24 pulgadas', 99.99),
('Audífonos Gamer', 35.00),
('Pad Mouse', 12.00)
GO

--bucle para inserción de 50 ventas
DECLARE @contador INT = 1
DECLARE @idCli INT
DECLARE @idProd INT
DECLARE @precioProd DECIMAL(4,2)
DECLARE @fecha DATE

WHILE @contador <= 50
BEGIN
    SET @idCli = (@contador % 20) + 1;
    SET @idProd = (@contador % 5) + 1;
    SELECT @precioProd = precioUnitario FROM TProducto WHERE idProducto = @idProd   -- Generar una fecha variada (entre 2025 y 2026)
    SET @fecha = DATEADD(DAY, -(@contador * 5), GETDATE())
    INSERT INTO TVenta (idCliente, idProducto, fechaVenta, precio)
    VALUES (@idCli, @idProd, @fecha, @precioProd);
    SET @contador = @contador + 1;
END
GO

UPDATE TVenta
SET precio = precio * 0.90
WHERE fechaVenta < '2026-01-01'
GO

DELETE FROM TCliente
WHERE idCliente NOT IN (
    SELECT DISTINCT idCliente 
    FROM TVenta 
    WHERE idCliente IS NOT NULL
)
GO

SELECT TOP 5 
    c.idCliente,
    c.nombres + ' ' + c.apellidos AS Cliente,
    SUM(v.precio) AS Total
FROM TVenta v
INNER JOIN TCliente c ON v.idCliente = c.idCliente
GROUP BY c.idCliente, c.nombres, c.apellidos, c.organizacion
ORDER BY Total DESC
GO

SELECT 
    YEAR(fechaVenta) AS N'Año',
    MONTH(fechaVenta) AS Mes,
    COUNT(idVenta) AS Ventas,
    SUM(precio) AS TotalVentas
FROM TVenta
GROUP BY YEAR(fechaVenta), MONTH(fechaVenta)
ORDER BY N'Año' DESC, Mes DESC
GO

SELECT 
    c.idCliente,
    c.nombres + ' ' + c.apellidos AS Cliente,
    AVG(v.precio) AS Promedio,
    COUNT(v.idVenta) AS Total
FROM TCliente c
INNER JOIN TVenta v ON c.idCliente = v.idCliente
GROUP BY c.idCliente, c.nombres, c.apellidos
ORDER BY Promedio DESC
GO

SELECT 
    v.idVenta as Venta,
    v.fechaVenta AS Fecha,
    c.nombres + ' ' + c.apellidos AS Cliente,
    c.organizacion AS Empresa,
    p.nombre AS Productos,
    p.precioUnitario AS Precio,
    v.precio AS 'Total pagado'
FROM TVenta v
INNER JOIN TCliente c ON v.idCliente = c.idCliente
INNER JOIN TProducto p ON v.idProducto = p.idProducto
ORDER BY v.fechaVenta DESC;
GO