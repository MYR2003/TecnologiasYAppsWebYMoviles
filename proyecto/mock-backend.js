const express = require('express');
const multer = require('multer');
const cors = require('cors');
const AWS = require('aws-sdk');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const storage = multer.memoryStorage();
const upload = multer({ storage });

let examenes = [];
let idExamen = 1;

// Configura tus credenciales de AWS (puedes usar variables de entorno o archivo de configuración)
AWS.config.update({ region: 'us-east-1' }); // Cambia la región si es necesario
const rekognition = new AWS.Rekognition();

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

// Subir imagen y crear examen
app.post('/api/examenes/subir', upload.single('file'), async (req, res) => {
  const { idPersona } = req.body;
  if (!req.file) return res.status(400).json({ error: 'No se subió imagen' });
  const datosExtraidos = await rekognitionOCR(req.file.buffer);
  const examen = {
    idExamen: idExamen++,
    idPersona: Number(idPersona),
    fecha: new Date().toISOString().slice(0, 10),
    imagen: `data:${req.file.mimetype};base64,${req.file.buffer.toString('base64')}`,
    datosExtraidos
  };
  examenes.unshift(examen);
  res.json(examen);
});

// Listar exámenes por persona
app.get('/api/examenes', (req, res) => {
  const idPersona = Number(req.query.idPersona);
  res.json(examenes.filter(e => e.idPersona === idPersona));
});

// Obtener examen por id
app.get('/api/examenes/:id', (req, res) => {
  const examen = examenes.find(e => e.idExamen === Number(req.params.id));
  if (!examen) return res.status(404).json({ error: 'No encontrado' });
  res.json(examen);
});

// Eliminar examen
app.delete('/api/examenes/:id', (req, res) => {
  examenes = examenes.filter(e => e.idExamen !== Number(req.params.id));
  res.status(204).send();
});

app.listen(port, () => {
  console.log(`Mock backend escuchando en http://localhost:${port}`);
});
