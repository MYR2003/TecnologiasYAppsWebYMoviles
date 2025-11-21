const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3010;
app.use(cors());
app.use(express.json({limit: '50mb'})); // Para permitir imágenes en base64

client.connect();

// GET todos los exámenes
app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT * FROM examen');
        res.json(temp.rows)
    } catch (error) {
        throw error
    }
});

// GET exámenes por persona
app.get('/persona/:idpersona', async (req,res) => {
    try {
        const {idpersona} = req.params;
        const query = 'SELECT * FROM examen WHERE idpersona = $1';
        const result = await client.query(query, [idpersona]);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener exámenes'});
    }
});

// POST para crear un examen con imagen
app.post('/', async (req,res) => {
    try {
        const {idtipoexamen, examen, idpersona, imagen} = req.body;
        const query = 'INSERT INTO examen(idtipoexamen, examen, idpersona, imagen, fecha_subida) VALUES($1, $2, $3, $4, NOW()) RETURNING *';
        const values = [idtipoexamen, examen, idpersona, imagen];
        const result = await client.query(query, values);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al crear el examen'});
    }
});

// PUT para actualizar un examen (incluye imagen)
app.put('/:id', async (req,res) => {
    try {
        const {id} = req.params;
        const {idtipoexamen, examen, imagen} = req.body;
        const query = 'UPDATE examen SET idtipoexamen=$1, examen=$2, imagen=$3 WHERE idexamen=$4 RETURNING *';
        const values = [idtipoexamen, examen, imagen, id];
        const result = await client.query(query, values);
        if (result.rows.length === 0) {
            return res.status(404).json({error: 'Examen no encontrado'});
        }
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al actualizar el examen'});
    }
});

// GET solicitudes de acceso de un examen
app.get('/accesos/:examenId', async (req,res) => {
    try {
        const {examenId} = req.params;
        const query = `
            SELECT ea.*, p.nombre, p.apellido 
            FROM examen_accesos ea
            JOIN persona p ON ea.usuario_solicitante_id = p.idpersona
            WHERE ea.examen_id = $1
            ORDER BY ea.fecha_solicitud DESC
        `;
        const result = await client.query(query, [examenId]);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener solicitudes de acceso'});
    }
});

// POST para solicitar acceso a un examen
app.post('/accesos', async (req,res) => {
    try {
        const {examen_id, usuario_solicitante_id} = req.body;
        const query = 'INSERT INTO examen_accesos(examen_id, usuario_solicitante_id) VALUES($1, $2) RETURNING *';
        const result = await client.query(query, [examen_id, usuario_solicitante_id]);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al solicitar acceso'});
    }
});

// PUT para responder a una solicitud de acceso
app.put('/accesos/:id', async (req,res) => {
    try {
        const {id} = req.params;
        const {estado} = req.body; // 'aprobado' o 'rechazado'
        const query = 'UPDATE examen_accesos SET estado=$1, fecha_respuesta=NOW() WHERE id=$2 RETURNING *';
        const result = await client.query(query, [estado, id]);
        if (result.rows.length === 0) {
            return res.status(404).json({error: 'Solicitud no encontrada'});
        }
        res.json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al actualizar solicitud'});
    }
});

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});