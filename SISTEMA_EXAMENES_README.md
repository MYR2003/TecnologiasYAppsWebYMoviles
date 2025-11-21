# Sistema de Gestión de Exámenes Médicos

## Descripción

Sistema completo para que pacientes (Ionic) suban sus exámenes médicos y médicos (Flutter) puedan solicitar acceso para visualizarlos. El flujo incluye un sistema de permisos donde el paciente debe aprobar cada solicitud.

## Cambios Implementados

### Base de Datos

**Tabla `examen`:**
- `idexamen` - ID autoincremental
- `idtipoexamen` - Tipo de examen
- `examen` - Nombre del examen
- `idpersona` - ID del paciente que subió el examen
- `imagen` - Imagen o PDF en formato base64 (Data URI)
- `fecha_subida` - Timestamp automático

**Tabla `examen_accesos`:**
- `id` - ID autoincremental
- `examen_id` - ID del examen
- `usuario_solicitante_id` - ID del médico solicitante
- `estado` - 'pendiente', 'aprobado' o 'rechazado'
- `fecha_solicitud` - Timestamp automático
- `fecha_respuesta` - Timestamp de respuesta

### Microservicios

#### 1. `examen.js` (Puerto 3010)

**Endpoints:**
- `GET /` - Obtener todos los exámenes
- `GET /persona/:idpersona` - Obtener exámenes de un paciente
- `GET /:id` - Obtener un examen específico
- `POST /subir` - Subir un examen (con archivo)
- `DELETE /:id` - Eliminar un examen

**Ejemplo de uso:**
```bash
# Subir un examen
curl -X POST http://localhost:3010/subir \
  -F "file=@examen.jpg" \
  -F "idpersona=1" \
  -F "idtipoexamen=1" \
  -F "nombre_examen=Radiografía de Tórax"
```

#### 2. `examenAcceso.js` (Puerto 3011)

**Endpoints:**
- `GET /` - Obtener todas las solicitudes
- `GET /paciente/:idpaciente/pendientes` - Solicitudes pendientes de un paciente
- `GET /medico/:idmedico` - Solicitudes de un médico
- `GET /estado/:examenId/:medicoId` - Estado de una solicitud
- `GET /verificar/:examenId/:medicoId` - Verificar acceso aprobado
- `POST /` - Crear solicitud de acceso
- `PUT /:id` - Aprobar/rechazar solicitud
- `DELETE /:id` - Eliminar solicitud

**Ejemplo de uso:**
```bash
# Solicitar acceso
curl -X POST http://localhost:3011/ \
  -H "Content-Type: application/json" \
  -d '{"examen_id": 1, "usuario_solicitante_id": 2}'

# Aprobar solicitud
curl -X PUT http://localhost:3011/1 \
  -H "Content-Type: application/json" \
  -d '{"estado": "aprobado"}'
```

### Aplicación Ionic (Paciente)

**Página de Exámenes (`examenes.page.ts`):**
- Subir exámenes en formato JPG, PNG o PDF (máximo 50MB)
- Visualizar lista de exámenes subidos
- Eliminar exámenes propios
- Vista previa de imágenes

**Página de Perfil (`perfil.page.ts`):**
- Muestra solicitudes pendientes de acceso a exámenes
- Permite aprobar o rechazar solicitudes
- Muestra información del médico solicitante
- Actualización en tiempo real

**Servicios:**
- `ExamenesService` - Gestión de exámenes
- `ExamenAccesoService` - Gestión de solicitudes de acceso

### Aplicación Flutter (Médico)

**Vista Detalle de Paciente (`paciente_detalle.dart`):**
- Lista de exámenes del paciente
- Botón para ver cada examen
- Solicitud automática de permiso si no tiene acceso
- Visualización del examen una vez aprobado
- Estados de solicitud: sin solicitud, pendiente, rechazado, aprobado

**ApiService:**
- `obtenerExamenesPaciente()` - Lista de exámenes
- `obtenerExamen()` - Detalle de un examen
- `solicitarAccesoExamen()` - Solicitar permiso
- `verificarEstadoAcceso()` - Verificar estado
- `verificarAccesoAprobado()` - Verificar si tiene acceso

## Instalación

### 1. Dependencias de Microservicios

```bash
cd proyecto/microservicios

# Instalar multer para manejo de archivos
npm install multer
```

### 2. Actualizar Base de Datos

Ejecutar el archivo `pym.sql` actualizado o ejecutar estas consultas:

```sql
-- Si la tabla examen ya existe, agregar columnas:
ALTER TABLE examen ADD COLUMN imagen text;
ALTER TABLE examen ADD COLUMN fecha_subida timestamp without time zone DEFAULT CURRENT_TIMESTAMP;

-- Si necesitas agregar idpersona:
ALTER TABLE examen ADD COLUMN idpersona integer NOT NULL;
ALTER TABLE examen ADD CONSTRAINT fk_persona FOREIGN KEY (idpersona) REFERENCES persona(idpersona);

-- Crear tabla examen_accesos (si no existe):
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
```

