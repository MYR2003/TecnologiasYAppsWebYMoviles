const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3015;
app.use(cors());
app.use(express.json());

client.connect();

app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT m.*, e.especialidad FROM medico m LEFT JOIN especialidad e ON m.idespecialidad = e.idespecialidad ORDER BY m.idmedico');
        res.json(temp.rows)
    } catch (error) {
        console.error('Error en GET /:', error);
        res.status(500).json({ error: error.message });
    }
});

app.get('/:id', async (req,res) => {
    try {
        const { id } = req.params;
        const temp = await client.query('SELECT m.*, e.especialidad FROM medico m LEFT JOIN especialidad e ON m.idespecialidad = e.idespecialidad WHERE m.idmedico = $1', [id]);
        if (temp.rows.length === 0) {
            return res.status(404).json({ error: 'Médico no encontrado' });
        }
        res.json(temp.rows[0]);
    } catch (error) {
        console.error('Error en GET /:id:', error);
        res.status(500).json({ error: error.message });
    }
});

app.put('/:id', async (req,res) => {
    try {
        const { id } = req.params;
        const { nombre, apellido, rut, fechanacimiento, telefono, email } = req.body;
        
        // Validación de campos requeridos
        if (!nombre || !apellido || !rut) {
            return res.status(400).json({ 
                error: 'Los campos nombre, apellido y rut son requeridos' 
            });
        }

        const query = `
            UPDATE medico 
            SET nombre = $1, 
                apellido = $2, 
                rut = $3, 
                fechanacimiento = $4, 
                telefono = $5, 
                email = $6 
            WHERE idmedico = $7 
            RETURNING *
        `;
        
        const valores = [
            nombre.trim(),
            apellido.trim(),
            rut.trim(),
            fechanacimiento || null,
            telefono ? telefono.trim() : null,
            email ? email.trim() : null,
            id
        ];

        const resultado = await client.query(query, valores);
        
        if (resultado.rows.length === 0) {
            return res.status(404).json({ error: 'Médico no encontrado' });
        }

        res.json({ 
            success: true, 
            message: 'Médico actualizado correctamente',
            data: resultado.rows[0] 
        });
    } catch (error) {
        console.error('Error en PUT /:id:', error);
        res.status(500).json({ 
            success: false,
            error: error.message 
        });
    }
});

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});