const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3016;
app.use(cors());

client.connect();

app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT * FROM persona');
        res.json(temp.rows)
    } catch (error) {
        throw error
    }
});

app.post('/', async (req, res) => {
    const {nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono} = req.body
    try {
        const query = 'INSERT INTO persona(nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono) VALUES ($1, $2, $3, $4, $5, $6, $7)';
        const values = [nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono]
        const result = await client.query(query, values);
        res.json(result.rows)
    } catch (error) {
        throw error
    }
})

// nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono
app.put('/', async (req, res) => {
    // Por ahora se van a pedir todos los atributos para actualizar    
    const {nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono, idPersona} = req.body
    try {
        const query = 'UPDATE persona SET (nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono) VALUES ($1, $2, $3, $4, $5, $6, $7) WHERE idPersona = $8 RETURNING *'
        values = [nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono, idPersona]
        const result = await client.query(query, values)
        res.json(result.rows)
    } catch (error) {
        throw error
    }
})

app.delete('/', async (req, res) => {
    const {id} = req.body
    try {
        const query = 'DELETE FROM persona WHERE idPersona = $1'
        await client.query(query, [id])
        res.json({message:'Exito en la eliminación de datos'})
    } catch (error) {
        throw error
    }
})

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});