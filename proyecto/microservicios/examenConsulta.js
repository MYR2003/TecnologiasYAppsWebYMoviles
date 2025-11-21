const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3011;
app.use(cors());

client.connect();

app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT * FROM examenConsulta');
        res.json(temp.rows)
    } catch (error) {
        throw error
    }
});

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});