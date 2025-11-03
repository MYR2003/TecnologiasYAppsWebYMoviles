# TecnologiasYAppsWebYMoviles

# Sistema de Gestión de Fichas Médicas

## Presentación del caso

Este sistema permite a los usuarios gestionar sus fichas médicas y exámenes clínicos de manera digital. El usuario podrá subir una foto de su examen en formato .JPG desde su teléfono móvil, y el sistema extraerá automáticamente la información relevante del examen para almacenarla y facilitar su consulta posterior.

### ¿Qué problema resuelve?
- Digitaliza y organiza exámenes médicos que suelen estar solo en papel.
- Facilita el acceso y consulta de resultados médicos históricos.
- Reduce errores de transcripción y pérdida de información.

### ¿Para quién es?
- Pacientes que desean llevar un registro digital de sus exámenes.
- Médicos que requieren consultar exámenes previos de sus pacientes.

### ¿Cómo se medirá el éxito?
- Porcentaje de exámenes correctamente digitalizados y almacenados.
- Facilidad de uso reportada por los usuarios.
- Reducción de tiempo en la búsqueda de exámenes.

### Requisitos de alto nivel
- Subida de imágenes de exámenes (.JPG) desde el móvil.
- Extracción automática de datos relevantes del examen (OCR).
- CRUD de exámenes y fichas médicas.
- Visualización clara y ordenada de la información.
- Mensajes de éxito/error y estados de carga vacíos.
- Arquitectura basada en servicios y componentes reutilizables.
- Código desacoplado y mantenible.

---

## Arquitectura (resumen)
- Frontend: Ionic + Angular (componentes standalone, servicios, UX móvil).
- Backend: Servicios RESTful (mock o integración futura con AWS para OCR).
- Modelo de datos: PostgreSQL, según archivo `postgres_schema.sql`.

## Próximos pasos
- Implementar componente de subida de imagen y vista de exámenes.
- Servicio para extracción de texto desde imagen (OCR, mock inicial).
- CRUD de exámenes y visualización.


## Instrucciones de uso
Para correr el "backend" se debe entrar a la carpeta `proyecto/microservicios` y en esta carpeta correr el archivo `bash.sh` (como ejecutable o con el método que prefieras). El script levanta todos los microservicios disponibles, incluido `mock-backend.js`. Antes de la primera ejecución asegúrate de instalar dependencias con `npm install` en esa misma carpeta.

### Simulador de datos
Primero correr en la base de datos el script.txt, y luego postear a la api en http://localhost:3099/ con body el json que se encuentra en jsonBody-para-simulador.json y cambiar los valores por la cantidad de POSTs que se quiera hacer para cada entidad.