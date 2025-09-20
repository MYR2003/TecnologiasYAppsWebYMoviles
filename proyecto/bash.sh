# Terminal A
cd microservicios/libros
json-server --watch db.json --port 4002

# Terminal B
cd microservicios/prestamos
json-server --watch db.json --port 4003
