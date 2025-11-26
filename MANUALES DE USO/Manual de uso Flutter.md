# Instructivo de Flutter
En este archivo se detallan las instrucciones para descargar y usar Flutter de manera local y correr el proyecto PYM-Flutter, junto con los microservicios y los datos que consume.

## Requisitos
- Repo descargado o clonado
- Node.js 18+
- PostgreSQL 16
- Java JDK 17+
- Flutter SDK estable
- Google Chrome para correr en web
- Opcional: Android Studio (para SDK, emulador y licencias) o un dispositivo Android con depuracion USB

## Usuario de la base de datos
En postgres crear el usuario myr, con contraseña '1234' como superusuario, o correr la siguiente linea de comando en la consola de postgres:
`CREATE ROLE myr WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD '1234';`

## Base de datos (Si hiciste el paso anterior, ese es tu usuario y contraseña)
1) Crea/restaura la BD `pym` usando el dump completo en `proyecto/biblioteca-ms/src/app/bbdd/pym.sql`:
   ```powershell
   psql -U <usuario> -h localhost -f proyecto/biblioteca-ms/src/app/bbdd/pym.sql
   ```
   - Asegurate de que el usuario tenga permisos para crear DB y objetos (el dump crea la DB `pym`).
2) Opcional: para datos de prueba masivos, carga `proyecto/microservicios/generar_10000_consultas.sql` sobre la BD `pym`:
   ```powershell
   psql -U <usuario> -h localhost -d pym -f proyecto/microservicios/generar_10000_consultas.sql
   ```
3) Si necesitas cambiar credenciales de conexion de los microservicios, edita `proyecto/microservicios/config.js` (user, password, host, database = "pym", port = 5432).

## Ejecución BBDD
- En una terminal Bash:
 
 ```bash
   cd proyecto/microservicios/
   ```

 ```bash
   npm install
   ```

 ```bash
   bash bash.sh
   ```

## Simulador de datos pequeño (Si no hiciste el de 10000 consultas)
1) En otra terminal, misma carpeta: `node simulador.js`
2) Haz POST a `http://localhost:3099/` con el cuerpo de `proyecto/microservicios/jsonBody-para-simulador.json` (ajusta cantidades). `simulador.json` sirve de referencia.

## Instalacion de Flutter
1. Descargar el SDK estable desde https://docs.flutter.dev/get-started/install/windows (archivo .zip).
2. Descomprimir en C:\src\flutter (o carpeta sin espacios).
3. Agregar C:\src\flutter\bin al PATH del usuario/sistema y reiniciar la terminal.
4. Verificar la instalacion con:
   flutter doctor
   Si usas Android: flutter doctor --android-licenses y aceptar las licencias.
5. Solo si usas android: En Android Studio instalar el Android SDK y crear un emulador (AVD) si no usaras dispositivo fisico.

## Configuracion del proyecto
En la carpeta /PYM-Flutter:
- flutter pub get
- flutter config --enable-web (se desea correr en Chrome).

## Ejecucion
- flutter run (sigues indicaciones)
- Para web de una: flutter run -d chrome
- Si hay varios dispositivos, listar con flutter devices y usar flutter run -d <id>.

## Notas
- Si cambias de host (no localhost/127.0.0.1/10.0.2.2), ajusta el host base en `PYM-Flutter/lib/servicios/api.dart`.
- Verifica que Postgres, los microservicios (bash.sh) y el simulador esten activos antes de probar la app.
- Si la app consume APIs o microservicios externos, asegurate de tenerlos corriendo y con las URLs configuradas para tu entorno local.
- Si cambias la ruta de instalacion del SDK, actualiza el PATH y reinicia la terminal antes de volver a ejecutar los comandos.
