# ✅ Estado del Sistema de Exámenes Médicos

## Instalación Completada

### 1. ✅ Dependencia Multer Instalada
```
Paquete: multer
Estado: Instalado y actualizado
Ubicación: proyecto/microservicios/node_modules/multer
```

### 2. ✅ Microservicios Ejecutándose

#### Microservicio de Exámenes
- **Puerto:** 3010
- **Estado:** ✅ Corriendo
- **Archivo:** examen.js
- **Endpoints disponibles:**
  - GET / - Listar todos los exámenes
  - GET /persona/:id - Exámenes por paciente
  - GET /:id - Detalle de un examen
  - POST /subir - Subir examen con archivo
  - DELETE /:id - Eliminar examen

#### Microservicio de Accesos
- **Puerto:** 3011
- **Estado:** ✅ Corriendo
- **Archivo:** examenAcceso.js
- **Endpoints disponibles:**
  - GET / - Todas las solicitudes
  - GET /paciente/:id/pendientes - Solicitudes pendientes
  - GET /medico/:id - Solicitudes por médico
  - GET /estado/:examenId/:medicoId - Estado de solicitud
  - GET /verificar/:examenId/:medicoId - Verificar acceso
  - POST / - Crear solicitud
  - PUT /:id - Aprobar/rechazar
  - DELETE /:id - Eliminar solicitud

### 3. ⚠️ Base de Datos

**Archivo SQL actualizado:** `pym.sql` contiene las nuevas estructuras

**Para actualizar tu base de datos PostgreSQL, ejecuta:**

```bash
# Opción 1: Ejecutar script de verificación (recomendado)
psql -U myr -d pym -f proyecto/microservicios/verificar_y_actualizar.sql

# Opción 2: Comandos manuales
psql -U myr -d pym
```

**Si la base de datos no tiene los cambios, ejecuta estos comandos SQL:**

```sql
-- Agregar columna imagen si no existe
ALTER TABLE examen ADD COLUMN IF NOT EXISTS imagen text;

-- Agregar columna fecha_subida si no existe
ALTER TABLE examen ADD COLUMN IF NOT EXISTS fecha_subida timestamp without time zone DEFAULT CURRENT_TIMESTAMP;

-- Crear tabla examen_accesos si no existe
CREATE TABLE IF NOT EXISTS examen_accesos (
    id SERIAL PRIMARY KEY,
    examen_id INT NOT NULL,
    usuario_solicitante_id INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    fecha_solicitud TIMESTAMP DEFAULT NOW(),
    fecha_respuesta TIMESTAMP,
    CONSTRAINT examen_accesos_examen_id_fkey 
        FOREIGN KEY (examen_id) REFERENCES examen(idexamen),
    CONSTRAINT examen_accesos_usuario_solicitante_id_fkey 
        FOREIGN KEY (usuario_solicitante_id) REFERENCES persona(idpersona)
);
```

## 🚀 Cómo Probar el Sistema

### Probar Microservicio de Exámenes

```bash
# Listar todos los exámenes
curl http://localhost:3010/

# Obtener exámenes de un paciente (ID 1)
curl http://localhost:3010/persona/1

# Subir un examen
curl -X POST http://localhost:3010/subir \
  -F "file=@ruta/a/imagen.jpg" \
  -F "idpersona=1" \
  -F "idtipoexamen=1" \
  -F "nombre_examen=Radiografía de Tórax"
```

### Probar Microservicio de Accesos

```bash
# Obtener solicitudes pendientes de un paciente (ID 1)
curl http://localhost:3011/paciente/1/pendientes

# Solicitar acceso a un examen
curl -X POST http://localhost:3011/ \
  -H "Content-Type: application/json" \
  -d '{"examen_id": 1, "usuario_solicitante_id": 2}'

# Aprobar una solicitud (ID 1)
curl -X PUT http://localhost:3011/1 \
  -H "Content-Type: application/json" \
  -d '{"estado": "aprobado"}'

# Verificar si un médico tiene acceso
curl http://localhost:3011/verificar/1/2
```

## 📱 Iniciar Aplicaciones

### Ionic (Paciente)
```bash
cd proyecto/biblioteca-ms
npm install
ionic serve
```

### Flutter (Médico)
```bash
cd PYM-Flutter
flutter pub get
flutter run
```

## ⚙️ Gestión de Microservicios

### Ver procesos corriendo
```powershell
# PowerShell
Get-Process node
```

### Detener microservicios
```powershell
# Detener todos los procesos de node
Stop-Process -Name node

# O usar Ctrl+C en cada terminal donde corren
```

### Reiniciar microservicios
```bash
# Terminal 1
node "c:\Users\anton\Documents\GitHub\TecnologiasYAppsWebYMoviles\proyecto\microservicios\examen.js"

# Terminal 2
node "c:\Users\anton\Documents\GitHub\TecnologiasYAppsWebYMoviles\proyecto\microservicios\examenAcceso.js"
```

## 🔍 Verificar Estado

### Verificar que los servicios responden
```bash
# PowerShell
curl http://localhost:3010/
curl http://localhost:3011/
```

### Ver logs en tiempo real
Los logs aparecen en las terminales donde ejecutaste los microservicios.

## 📋 Checklist

- [x] Multer instalado
- [x] Microservicio examen.js corriendo en puerto 3010
- [x] Microservicio examenAcceso.js corriendo en puerto 3011
- [ ] Base de datos actualizada (ejecutar script SQL)
- [ ] Probar endpoints con curl o Postman
- [ ] Iniciar aplicación Ionic
- [ ] Iniciar aplicación Flutter
- [ ] Probar flujo completo: subir examen → solicitar acceso → aprobar → ver

## 🆘 Troubleshooting

### Microservicio no inicia
- Verificar que PostgreSQL esté corriendo
- Verificar credenciales en config.js
- Verificar que los puertos 3010 y 3011 estén libres

### Error de conexión a base de datos
- Verificar que la base de datos 'pym' existe
- Verificar usuario 'myr' y contraseña
- Revisar archivo config.js en proyecto/microservicios/

### Puerto ya en uso
```powershell
# Ver qué proceso usa el puerto 3010
netstat -ano | findstr :3010

# Matar proceso por PID
taskkill /PID <numero> /F
```

---

**Última actualización:** Noviembre 21, 2025
**Estado:** ✅ Microservicios corriendo - ⚠️ Pendiente actualizar BD
