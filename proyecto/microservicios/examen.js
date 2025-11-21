const express = require('express');
const cors = require('cors');
const multer = require('multer');
const {client} = require('./config');

const app = express();
const port = 3010;
app.use(cors());
app.use(express.json({limit: '50mb'}));

// Configurar multer para archivos en memoria
const storage = multer.memoryStorage();
const upload = multer({ 
    storage: storage,
    limits: { fileSize: 50 * 1024 * 1024 }, // 50MB
    fileFilter: (req, file, cb) => {
        const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf'];
        if (allowedTypes.includes(file.mimetype)) {
            cb(null, true);
        } else {
            cb(new Error('Tipo de archivo no permitido. Solo JPG, PNG y PDF.'));
        }
    }
});

client.connect();

// GET todos los exámenes
app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT * FROM examen ORDER BY fecha_subida DESC');
        res.json(temp.rows)
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener exámenes'});
    }
});

// GET exámenes por persona
app.get('/persona/:idpersona', async (req,res) => {
    try {
        const {idpersona} = req.params;
        const query = 'SELECT * FROM examen WHERE idpersona = $1 ORDER BY fecha_subida DESC';
        const result = await client.query(query, [idpersona]);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener exámenes'});
    }
});

// GET un examen específico
app.get('/:id', async (req,res) => {
    try {
        const {id} = req.params;
        const query = 'SELECT * FROM examen WHERE idexamen = $1';
        const result = await client.query(query, [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({error: 'Examen no encontrado'});
        }
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener el examen'});
    }
});

// POST para subir un examen con imagen/PDF
app.post('/subir', upload.single('file'), async (req,res) => {
    try {
        if (!req.file) {
            return res.status(400).json({error: 'No se proporcionó un archivo'});
        }

        const {idpersona, nombre_examen} = req.body;
        
        if (!idpersona) {
            return res.status(400).json({error: 'idpersona es requerido'});
        }

        // Convertir archivo a base64
        const base64File = req.file.buffer.toString('base64');
        const mimeType = req.file.mimetype;
        const dataUri = `data:${mimeType};base64,${base64File}`;

        const query = `
            INSERT INTO examen(examen, idpersona, imagen, fecha_subida) 
            VALUES($1, $2, $3, NOW()) 
            RETURNING *
        `;
        const values = [
            nombre_examen || `Examen ${req.file.originalname}`,
            idpersona, 
            dataUri
        ];
        
        const result = await client.query(query, values);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al subir el examen'});
    }
});

// DELETE para eliminar un examen
app.delete('/:id', async (req,res) => {
    try {
        const {id} = req.params;
        const query = 'DELETE FROM examen WHERE idexamen = $1 RETURNING *';
        const result = await client.query(query, [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({error: 'Examen no encontrado'});
        }
        res.json({message: 'Examen eliminado correctamente'});
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al eliminar el examen'});
    }
});

app.listen(port, () => {
    console.log(`microservicio examen abierto en el puerto ${port}`)
});
