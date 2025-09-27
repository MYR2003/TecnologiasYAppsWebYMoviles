const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

// Configura tu conexión PostgreSQL aquí
const pool = new Pool({
  user: 'postgres', // Cambia por tu usuario
  host: 'localhost', // Cambia si tu BD está en otro host
  database: 'biblioteca', // Cambia por el nombre de tu BD
  password: '1234',
  port: 5432,
});

// Obtener todas las personas
app.get('/personas', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM persona');
    // Mapear a camelCase para el frontend
    const personas = result.rows.map(p => ({
      idPersona: p.idpersona,
      nombre: p.nombre,
      apellido: p.apellido,
      rut: p.rut,
      fechaNacimiento: p.fechanacimiento
    }));
    res.json(personas);
  } catch (err) {
    console.error('Error al consultar personas:', err);
    if (err && err.stack) {
      console.error('Stack trace:', err.stack);
    }
    res.status(500).json({ error: 'Error al consultar personas en la base de datos' });
  }
});

// Puedes agregar aquí más endpoints (crear, actualizar, eliminar personas)

app.listen(port, () => {
  console.log(`Microservicio de personas escuchando en http://localhost:${port}`);
});
