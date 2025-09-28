const express = require('express');
const multer = require('multer');
const cors = require('cors');
const AWS = require('aws-sdk');
const { Pool } = require('pg');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const storage = multer.memoryStorage();
const upload = multer({ storage });

// Configura tu conexión PostgreSQL aquí
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'biblioteca',
  password: '1234',
  port: 5432,
});

AWS.config.update({ region: 'us-east-1' });
const rekognition = new AWS.Rekognition();
const textract = new AWS.Textract();

async function rekognitionOCR(buffer) {
  const params = {
    Image: { Bytes: buffer }
  };
  try {
    const result = await rekognition.detectText(params).promise();
    const lines = result.TextDetections
      .filter(det => det.Type === 'LINE')
      .map(det => det.DetectedText);
    return lines.join('\n');
  } catch (err) {
    console.error('Error Rekognition:', err);
    return 'Error al extraer texto con AWS Rekognition';
  }
}

async function textractOCR(buffer) {
  const params = {
    Document: { Bytes: buffer }
  };
  try {
    const result = await textract.detectDocumentText(params).promise();
    const lines = result.Blocks
      .filter(block => block.BlockType === 'LINE')
      .map(block => block.Text);
    return lines.join('\n');
  } catch (err) {
    console.error('Error Textract:', err);
    return 'Error al extraer texto con AWS Textract';
  }
}

// Subir imagen y crear examen
app.post('/api/examenes/subir', upload.single('file'), async (req, res) => {
  const { idPersona } = req.body;
  if (!req.file) return res.status(400).json({ error: 'No se subió archivo' });
  const idPersonaNum = Number(idPersona);
  if (isNaN(idPersonaNum)) {
    return res.status(400).json({ error: 'idPersona inválido' });
  }
  let datosExtraidos = '';
  let imagen = '';
  let archivo = req.file.originalname;

  if (req.file.mimetype === 'application/pdf') {
    datosExtraidos = await textractOCR(req.file.buffer);
    imagen = '';
  } else if (req.file.mimetype === 'image/jpeg' || req.file.mimetype === 'image/png') {
    datosExtraidos = await rekognitionOCR(req.file.buffer);
    imagen = `data:${req.file.mimetype};base64,${req.file.buffer.toString('base64')}`;
  } else {
    return res.status(400).json({ error: 'Tipo de archivo no soportado' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO examen (idPersona, fecha, archivo, datosExtraidos) VALUES ($1, $2, $3, $4) RETURNING idExamen',
      [idPersonaNum, new Date().toISOString().slice(0, 10), archivo, datosExtraidos]
    );
      const idExamen = result.rows[0].idexamen;
      const examen = {
        idExamen: idExamen,
        idPersona: idPersonaNum,
        fecha: new Date().toISOString().slice(0, 10),
        imagen,
        datosExtraidos,
        archivo
      };
      res.json(examen);
  } catch (err) {
    console.error('Error al insertar en la base de datos:', err);
    if (err && err.stack) {
      console.error('Stack trace:', err.stack);
    }
    res.status(500).json({ error: 'Error al guardar en la base de datos' });
  }
});

// Endpoint para obtener todos los exámenes desde la base de datos
app.get('/api/examenes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM examen');
    // Si quieres incluir la imagen, deberás almacenarla en la BD o en un storage externo
    // Aquí solo se devuelven los datos almacenados en la tabla examen
      // Mapear a camelCase para el frontend
      const examenes = result.rows.map(e => ({
        idExamen: e.idexamen,
        idPersona: e.idpersona,
        fecha: e.fecha,
        archivo: e.archivo,
        datosExtraidos: e.datosextraidos
      }));
      res.json(examenes);
  } catch (err) {
    console.error('Error al consultar exámenes:', err);
    if (err && err.stack) {
      console.error('Stack trace:', err.stack);
    }
    res.status(500).json({ error: 'Error al consultar exámenes en la base de datos' });
  }
});

// Obtener examen por id

// Eliminar examen de la base de datos
app.delete('/api/examenes/:id', async (req, res) => {
  const idExamen = Number(req.params.id);
  try {
    await pool.query('DELETE FROM examen WHERE idExamen = $1', [idExamen]);
    res.status(204).send();
  } catch (err) {
    console.error('Error al eliminar examen:', err);
    if (err && err.stack) {
      console.error('Stack trace:', err.stack);
    }
    res.status(500).json({ error: 'Error al eliminar examen en la base de datos' });
  }
});

app.listen(port, () => {
  console.log(`Mock backend escuchando en http://localhost:${port}`);
});
