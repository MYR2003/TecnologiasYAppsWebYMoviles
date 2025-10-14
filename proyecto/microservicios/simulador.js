const {faker} = require('@faker-js/faker');
const {client} = require('./config');
const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
const port = 3099;
app.use(cors());

client.connect();

const nombres = ['Martin', 'Antonio', 'Francisco', 'Ignacio', 'Benjamín', 'Tomás']
const apellidos = ['Mendez', 'Solano', 'Yunge', 'Sanchez', 'Polo', 'Pavez']
const sistemasSalud = ['Isapre', 'Fonasa']

function BooleanoRandom(proba = 0.5) {
    if (typeof proba != Number){
        return false
    }
    if (proba >= 0 && proba <= 1) {
        return Math.random() <= proba;
    }else {
        return Math.random() > proba;
    }
}

function SeleccionRandom(array) {
    return array[Math.floor(Math.random() * array.length)];
}

function NumeroRandom(n) {
    return Math.floor(Math.random() * n)
}

function NumeroEntreNumerosRandom(min = 10000000, max = 28000000) {
    max -= min
    let temp = NumeroRandom(max) + min
    return temp
}

function FechaRandom(desde, hasta) {

}

function Persona() {
    let temp = {
        nombre: '',
        apellido: '',
        rut: 0,/*
        fechaNacimiento: 0,
        sistemaSalud: '',
        domicilio: '',
        telefono: 0* */
    }

    temp.nombre = SeleccionRandom(nombres)
    temp.apellido = SeleccionRandom(apellidos)
    temp.rut = NumeroEntreNumerosRandom(10000000, 28000000)
    return temp
}

function Contacto() {
    let temp = {
        nombre: '',
        apellido: '',
        telefono: 0,/**
        rut:0,
        fechaNacimiento:0,
        direccion:'' */
    }

    temp.nombre = SeleccionRandom(nombres)
    temp.apellido = SeleccionRandom(apellidos)
    temp.telefono = NumeroEntreNumerosRandom(10000000, 99999999)
    return temp
}

function FichaMedica() {
    let temp = {
        altura:0,
        peso:0,
        //presion:0
    }
    temp.altura = NumeroEntreNumerosRandom(160, 190)
    temp.peso = NumeroEntreNumerosRandom(50, 90)
    return temp
}

async function AlergiaPersona() {
    let temp = {
        idpersona: 0,
        idalergia: 0,
        //nota: ''
    }
    const alergias = await client.query('SELECT * FROM alergia')
    const personas = await client.query('SELECT * FROM persona')
    let tempAlergia = SeleccionRandom(alergias.rows)
    let tempPersona = SeleccionRandom(personas.rows)
    temp.idalergia = tempAlergia.idalergia
    temp.idpersona = tempPersona.idpersona
    return temp
}

async function Consulta() {
    let temp = {
        idpersona: 0,
        idmedico: 0,
        fecha: 0,
        idfichamedica:0,
        /*motivo: '',
        duracionminutos:0,
        observaciones:'',*/
    }
    const personas  = await client.query('SELECT * FROM persona')
    const medicos = await client.query('SELECT * FROM medico')
    const fichasmedicas = await client.query('SELECT * FROM fichamedica')
    let tempPersona = SeleccionRandom(personas.rows)
    let tempMedico = SeleccionRandom(medicos.rows)
    let tempFicha = SeleccionRandom(fichasmedicas.rows)
    temp.idpersona = tempPersona.idpersona
    temp.idmedico = tempMedico.idmedico
    temp.idfichamedica = tempFicha.idfichamedica
    temp.fecha = new Date()
    return temp
}

function ConsultaDiagnostico() {}
function ConsultaSintoma() {}
function ConsultaTratamiento() {}
function ExamenConsulta() {}
function Medico() {}
function PersonaContacto() {}
function Receta() {}

/*
Persona()
Contacto()
FichaMedica()
AlergiaPersona()
Consulta()


*/

app.get('/', async (req, res) => {
    const temp = await Consulta()
    res.json(temp)
})

app.post('/persona', async (req, res) => {
    const persona = Persona()
    const query = 'INSERT INTO persona(nombre,apellido,rut) VALUES ($1,$2,$3)';
    const result = await client.query(query, [persona.nombre, persona.apellido, persona.rut])
    res.json(result.rows)
})

app.post('/contacto', async (req, res) => {
    const contacto = Contacto()
    const query = 'INSERT INTO contacto_emergencia(nombre,apellido,telefono) VALUES ($1,$2,$3)';
    const result = await client.query(query, [contacto.nombre, contacto.apellido, contacto.telefono])
    res.json(result.rows)
})

app.post('/fichaMedica', async (req, res) => {
    const fichaMedica = FichaMedica()
    const query = 'INSERT INTO fichamedica(altura,peso) VALUES ($1,$2)';
    const result = await client.query(query, [fichaMedica.altura, fichaMedica.peso])
    res.json(result.rows)
})

app.post('/alergiaPersona', async (req, res) => {
    const alergiaPersona = await AlergiaPersona()
    const query = 'INSERT INTO alergia_persona(idalergia, idpersona) VALUES ($1,$2)';
    const result = await client.query(query, [alergiaPersona.idalergia, alergiaPersona.idpersona])
    res.json(result.rows)
})

app.post('/consulta', async (req, res) => {
    const consulta = await Consulta()
    const query = 'INSERT INTO consulta(idpersona,idmedico,idfichamedica,fecha) VALUES ($1,$2,$3,$4)'
    const result = await client.query(query, [consulta.idpersona, consulta.idmedico, consulta.idfichamedica, consulta.fecha])
    res.json(result.rows)
})

app.listen(port, () => {
    console.log(`simulador de datos abierto en el puerto ${port}`)
})