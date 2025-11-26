# Manual de Uso - Proyecto Ionic Angular
Este manual detalla cómo instalar, configurar y ejecutar el proyecto biblioteca-ms (Ionic Angular) junto con los microservicios y base de datos necesarios.

## Requisitos previos
- Repositorio descargado o clonado
- Node.js 18+ instalado
- PostgreSQL 16 instalado
- Google Chrome (para ejecutar en navegador web)
- Opcional: Android Studio (para ejecutar en Android)
- Opcional: Xcode en macOS (para ejecutar en iOS)

## Paso 1: Configurar PostgreSQL

### Crear usuario de base de datos
Abrir la consola de PostgreSQL y ejecutar:
```sql
CREATE ROLE myr WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD '1234';
```

### Restaurar la base de datos
En PowerShell o CMD, ejecutar:
```powershell
psql -U myr -h localhost -f proyecto/biblioteca-ms/src/app/bbdd/pym.sql
```
Esto crea la base de datos `pym` con todas las tablas necesarias.

### (Opcional) Cargar datos de prueba masivos
Si deseas tener 10,000 consultas de prueba:
```powershell
psql -U myr -h localhost -d pym -f proyecto/microservicios/generar_10000_consultas.sql
```

## Paso 2: Instalar herramientas globales

### Instalar Ionic CLI
```powershell
npm install -g @ionic/cli
```

### Instalar Angular CLI
```powershell
npm install -g @angular/cli
```

### (Opcional) Instalar Capacitor CLI para desarrollo móvil
```powershell
npm install -g @capacitor/cli
```

### Verificar instalaciones
```powershell
ionic --version
ng version
node --version
npm --version
```

## Paso 3: Iniciar microservicios

### Abrir terminal Bash e instalar dependencias
```bash
cd proyecto/microservicios/
npm install
```

### Ejecutar todos los microservicios
```bash
bash bash.sh
```
Esto iniciará todos los microservicios en puertos 3000-3099. **Mantén esta terminal abierta**.

### (Opcional) Ejecutar simulador de datos
Si no cargaste los 10,000 registros, puedes usar el simulador para generar datos de prueba.

En otra terminal:
```bash
cd proyecto/microservicios/
node simulador.js
```
Luego hacer POST a `http://localhost:3099/` con el JSON de ejemplo en `jsonBody-para-simulador.json`.

## Paso 4: Instalar dependencias del proyecto Ionic

### Navegar a la carpeta del proyecto
```powershell
cd proyecto/biblioteca-ms
```

### Instalar todas las dependencias
```powershell
npm install
```
Esto instalará Angular, Ionic, Capacitor y todas las librerías necesarias.

### (Opcional) Sincronizar plataformas móviles
Si planeas ejecutar en Android o iOS:
```powershell
ionic capacitor sync
```

## Paso 5: Ejecutar la aplicación

### Opción A: Ejecutar en navegador web (RECOMENDADO)

#### Con Ionic CLI:
```powershell
ionic serve
```
La aplicación se abrirá automáticamente en `http://localhost:8100`

#### Con Angular CLI:
```powershell
ng serve
```
La aplicación estará disponible en `http://localhost:4200`

### Opción B: Ejecutar en Android

#### Prerrequisitos:
- Android Studio instalado
- Android SDK configurado
- Emulador creado o dispositivo físico conectado

#### Ejecutar en Android:
```powershell
ionic capacitor run android
```

#### O abrir en Android Studio:
```powershell
ionic capacitor open android
```
Luego ejecutar desde Android Studio (botón ▶ Run).

#### Live reload en dispositivo Android:
```powershell
ionic capacitor run android -l --external
```

### Opción C: Ejecutar en iOS (solo macOS)

#### Prerrequisitos:
- Xcode instalado
- Simulador iOS o dispositivo físico conectado

#### Ejecutar en iOS:
```powershell
ionic capacitor run ios
```

#### O abrir en Xcode:
```powershell
ionic capacitor open ios
```
Luego ejecutar desde Xcode (botón ▶ Run).

#### Live reload en dispositivo iOS:
```powershell
ionic capacitor run ios -l --external
```

## Comandos útiles adicionales

### Construir para producción (web):
```powershell
ionic build --prod
```
Los archivos estarán en `www/`

### Construir para producción (móvil):
```powershell
ionic build --prod
ionic capacitor sync
ionic capacitor open android
# O para iOS:
ionic capacitor open ios
```

### Cambiar puerto de desarrollo:
```powershell
ionic serve --port 8200
```

### Limpiar y reinstalar dependencias:
```powershell
rm -rf node_modules package-lock.json
npm install
```

### Sincronizar cambios con plataformas móviles:
```powershell
ionic capacitor sync
```

## Acceso a la aplicación

### Usuarios de prueba
Después de restaurar la base de datos, puedes usar estos datos para hacer login:
- Consulta la tabla `persona` en PostgreSQL para ver usuarios disponibles
- O crea un usuario nuevo desde la página de registro

### URLs de la aplicación
- **Desarrollo web**: http://localhost:8100 (Ionic) o http://localhost:4200 (Angular)
- **Microservicios**: http://localhost:3000-3099
- **API principal**: http://localhost:3000

## Verificación de que todo funciona

### 1. Verificar PostgreSQL:
```powershell
psql -U myr -d pym -c "SELECT COUNT(*) FROM persona;"
```
Debe mostrar la cantidad de registros en la tabla persona.

### 2. Verificar microservicios:
Abrir en navegador: http://localhost:3000
Debe responder con datos JSON.

### 3. Verificar aplicación Ionic:
Abrir http://localhost:8100 en Chrome. Debe mostrar la página de login.

## Solución de problemas

### Error: "ionic: command not found"
**Solución**: Instalar Ionic CLI globalmente:
```powershell
npm install -g @ionic/cli
```

### Error: No se pueden instalar dependencias
**Solución**: Limpiar y reinstalar:
```powershell
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

### Error: Los microservicios no responden
**Solución**: Verificar que bash.sh esté ejecutándose y PostgreSQL activo:
```bash
cd proyecto/microservicios/
bash bash.sh
```

### Error: Puerto 8100 ocupado
**Solución**: Usar otro puerto:
```powershell
ionic serve --port 8200
```

### Error: Capacitor no sincroniza
**Solución**: Sincronizar manualmente:
```powershell
ionic capacitor sync
npx cap sync
```

### Error: Android no compila
**Solución**: Aceptar licencias de Android SDK:
```powershell
cd %ANDROID_HOME%\tools\bin
sdkmanager --licenses
```
O desde Android Studio: Tools → SDK Manager → SDK Tools

### Error: "Cannot connect to database"
**Solución**: Verificar que PostgreSQL esté corriendo y las credenciales sean correctas en `proyecto/microservicios/config.js`