### 3. Iniciar Microservicios

```bash
# Terminal 1 - Microservicio de exámenes
cd proyecto/microservicios
node examen.js

# Terminal 2 - Microservicio de accesos
node examenAcceso.js
```

### 4. Iniciar Aplicación Ionic

```bash
cd proyecto/biblioteca-ms
npm install
ionic serve
```

### 5. Iniciar Aplicación Flutter

```bash
cd PYM-Flutter
flutter pub get
flutter run
```

## Flujo de Uso

### Paciente (Ionic)

1. **Subir Examen:**
   - Ir a la página de Exámenes
   - Seleccionar archivo (JPG, PNG o PDF)
   - Click en "Subir Examen"
   - El archivo se guarda en base64 en la base de datos

2. **Gestionar Solicitudes:**
   - Ir al Perfil
   - Ver solicitudes pendientes con badge rojo
   - Click en "Aprobar" o "Rechazar" para cada solicitud
   - El médico recibirá la respuesta

### Médico (Flutter)

1. **Ver Paciente:**
   - Seleccionar un paciente de la lista
   - Ver detalle del paciente

2. **Solicitar Acceso a Examen:**
   - Si el paciente tiene exámenes, aparecerán listados
   - Click en un examen
   - Si no tiene acceso, aparece diálogo: "¿Quieres pedir permiso para ver este examen?"
   - Click en "Sí" para enviar solicitud

3. **Estados de la Solicitud:**
   - **Sin solicitud:** Se puede solicitar acceso
   - **Pendiente:** Muestra mensaje "Tu solicitud está pendiente de aprobación"
   - **Rechazado:** Muestra mensaje "Tu solicitud fue rechazada"
   - **Aprobado:** Se abre el examen automáticamente

4. **Visualizar Examen:**
   - Una vez aprobado, el examen se muestra en un diálogo
   - Imágenes: se muestran directamente
   - PDFs: se muestra ícono de PDF

## Restricciones de Seguridad

- **Médicos NO pueden:**
  - Eliminar exámenes
  - Editar exámenes
  - Crear exámenes
  - Ver exámenes sin aprobación del paciente

- **Pacientes SOLO pueden:**
  - Subir sus propios exámenes
  - Eliminar sus propios exámenes
  - Aprobar/rechazar solicitudes de acceso

## Consideraciones Técnicas

### Tamaño de Archivos
- Límite: 50MB por archivo
- Los archivos se convierten a base64 (aumenta ~33% el tamaño)
- Para archivos grandes, considerar almacenamiento en disco o cloud storage

### Performance
- Los exámenes en base64 pueden hacer las consultas más lentas
- Considerar paginación para pacientes con muchos exámenes
- Implementar caché en el frontend

### Seguridad
- TODO: Implementar autenticación real (actualmente usa IDs hardcodeados)
- TODO: Validar permisos en el backend
- TODO: Implementar HTTPS en producción
- TODO: Sanitizar inputs para prevenir SQL injection

## Próximas Mejoras

1. **Autenticación:**
   - Implementar login con JWT
   - Gestión de sesiones
   - Roles de usuario (paciente, médico, admin)

2. **Notificaciones:**
   - Push notifications para nuevas solicitudes
   - Email notifications
   - Notificaciones en tiempo real con WebSockets

3. **Almacenamiento:**
   - Migrar a cloud storage (AWS S3, Google Cloud Storage)
   - Implementar CDN para imágenes
   - Thumbnails para preview rápido

4. **Features:**
   - Historial de accesos
   - Comentarios en exámenes
   - Compartir exámenes con múltiples médicos
   - Expiración automática de permisos
   - Búsqueda y filtrado de exámenes

5. **UI/UX:**
   - Drag and drop para subir archivos
   - Preview antes de subir
   - Galería de exámenes
   - Zoom en imágenes
   - Visor de PDF integrado

## Troubleshooting

### Error: "Tipo de archivo no permitido"
- Verificar que el archivo sea JPG, PNG o PDF
- Verificar la extensión del archivo

### Error: "El archivo es demasiado grande"
- Reducir el tamaño del archivo (máximo 50MB)
- Comprimir la imagen antes de subir

### Exámenes no se cargan
- Verificar que los microservicios estén corriendo
- Verificar conexión a base de datos
- Revisar console logs en el navegador/app

### Solicitud no aparece en perfil
- Verificar que el idpersona sea correcto
- Refrescar la página/app
- Verificar logs del microservicio

## Soporte

Para problemas o preguntas, revisar:
1. Logs de microservicios en la terminal
2. Console del navegador (Ionic)
3. Debug console (Flutter)
4. Logs de la base de datos

---

**Última actualización:** Noviembre 21, 2025
