# Instructivo de Laravel
En el presente archivo se detallan las instrucciones para correr el proyecto en Laravel y como usando Laravel crear la base de datos y poblaela (se utiliza un simulador de datos en nodejs, debido a que este exitia desde antes de crear el proyecto en Laravel)
## Requisitos
- Tener el repositorio descargado o clonado
- PostgreSQL versión 16 instalado
- Nodejs versión 24 instalado
- Composer versión 2.8.12 instaldo
- PHP versión 8.3.6 instalado

## Usuario de la base de datos
En postgres crear el usuario myr, con contraseña '1234' como superusuario, o correr la siguiente linea de comando en la consola de postgres:
`CREATE ROLE myr WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD '1234';`

# Instalación de dependencias y archivo 
En la carpeta /PYM-Laravel:
Instalar las dependencias siguientes para php:
- php8.3-xml
- php8.3-curl
- php8.3-zip
- php8.3-mbstring
- php8.3-gd
- php8.3-intl
- php8.3-bcmath
- php8.3-pgsql

Añadir el archivo ".env" el cual estara adjunto
Luego correr los comandos:
- npm install
- php artisan key:generate
- php artisan migrate (En caso de problemas con esto correr migrate:fresh, para hacer la migración desde 0)
- npm run build

Con esto estamos casi listos para para correr el proyecto, solo falta poblar la base de datos.
Ir a la carpeta /proyecto/microservicios:
  En esta carpeta abrir el archivo `script_BDD.txt` copiar el contenido y correrlo en la consola de postgres.
  Luego en la misma carpeta correr el comando `node simulador.js`.
  Luego de esto copiar el contenido del archivo `simulador.json` y luego utilizando alguna herraminta para hacer llamadas como Postman o la extensión de VSCode "ThunderClient" hacer una llamada post con body el contenido del archivo `simulador.json`.

Ahora volvemos a la carpeta /PYM-Laravel:
Corremos el comando `php artisan serve`, y con esto el servidor esta corriendo en el puerto 8000.