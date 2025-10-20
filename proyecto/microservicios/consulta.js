const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3002;
app.use(cors())

client.connect();

app.get('/', async (req,res) => {
    try {
        // Soporte de paginación con parámetros limit y offset
        const limit = req.query.limit ? parseInt(req.query.limit) : 100; // Por defecto 100
        const offset = req.query.offset ? parseInt(req.query.offset) : 0;
        
        // Consulta con límite y ordenamiento
        const query = 'SELECT * FROM consulta ORDER BY fecha DESC LIMIT $1 OFFSET $2';
        const temp = await client.query(query, [limit, offset]);
        
        // Obtener el total de registros
        const countResult = await client.query('SELECT COUNT(*) FROM consulta');
        const total = parseInt(countResult.rows[0].count);
        
        res.json({
            data: temp.rows,
            total: total,
            limit: limit,
            offset: offset,
            hasMore: (offset + limit) < total
        });
    } catch (error) {
        console.error('Error en GET /consulta:', error);
        res.status(500).json({ error: error.message });
    }
});

app.post('/', async (req, res) => {
    const {idpersona, idmedico, idfichamedica, fecha, motivo, duracionminutos, observaciones} = req.body
    try {
        const query = 'INSERT INTO consulta(idpersona, idmedico, idfichamedica, fecha, motivo, duracionminutos, observaciones) VALUES ($1, $2, $3, $4, $5, $6, $7)';
        const values = [idpersona, idmedico, idfichamedica, fecha, motivo, duracionminutos, observaciones]
        const result = await client.query(query, values);
        res.json(result.rows)
    } catch (error) {
        throw error
    }
})

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});