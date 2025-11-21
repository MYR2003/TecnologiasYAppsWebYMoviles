const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3002;
app.use(cors())

client.connect();

app.get('/', async (req, res) => {
    try {
        const limitParam = Number.parseInt(req.query.limit, 10);
        const offsetParam = Number.parseInt(req.query.offset, 10);

        const limit = Number.isFinite(limitParam) && limitParam > 0 ? Math.min(limitParam, 100) : 20;
        const offset = Number.isFinite(offsetParam) && offsetParam >= 0 ? offsetParam : 0;

        const totalResult = await client.query('SELECT COUNT(*)::int AS count FROM consulta');
        const total = totalResult.rows?.[0]?.count ?? 0;

        const dataResult = await client.query(
            'SELECT * FROM consulta ORDER BY idconsulta LIMIT $1 OFFSET $2',
            [limit, offset]
        );

        const data = (dataResult.rows ?? []).map((row) => ({
            idconsulta: row.idconsulta,
            idpersona: row.idpersona,
            idmedico: row.idmedico,
            idfichamedica: row.idfichamedica,
            fecha: row.fecha,
            motivo: row.motivo ?? null,
            duracionminutos: row.duracionminutos ?? null,
            observaciones: row.observaciones ? String(row.observaciones).slice(0, 5000) : null,
        }));
        const hasMore = offset + data.length < total;

        res.json({
            data,
            total,
            limit,
            offset,
            hasMore
        });
    } catch (error) {
        console.error('Error al obtener consultas:', error);
        res.status(500).json({ error: 'Error al obtener consultas' });
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