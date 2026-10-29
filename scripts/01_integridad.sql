USE BusRD;
GO

SELECT BoletoID, ViajeID, NumeroAsiento, ClienteID,
       Estado, FechaVenta
FROM dbo.Boletos
WHERE ViajeID = 7469
  AND NumeroAsiento = 1
ORDER BY BoletoID;

SELECT ViajeID, NumeroAsiento, COUNT(*) AS BoletosActivos
FROM dbo.Boletos
WHERE Estado = 'Activo'
GROUP BY ViajeID, NumeroAsiento
HAVING COUNT(*) > 1;
