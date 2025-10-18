const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3002;
app.use(cors())

client.connect();

app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT * FROM consulta');
        res.json(temp.rows)
    } catch (error) {
        throw error
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