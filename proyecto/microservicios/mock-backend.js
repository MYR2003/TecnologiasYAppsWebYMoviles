const express = require('express');
const multer = require('multer');
const cors = require('cors');
const Tesseract = require('tesseract.js');
const pdfParse = require('pdf-parse');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const storage = multer.memoryStorage();
const upload = multer({ storage });

// Simulamos una base de datos en memoria
let examenes = [];

async function extraerTextoDeImagen(buffer) {
  try {
    const resultado = await Tesseract.recognize(buffer, 'spa+eng', {
      logger: () => {}
    });
    return (resultado.data.text || '').trim();
  } catch (err) {
    console.error('Error Tesseract:', err);
    return 'No se pudo extraer texto de la imagen';
  }
}

async function extraerTextoDePdf(buffer) {
  try {
    const data = await pdfParse(buffer);
    return (data.text || '').trim();
  } catch (err) {
    console.error('Error pdf-parse:', err);
    return 'No se pudo extraer texto del PDF';
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
  const archivo = req.file.originalname;

  if (req.file.mimetype === 'application/pdf') {
    datosExtraidos = await extraerTextoDePdf(req.file.buffer);
  } else if (req.file.mimetype === 'image/jpeg' || req.file.mimetype === 'image/png') {
    datosExtraidos = await extraerTextoDeImagen(req.file.buffer);
    imagen = `data:${req.file.mimetype};base64,${req.file.buffer.toString('base64')}`;
  } else {
    return res.status(400).json({ error: 'Tipo de archivo no soportado' });
  }

  if (!datosExtraidos) {
    datosExtraidos = 'Sin texto reconocido';
  }

  try {
    const idExamen = examenes.length + 1;
    const examen = {
      idExamen: idExamen,
      idPersona: idPersonaNum,
      fecha: new Date().toISOString().slice(0, 10),
      imagen,
      datosExtraidos,
      archivo
    };
    examenes.push(examen);
    res.json(examen);
  } catch (err) {
    console.error('Error al procesar:', err);
    res.status(500).json({ error: 'Error al procesar el archivo' });
  }
});

// Endpoint para obtener todos los exámenes desde la memoria
app.get('/api/examenes', async (req, res) => {
  try {
    res.json(examenes);
  } catch (err) {
    console.error('Error al consultar exámenes:', err);
    res.status(500).json({ error: 'Error al consultar exámenes' });
  }
});

// Eliminar examen de la memoria
app.delete('/api/examenes/:id', async (req, res) => {
  const idExamen = Number(req.params.id);
  try {
    examenes = examenes.filter(e => e.idExamen !== idExamen);
    res.status(204).send();
  } catch (err) {
    console.error('Error al eliminar examen:', err);
    res.status(500).json({ error: 'Error al eliminar examen' });
  }
});

app.listen(port, () => {
  console.log(`Mock backend escuchando en http://localhost:${port}`);
});
