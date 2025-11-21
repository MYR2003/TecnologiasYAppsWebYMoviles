const { faker } = require('@faker-js/faker');
const { client } = require('./config');
const express = require('express');
const cors = require('cors');
const bodyParse = require('body-parser')
const axios = require('axios')

const app = express();
const port = 3099;
app.use(cors());

client.connect();

const nombres = ['Martin', 'Antonio', 'Francisco', 'Ignacio', 'Benjamín', 'Tomás']
const apellidos = ['Mendez', 'Solano', 'Yunge', 'Sanchez', 'Polo', 'Pavez']
const sistemasSalud = ['Isapre', 'Fonasa']

function BooleanoRandom(proba = 0.5) {
    if (typeof proba != Number) {
        return false
    }
    if (proba >= 0 && proba <= 1) {
        return Math.random() <= proba;
    } else {
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
        altura: 0,
        peso: 0,
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
        idfichamedica: 0,
        /*motivo: '',
        duracionminutos:0,
        observaciones:'',*/
    }
    const personas = await client.query('SELECT * FROM persona')
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

async function ConsultaDiagnostico() {
    let temp = {
        idconsulta: 0,
        iddiagnostico: 0,
        //esprincipal,''
    }
    const consultas = await client.query('SELECT * FROM consulta')
    const diagnosticos = await client.query('SELECT * FROM diagnostico')
    let tempConsulta = SeleccionRandom(consultas.rows)
    let tempDiagnostico = SeleccionRandom(diagnosticos.rows)
    temp.idconsulta = tempConsulta.idconsulta
    temp.iddiagnostico = tempDiagnostico.iddiagnostico
    return temp
}

async function ConsultaSintoma() {
    let temp = {
        idconsulta: 0,
        idsintoma: 0,
        /*
        severidad:'',
        nota:''
        */
    }
    const consultas = await client.query('SELECT * FROM consulta')
    const sintomas = await client.query('SELECT * FROM sintoma')
    let tempConsulta = SeleccionRandom(consultas.rows)
    let tempSintoma = SeleccionRandom(sintomas.rows)
    temp.idconsulta = tempConsulta.idconsulta
    temp.idsintoma = tempSintoma.idsintoma
    return temp
}

async function ConsultaTratamiento() {
    let temp = {
        idconsulta: 0,
        idtratamiento: 0,
        /*
        instrucciones:'',
        fechainicio:0,
        fechafin:0
        */
    }
    const consultas = await client.query('SELECT * FROM consulta')
    const tratamientos = await client.query('SELECT * FROM tratamiento')
    let tempConsulta = SeleccionRandom(consultas.rows)
    let tempTratamiento = SeleccionRandom(tratamientos.rows)
    temp.idconsulta = tempConsulta.idconsulta
    temp.idtratamiento = tempTratamiento.idtratamiento
    return temp
}

async function ExamenConsulta() {
    let temp = {
        idconsulta: 0,
        idexamen: 0,
        /*
        resultadosexamen:''
        */
    }
    const consultas = await client.query('SELECT * FROM consulta')
    const examenes = await client.query('SELECT * FROM examen')
    let tempConsulta = SeleccionRandom(consultas.rows)
    let tempExamen = SeleccionRandom(examenes.rows)
    temp.idconsulta = tempConsulta.idconsulta
    temp.idexamen = tempExamen.idexamen
    return temp
}

async function Medico() {

    let temp = {
        idespecialidad: 0,
        nombre: '',
        apellido: '',
        rut: 0,
        /*
        fechanacimiento:0,
        telefono:0,
        email:''
        */
    }
    const especialidades = await client.query('SELECT * FROM especialidad')
    let tempEspecialidad = SeleccionRandom(especialidades.rows)
    temp.idespecialidad = tempEspecialidad.idespecialidad
    temp.nombre = SeleccionRandom(nombres)
    temp.apellido = SeleccionRandom(apellidos)
    temp.rut = NumeroEntreNumerosRandom(10000000, 28000000)
    return temp
}

async function PersonaContacto() {
    let temp = {
        idpersona: 0,
        idcontacto: 0,
        /*
        relacion:'',
        esprincipal:false
        */
    }
    const personas = await client.query('SELECT * FROM persona')
    const contacto = await client.query('SELECT * FROM contacto_emergencia')
    let tempPersona = SeleccionRandom(personas.rows)
    let tempContacto = SeleccionRandom(contacto.rows)
    temp.idpersona = tempPersona.idpersona
    temp.idcontacto = tempContacto.idcontacto
    return temp
}

async function Receta() {
    let temp = {
        idmedicamento: 0,
        idconsulta: 0,
        /*
        cantidad:0,
        medidas:'',
        instrucciones:''
        */
    }
    const medicamentos = await client.query('SELECT * FROM medicamento')
    const consultas = await client.query('SELECT * FROM consulta')
    let tempMedicamento = SeleccionRandom(medicamentos.rows)
    let tempConsulta = SeleccionRandom(consultas.rows)
    temp.idmedicamento = tempMedicamento.idmedicamento
    temp.idconsulta = tempConsulta.idconsulta
    return temp
}

app.use(bodyParse.json());

app.post('/', async (req, res) => {
    //const requestBody = req.body;
    const { persona, contacto, fichaMedica,
        alergiaPersona, consulta, consultaDiagnostico,
        consultaSintoma, consultaTratamiento, examenConsulta,
        medico, personaContacto, receta,
    } = req.body

    for (let i = 0; i < persona; i++) {
        let temp = Persona()
        try {
            await axios.post('http://localhost:3099/persona',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de persona realizado con exito')
        } catch (error) {
            console.log('Error en el post de persona')
        }
    }

    for (let i = 0; i < contacto; i++) {
        let temp = Contacto()
        try {
            await axios.post('http://localhost:3099/contacto',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de contacto de emergencia realizado con exito')
        } catch (error) {
            console.log('Error en el post de contacto de emergencia')
        }
    }

    for (let i = 0; i < fichaMedica; i++) {
        let temp = FichaMedica()
        try {
            await axios.post('http://localhost:3099/fichaMedica',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de ficha medica realizado con exito')
        } catch (error) {
            console.log('Error en el post de ficha medica')
        }
    }

    for (let i = 0; i < alergiaPersona; i++) {
        let temp = AlergiaPersona()
        try {
            await axios.post('http://localhost:3099/alergiaPersona',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de alergia-persona realizado con exito')
        } catch (error) {
            console.log('Error en el post de alergia-persona')
        }
    }

    for (let i = 0; i < medico; i++) {
        let temp = Medico()
        try {
            await axios.post('http://localhost:3099/medico',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de medico realizado con exito')
        } catch (error) {
            console.log('Error en el post de medico')
        }
    }

    for (let i = 0; i < consulta; i++) {
        let temp = Consulta()
        try {
            await axios.post('http://localhost:3099/consulta',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de consulta realizado con exito')
        } catch (error) {
            console.log('Error en el post de consulta')
        }
    }

    for (let i = 0; i < consultaSintoma; i++) {
        let temp = ConsultaSintoma()
        try {
            await axios.post('http://localhost:3099/consultaSintoma',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de consulta-sintoma realizado con exito')
        } catch (error) {
            console.log('Error en el post de consulta-sintoma')
        }
    }

    for (let i = 0; i < consultaDiagnostico; i++) {
        let temp = ConsultaDiagnostico()
        try {
            await axios.post('http://localhost:3099/consultaDiagnostico',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de consulta-diagnostico realizado con exito')
        } catch (error) {
            console.log('Error en el post de consulta-diagnostico')
        }
    }

    for (let i = 0; i < consultaTratamiento; i++) {
        let temp = ConsultaTratamiento()
        try {
            await axios.post('http://localhost:3099/consultaTratamiento',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de consulta-tratamiento realizado con exito')
        } catch (error) {
            console.log('Error en el post de consulta-tratamiento')
        }
    }

    for (let i = 0; i < examenConsulta; i++) {
        let temp = ExamenConsulta()
        try {
            await axios.post('http://localhost:3099/examenConsulta',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de examen-consulta realizado con exito')
        } catch (error) {
            console.log('Error en el post de examen-consulta')
        }
    }

    for (let i = 0; i < personaContacto; i++) {
        let temp = PersonaContacto()
        try {
            await axios.post('http://localhost:3099/personaContacto',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de persona-contacto realizado con exito')
        } catch (error) {
            console.log('Error en el post de persona-contacto')
        }
    }

    for (let i = 0; i < receta; i++) {
        let temp = Receta()
        try {
            await axios.post('http://localhost:3099/receta',
                temp,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
            console.log('Post de receta medica realizado con exito')
        } catch (error) {
            console.log('Error en el post de receta medica')
        }
    }

    res.json(persona)
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

app.post('/consultaDiagnostico', async (req, res) => {
    const consultaDiagnostico = await ConsultaDiagnostico();
    const query = 'INSERT INTO consulta_diagnostico(idconsulta, iddiagnostico) VALUES ($1,$2)'
    const result = await client.query(query, [consultaDiagnostico.idconsulta, consultaDiagnostico.iddiagnostico])
    res.json(result.rows)
})

app.post('/consultaSintoma', async (req, res) => {
    const consultaSintoma = await ConsultaSintoma();
    const query = 'INSERT INTO consulta_sintoma(idconsulta, idsintoma) VALUES ($1,$2)'
    const result = await client.query(query, [consultaSintoma.idconsulta, consultaSintoma.idsintoma])
    res.json(result.rows)
})

app.post('/consultaTratamiento', async (req, res) => {
    const consultaTratamiento = await ConsultaTratamiento();
    const query = 'INSERT INTO consulta_tratamiento(idconsulta, idtratamiento) VALUES ($1, $2)'
    const result = await client.query(query, [consultaTratamiento.idconsulta, consultaTratamiento.idtratamiento])
    res.json(result.rows)
})

app.post('/examenConsulta', async (req, res) => {
    const examenConsulta = await ExamenConsulta()
    const query = 'INSERT INTO examenconsulta(idconsulta, idexamen) VALUES ($1,$2)'
    const result = await client.query(query, [examenConsulta.idconsulta, examenConsulta.idexamen])
    res.json(result.rows)
})

app.post('/medico', async (req, res) => {
    const medico = await Medico()
    const query = 'INSERT INTO medico(idespecialidad, nombre, apellido, rut) VALUES ($1, $2, $3, $4)'
    const result = await client.query(query, [medico.idespecialidad, medico.nombre, medico.apellido, medico.rut])
    res.json(result.rows)
})

app.post('/personaContacto', async (req, res) => {
    const personaContacto = await PersonaContacto()
    const query = 'INSERT INTO persona_contacto(idpersona, idcontacto) VALUES ($1, $2)'
    const result = await client.query(query, [personaContacto.idpersona, personaContacto.idcontacto])
    res.json(result.rows)
})

app.post('/receta', async (req, res) => {
    const receta = await Receta()
    const query = 'INSERT INTO receta(idmedicamento, idconsulta) VALUES ($1, $2)'
    const result = await client.query(query, [receta.idmedicamento, receta.idconsulta])
    res.json(result.rows)
})

app.listen(port, () => {
    console.log(`simulador de datos abierto en el puerto ${port}`)
})