# BusRD - Trabajo Final ISW-323

## Integrantes y datos asignados

| Integrante | Matrícula | Parte asignada |
|------------|-----------|----------------|
| _(completar)_ | | |

## Estructura

```
BusRD-Grupo<N>/
├── README.md
├── scripts/
│   ├── 00_BusRD_base.sql                  (crea la BD, tablas y datos de prueba)
│   ├── 01_integridad.sql
│   ├── 02_sp_VenderBoleto_v0.sql
│   ├── 03_sp_AnularBoleto.sql             (pendiente)
│   ├── 04_demo_concurrencia_sesionA.sql   (pendiente)
│   ├── 05_demo_concurrencia_sesionB.sql   (pendiente)
│   ├── 06_consultas_lentas.sql            (línea base; falta 06_indices_y_consultas_optimizadas.sql)
│   ├── 07_seguridad.sql
│   └── 08_respaldo_y_restauracion.sql     (pendiente)
└── evidencias/                            (capturas de pantalla numeradas)
```

## Orden de ejecución

Ejecutar los scripts en orden numérico sobre SQL Server, empezando por `00_BusRD_base.sql`, que recrea la base `BusRD` desde cero.
Los scripts 04 y 05 se ejecutan en dos sesiones distintas de forma simultánea.

> Nota: `07_seguridad.sql` requiere que existan `sp_VenderBoleto` y `sp_AnularBoleto`, y que `Asientos` tenga la columna usada por la vista `vw_AsientosDisponibles`.
