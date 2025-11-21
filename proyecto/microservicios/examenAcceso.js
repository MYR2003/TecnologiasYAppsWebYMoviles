const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3057;
app.use(cors());
app.use(express.json());

client.connect();

// GET todas las solicitudes de acceso
app.get('/', async (req,res) => {
    try {
        const query = `
            SELECT ea.*, 
                   p_solicitante.nombre as solicitante_nombre, 
                   p_solicitante.apellido as solicitante_apellido,
                   e.examen as nombre_examen,
                   e.idpersona as paciente_id
            FROM examen_accesos ea
            JOIN persona p_solicitante ON ea.usuario_solicitante_id = p_solicitante.idpersona
            JOIN examen e ON ea.examen_id = e.idexamen
            ORDER BY ea.fecha_solicitud DESC
        `;
        const result = await client.query(query);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener solicitudes'});
    }
});

// GET solicitudes pendientes para un paciente
app.get('/paciente/:idpaciente/pendientes', async (req,res) => {
    try {
        const {idpaciente} = req.params;
        const query = `
            SELECT ea.*, 
                   p_solicitante.nombre as solicitante_nombre, 
                   p_solicitante.apellido as solicitante_apellido,
                   e.examen as nombre_examen,
                   e.idexamen,
                   e.fecha_subida
            FROM examen_accesos ea
            JOIN persona p_solicitante ON ea.usuario_solicitante_id = p_solicitante.idpersona
            JOIN examen e ON ea.examen_id = e.idexamen
            WHERE e.idpersona = $1 AND ea.estado = 'pendiente'
            ORDER BY ea.fecha_solicitud DESC
        `;
        const result = await client.query(query, [idpaciente]);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener solicitudes pendientes'});
    }
});

// GET solicitudes por mÃ©dico
app.get('/medico/:idmedico', async (req,res) => {
    try {
        const {idmedico} = req.params;
        const query = `
            SELECT ea.*, 
                   e.examen as nombre_examen,
                   e.idpersona as paciente_id,
                   p_paciente.nombre as paciente_nombre,
                   p_paciente.apellido as paciente_apellido
            FROM examen_accesos ea
            JOIN examen e ON ea.examen_id = e.idexamen
            JOIN persona p_paciente ON e.idpersona = p_paciente.idpersona
            WHERE ea.usuario_solicitante_id = $1
            ORDER BY ea.fecha_solicitud DESC
        `;
        const result = await client.query(query, [idmedico]);
        res.json(result.rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al obtener solicitudes del mÃ©dico'});
    }
});

// GET verificar si un mÃ©dico tiene acceso aprobado a un examen
app.get('/verificar/:examenId/:medicoId', async (req,res) => {
    try {
        const {examenId, medicoId} = req.params;
        const query = `
            SELECT * FROM examen_accesos 
            WHERE examen_id = $1 
            AND usuario_solicitante_id = $2 
            AND estado = 'aprobado'
        `;
        const result = await client.query(query, [examenId, medicoId]);
        res.json({
            tieneAcceso: result.rows.length > 0,
            acceso: result.rows[0] || null
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al verificar acceso'});
    }
});

// GET verificar estado de solicitud
app.get('/estado/:examenId/:medicoId', async (req,res) => {
    try {
        const {examenId, medicoId} = req.params;
        const query = `
            SELECT * FROM examen_accesos 
            WHERE examen_id = $1 
            AND usuario_solicitante_id = $2 
            ORDER BY fecha_solicitud DESC 
            LIMIT 1
        `;
        const result = await client.query(query, [examenId, medicoId]);
        if (result.rows.length === 0) {
            return res.json({estado: 'sin_solicitud', solicitud: null});
        }
        res.json({
            estado: result.rows[0].estado,
            solicitud: result.rows[0]
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al verificar estado'});
    }
});

// POST para solicitar acceso a un examen
app.post('/', async (req,res) => {
    try {
        const {examen_id, usuario_solicitante_id} = req.body;
        
        if (!examen_id || !usuario_solicitante_id) {
            return res.status(400).json({error: 'Faltan datos requeridos'});
        }

        // Verificar si ya existe una solicitud pendiente
        const checkQuery = `
            SELECT * FROM examen_accesos 
            WHERE examen_id = $1 
            AND usuario_solicitante_id = $2 
            AND estado = 'pendiente'
        `;
        const existing = await client.query(checkQuery, [examen_id, usuario_solicitante_id]);
        
        if (existing.rows.length > 0) {
            return res.status(400).json({error: 'Ya existe una solicitud pendiente'});
        }

        const query = `
            INSERT INTO examen_accesos(examen_id, usuario_solicitante_id, estado, fecha_solicitud) 
            VALUES($1, $2, 'pendiente', NOW()) 
            RETURNING *
        `;
        const result = await client.query(query, [examen_id, usuario_solicitante_id]);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al solicitar acceso'});
    }
});

// PUT para responder a una solicitud de acceso (aprobar o rechazar)
app.put('/:id', async (req,res) => {
    try {
        const {id} = req.params;
        const {estado} = req.body;
        
        if (!['aprobado', 'rechazado'].includes(estado)) {
            return res.status(400).json({error: 'Estado invÃ¡lido. Debe ser "aprobado" o "rechazado"'});
        }

        const query = `
            UPDATE examen_accesos 
            SET estado = $1, fecha_respuesta = NOW() 
            WHERE id = $2 
            RETURNING *
        `;
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

// DELETE para eliminar una solicitud
app.delete('/:id', async (req,res) => {
    try {
        const {id} = req.params;
        const query = 'DELETE FROM examen_accesos WHERE id = $1 RETURNING *';
        const result = await client.query(query, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({error: 'Solicitud no encontrada'});
        }
        
        res.json({message: 'Solicitud eliminada correctamente'});
    } catch (error) {
        console.error(error);
        res.status(500).json({error: 'Error al eliminar solicitud'});
    }
});

app.listen(port, () => {
    console.log(`microservicio examen_accesos abierto en el puerto ${port}`)
});

