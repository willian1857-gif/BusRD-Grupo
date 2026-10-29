USE BusRD;
GO

-- 1. CREACIÓN DE VISTAS (Ocultando datos sensibles como Email y Teléfono)
CREATE OR ALTER VIEW dbo.vw_AsientosDisponibles AS
SELECT v.ViajeID, v.FechaSalida, r.Origen, r.Destino, a.AsientoID, a.NumeroAsiento, a.Ubicacion
FROM dbo.Viajes v
JOIN dbo.Rutas r ON v.RutaID = r.RutaID
JOIN dbo.Autobuses b ON v.AutobusID = b.AutobusID
JOIN dbo.Asientos a ON b.AutobusID = a.AutobusID
WHERE v.Estado = 'Programado'
  AND NOT EXISTS (
      SELECT 1 FROM dbo.Boletos b2 
      WHERE b2.ViajeID = v.ViajeID AND b2.AsientoID = a.AsientoID AND b2.Estado = 'Activo'
  );
GO

CREATE OR ALTER VIEW dbo.vw_VentasMensuales AS
SELECT YEAR(b.FechaVenta) AS Anio, MONTH(b.FechaVenta) AS Mes, 
       c.ClienteID, c.Nombre AS NombreCliente, b.BoletoID, p.Monto, b.Canal, b.Estado AS EstadoBoleto
FROM dbo.Boletos b
JOIN dbo.Clientes c ON b.ClienteID = c.ClienteID
JOIN dbo.Pagos p ON b.BoletoID = p.BoletoID;
GO

-- 2. CREACIÓN DE ROLES Y ASIGNACIÓN DE PERMISOS
CREATE ROLE rol_taquilla;
GRANT SELECT ON dbo.vw_AsientosDisponibles TO rol_taquilla;
GRANT EXECUTE ON dbo.sp_VenderBoleto TO rol_taquilla;
GRANT EXECUTE ON dbo.sp_AnularBoleto TO rol_taquilla;

CREATE ROLE rol_reportes;
GRANT SELECT ON dbo.vw_VentasMensuales TO rol_reportes;

CREATE ROLE rol_admin;
ALTER ROLE db_owner ADD MEMBER rol_admin;
GO

-- 3. CREACIÓN DE USUARIOS DE PRUEBA (WITHOUT LOGIN)
CREATE USER usr_taquilla_test WITHOUT LOGIN;
CREATE USER usr_reportes_test WITHOUT LOGIN;
CREATE USER usr_admin_test WITHOUT LOGIN;

ALTER ROLE rol_taquilla ADD MEMBER usr_taquilla_test;
ALTER ROLE rol_reportes ADD MEMBER usr_reportes_test;
ALTER ROLE rol_admin ADD MEMBER usr_admin_test;
GO

-- 4. PRUEBAS DE EVIDENCIA (Permitido vs Denegado)
-- Taquilla
EXECUTE AS USER = 'usr_taquilla_test';
SELECT TOP 2 * FROM dbo.vw_AsientosDisponibles; -- Permitido
SELECT * FROM dbo.Clientes;                  -- Denegado (Error esperado)
REVERT;
GO

-- Reportes
EXECUTE AS USER = 'usr_reportes_test';
SELECT TOP 2 * FROM dbo.vw_VentasMensuales;  -- Permitido
SELECT Email, Telefono FROM dbo.Clientes;    -- Denegado (Error esperado)
REVERT;
GO
