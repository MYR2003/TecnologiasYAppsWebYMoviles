-- Script de verificación y actualización de la base de datos pym
-- Para ejecutar: psql -U myr -d pym -f verificar_y_actualizar.sql

-- Verificar si la columna 'imagen' existe en la tabla examen
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name='examen' 
        AND column_name='imagen'
    ) THEN
        ALTER TABLE examen ADD COLUMN imagen text;
        RAISE NOTICE 'Columna imagen agregada a la tabla examen';
    ELSE
        RAISE NOTICE 'La columna imagen ya existe en la tabla examen';
    END IF;
END $$;

-- Verificar si la columna 'fecha_subida' existe en la tabla examen
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name='examen' 
        AND column_name='fecha_subida'
    ) THEN
        ALTER TABLE examen ADD COLUMN fecha_subida timestamp without time zone DEFAULT CURRENT_TIMESTAMP;
        RAISE NOTICE 'Columna fecha_subida agregada a la tabla examen';
    ELSE
        RAISE NOTICE 'La columna fecha_subida ya existe en la tabla examen';
    END IF;
END $$;

-- Verificar si la tabla examen_accesos existe
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_name='examen_accesos'
    ) THEN
        CREATE TABLE examen_accesos (
            id SERIAL PRIMARY KEY,
            examen_id INT NOT NULL,
            usuario_solicitante_id INT NOT NULL,
            estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
            fecha_solicitud TIMESTAMP DEFAULT NOW(),
            fecha_respuesta TIMESTAMP,
            CONSTRAINT examen_accesos_examen_id_fkey FOREIGN KEY (examen_id) REFERENCES examen(idexamen),
            CONSTRAINT examen_accesos_usuario_solicitante_id_fkey FOREIGN KEY (usuario_solicitante_id) REFERENCES persona(idpersona)
        );
        RAISE NOTICE 'Tabla examen_accesos creada exitosamente';
    ELSE
        RAISE NOTICE 'La tabla examen_accesos ya existe';
    END IF;
END $$;

-- Mostrar estructura actual de la tabla examen
SELECT 
    column_name, 
    data_type, 
    column_default,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'examen'
ORDER BY ordinal_position;

-- Mostrar estructura de la tabla examen_accesos si existe
SELECT 
    column_name, 
    data_type, 
    column_default,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'examen_accesos'
ORDER BY ordinal_position;

-- Verificar registros en las tablas
SELECT 'Exámenes en BD:' as info, COUNT(*) as total FROM examen;
SELECT 'Solicitudes de acceso:' as info, COUNT(*) as total FROM examen_accesos;
