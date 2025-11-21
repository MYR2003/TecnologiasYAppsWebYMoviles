const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3101;
app.use(cors())

client.connect();

app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT especialidad,COUNT(idconsulta) FROM consulta AS c INNER JOIN (SELECT idmedico,especialidad FROM medico AS m INNER JOIN especialidad AS e ON m.idespecialidad = e.idespecialidad) AS z on c.idmedico = z.idmedico GROUP BY especialidad');
        res.json(temp.rows)
    } catch (error) {
        throw error
    }
});

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});