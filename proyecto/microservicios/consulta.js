const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3002;
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended: true}));

client.connect();

app.get('/', async (req, res) => {
    try {
        const limitParam = Number.parseInt(req.query.limit, 10);
        const offsetParam = Number.parseInt(req.query.offset, 10);
        const idMedicoParam = Number.parseInt(req.query.idmedico, 10);

        const limit = Number.isFinite(limitParam) && limitParam > 0 ? Math.min(limitParam, 100) : 20;
        const offset = Number.isFinite(offsetParam) && offsetParam >= 0 ? offsetParam : 0;
        const idMedicoFilter = Number.isFinite(idMedicoParam) && idMedicoParam > 0 ? idMedicoParam : null;

        const whereClause = idMedicoFilter ? 'WHERE c.idmedico = $1' : '';
        const totalResult = await client.query(
            `SELECT COUNT(*)::int AS count FROM consulta c ${whereClause}`,
            idMedicoFilter ? [idMedicoFilter] : []
        );
        const total = totalResult.rows?.[0]?.count ?? 0;

        const dataSql = `
            SELECT 
                c.*, 
                p.nombre AS nombre_paciente, 
                p.apellido AS apellido_paciente,
                p.rut AS rut_paciente,
                m.nombre AS nombre_medico,
                m.apellido AS apellido_medico
            FROM consulta c
            LEFT JOIN persona p ON p.idpersona = c.idpersona
            LEFT JOIN medico m ON m.idmedico = c.idmedico
            ${whereClause}
            ORDER BY c.idconsulta
            LIMIT $${idMedicoFilter ? 2 : 1} OFFSET $${idMedicoFilter ? 3 : 2}
        `;

        const dataParams = idMedicoFilter ? [idMedicoFilter, limit, offset] : [limit, offset];
        const dataResult = await client.query(dataSql, dataParams);

        const data = (dataResult.rows ?? []).map((row) => ({
            idconsulta: row.idconsulta,
            idpersona: row.idpersona,
            idmedico: row.idmedico,
            idfichamedica: row.idfichamedica,
            fecha: row.fecha,
            motivo: row.motivo ?? null,
            duracionminutos: row.duracionminutos ?? null,
            observaciones: row.observaciones ? String(row.observaciones).slice(0, 5000) : null,
            nombre_paciente: row.nombre_paciente && row.apellido_paciente
                ? `${row.nombre_paciente} ${row.apellido_paciente}`
                : row.nombre_paciente ?? null,
            rut: row.rut_paciente ?? null,
            rut_paciente: row.rut_paciente ?? null,
            medico: row.nombre_medico && row.apellido_medico
                ? `${row.nombre_medico} ${row.apellido_medico}`
                : row.nombre_medico ?? null,
            observacion: row.observaciones ? String(row.observaciones).slice(0, 5000) : null,
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
    const {idpersona, idmedico, idfichamedica, fecha, motivo, duracionminutos, observaciones} = req.body;
    try {
        if (!idpersona || !idmedico || !fecha) {
            return res.status(400).json({
                error: 'Faltan campos obligatorios: idpersona, idmedico y fecha',
            });
        }

        const query = `
            INSERT INTO consulta(idpersona, idmedico, idfichamedica, fecha, motivo, duracionminutos, observaciones)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING *
        `;
        const values = [idpersona, idmedico, idfichamedica || null, fecha, motivo || null, duracionminutos || null, observaciones || null];
        const result = await client.query(query, values);
        
        res.status(201).json({
            success: true,
            message: 'Consulta creada exitosamente',
            data: result.rows?.[0] ?? null,
        });
    } catch (error) {
        console.error('Error al crear consulta:', error);
        res.status(500).json({ error: 'Error al crear consulta' });
    }
});

app.put('/:id', async (req, res) => {
    const {id} = req.params;
    const {idpersona, idmedico, idfichamedica, fecha, motivo, duracionminutos, observaciones} = req.body;

    try {
        if (!id || !idpersona || !idmedico || !fecha) {
            return res.status(400).json({
                error: 'Faltan campos obligatorios: id, idpersona, idmedico y fecha',
            });
        }

        const query = `
            UPDATE consulta
            SET idpersona = $1,
                idmedico = $2,
                idfichamedica = $3,
                fecha = $4,
                motivo = $5,
                duracionminutos = $6,
                observaciones = $7
            WHERE idconsulta = $8
            RETURNING *
        `;
        const values = [
            idpersona,
            idmedico,
            idfichamedica || null,
            fecha,
            motivo || null,
            Number.isFinite(duracionminutos) ? duracionminutos : null,
            observaciones || null,
            id,
        ];

        const result = await client.query(query, values);

        if (!result.rows?.length) {
            return res.status(404).json({ error: 'Consulta no encontrada' });
        }

        res.json({
            success: true,
            message: 'Consulta actualizada correctamente',
            data: result.rows[0],
        });
    } catch (error) {
        console.error('Error al actualizar consulta:', error);
        res.status(500).json({ error: 'Error al actualizar consulta' });
    }
});

app.delete('/:id', async (req, res) => {
    const {id} = req.params;
    try {
        if (!id) {
            return res.status(400).json({ error: 'Falta id de consulta' });
        }

        const result = await client.query(
            'DELETE FROM consulta WHERE idconsulta = $1 RETURNING idconsulta',
            [id],
        );

        if (!result.rows?.length) {
            return res.status(404).json({ error: 'Consulta no encontrada' });
        }

        res.json({
            success: true,
            message: 'Consulta eliminada correctamente',
        });
    } catch (error) {
        console.error('Error al eliminar consulta:', error);
        res.status(500).json({ error: 'Error al eliminar consulta' });
    }
});

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});
