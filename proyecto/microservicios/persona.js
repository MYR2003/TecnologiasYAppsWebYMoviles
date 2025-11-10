const express = require('express');
const cors = require('cors');
const {client} = require('./config');

const app = express();
const port = 3016;

// Middlewares necesarios
app.use(cors());
app.use(express.json()); // Para parsear JSON en req.body
app.use(express.urlencoded({ extended: true })); // Para parsear form data

client.connect();

app.get('/', async (req,res) => {
    try {
        const temp = await client.query('SELECT idpersona, nombre, apellido, rut, fechanacimiento, sistemadesalud, domicilio, telefono FROM persona ORDER BY idpersona');
        res.json(temp.rows)
    } catch (error) {
        console.error('Error en GET:', error);
        res.status(500).json({error: error.message})
    }
});

app.post('/', async (req, res) => {
    const {nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono} = req.body
    try {
        if (!nombre || !apellido || !rut) {
            return res.status(400).json({error: 'Faltan campos obligatorios: nombre, apellido y rut'})
        }
        // PostgreSQL convierte a minúsculas sin comillas
        const query = 'INSERT INTO persona(nombre, apellido, rut, fechanacimiento, sistemadesalud, domicilio, telefono) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *';
        const values = [
            nombre, 
            apellido, 
            rut, 
            fechaNacimiento || null,
            sistemaDeSalud || null,
            domicilio || null,
            telefono || null
        ]
        const result = await client.query(query, values);
        res.status(201).json(result.rows)
    } catch (error) {
        console.error('Error en POST:', error);
        res.status(500).json({error: error.message})
    }
})

// nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono
app.put('/', async (req, res) => {
    // Por ahora se van a pedir todos los atributos para actualizar    
    const {nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, telefono, idPersona} = req.body
    try {
        if (!nombre || !apellido || !rut || !idPersona) {
            return res.status(400).json({error: 'Faltan campos obligatorios: nombre, apellido, rut e idPersona'})
        }
        // PostgreSQL convierte a minúsculas sin comillas
        const query = 'UPDATE persona SET nombre = $1, apellido = $2, rut = $3, fechanacimiento = $4, sistemadesalud = $5, domicilio = $6, telefono = $7 WHERE idpersona = $8 RETURNING *'
        const values = [
            nombre, 
            apellido, 
            rut, 
            fechaNacimiento || null,
            sistemaDeSalud || null,
            domicilio || null,
            telefono || null,
            idPersona
        ]
        const result = await client.query(query, values)
        res.json(result.rows)
    } catch (error) {
        console.error('Error en PUT:', error);
        res.status(500).json({error: error.message})
    }
})

app.delete('/', async (req, res) => {
    const {id} = req.body
    try {
        // PostgreSQL convierte a minúsculas sin comillas
        const query = 'DELETE FROM persona WHERE idpersona = $1'
        await client.query(query, [id])
        res.json({message:'Exito en la eliminación de datos'})
    } catch (error) {
        console.error('Error en DELETE:', error);
        res.status(500).json({error: error.message})
    }
})

app.listen(port, () => {
    console.log(`microservicio abierto en el puerto ${port}`)
});