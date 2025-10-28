-- Script para generar 10,000 consultas aleatorias
-- Primero necesitamos asegurarnos de tener suficientes personas y médicos

-- Insertar 2000 personas
INSERT INTO persona (nombre, apellido, rut, fechanacimiento)
SELECT 
    (ARRAY['Martin', 'Antonio', 'Francisco', 'Ignacio', 'Benjamín', 'Tomás', 'José', 'Carlos', 'Pedro', 'Luis'])[floor(random() * 10 + 1)],
    (ARRAY['Mendez', 'Solano', 'Yunge', 'Sanchez', 'Polo', 'Pavez', 'Garcia', 'Rodriguez', 'Martinez', 'Lopez'])[floor(random() * 10 + 1)],
    (10000000 + floor(random() * 18000000))::varchar,
    CURRENT_DATE - (floor(random() * 365 * 80) || ' days')::interval
FROM generate_series(1, 2000);

-- Insertar 100 médicos
INSERT INTO medico (idespecialidad, nombre, apellido, rut, fechanacimiento)
SELECT 
    floor(random() * 3 + 1)::integer,
    (ARRAY['Dr. Juan', 'Dra. María', 'Dr. Pedro', 'Dra. Ana', 'Dr. Luis', 'Dra. Carmen', 'Dr. Jorge', 'Dra. Sofia'])[floor(random() * 8 + 1)],
    (ARRAY['Perez', 'Gonzalez', 'Ramirez', 'Torres', 'Flores', 'Rivera', 'Gomez', 'Diaz'])[floor(random() * 8 + 1)],
    (10000000 + floor(random() * 18000000))::varchar,
    CURRENT_DATE - (floor(random() * 365 * 60) || ' days')::interval
FROM generate_series(1, 100);

-- Insertar 2000 fichas médicas (una por persona aproximadamente)
INSERT INTO fichamedica (altura, peso)
SELECT 
    floor(random() * 30 + 160)::integer,
    floor(random() * 40 + 50)::integer
FROM generate_series(1, 2000);

-- Ahora generar 10,000 consultas
INSERT INTO consulta (idpersona, idmedico, fecha, motivo, duracionminutos, observaciones, idfichamedica)
SELECT 
    floor(random() * 2000 + 1)::integer,
    floor(random() * 100 + 1)::integer,
    CURRENT_TIMESTAMP - (floor(random() * 365 * 2) || ' days')::interval,
    (ARRAY['Dolor de cabeza', 'Revisión general', 'Dolor abdominal', 'Control rutinario', 'Fiebre', 'Malestar general', 'Dolor muscular', 'Consulta de seguimiento'])[floor(random() * 8 + 1)],
    floor(random() * 60 + 15)::integer,
    'Observaciones de consulta número ' || gs,
    floor(random() * 2000 + 1)::integer
FROM generate_series(1, 10000) as gs;

-- Mostrar resumen de datos insertados
SELECT 'Personas' as tabla, COUNT(*) as total FROM persona
UNION ALL
SELECT 'Médicos', COUNT(*) FROM medico
UNION ALL
SELECT 'Fichas Médicas', COUNT(*) FROM fichamedica
UNION ALL
SELECT 'Consultas', COUNT(*) FROM consulta;
