CREATE TABLE alergia (
    idAlergia SERIAL PRIMARY KEY,
    alergia VARCHAR(255) NOT NULL
);

CREATE TABLE persona (
    idPersona SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rut VARCHAR(20) NOT NULL UNIQUE,
    fechaNacimiento DATE
);

CREATE TABLE alergia_persona (
    idPersona INT NOT NULL,
    idAlergia INT NOT NULL,
    PRIMARY KEY (idPersona, idAlergia),
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE,
    FOREIGN KEY (idAlergia) REFERENCES alergia(idAlergia) ON DELETE CASCADE
);

CREATE TABLE contacto_emergencia (
    idContacto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    rut VARCHAR(20),
    fechaNacimiento DATE
);

CREATE TABLE persona_contacto (
    idPersona INT NOT NULL,
    idContacto INT NOT NULL,
    PRIMARY KEY (idPersona, idContacto),
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE,
    FOREIGN KEY (idContacto) REFERENCES contacto_emergencia(idContacto) ON DELETE CASCADE
);

CREATE TABLE especialidad (
    idEspecialidad SERIAL PRIMARY KEY,
    especialidad VARCHAR(100) NOT NULL
);

CREATE TABLE medico (
    idMedico SERIAL PRIMARY KEY,
    idEspecialidad INT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rut VARCHAR(20) NOT NULL UNIQUE,
    fechaNacimiento DATE,
    FOREIGN KEY (idEspecialidad) REFERENCES especialidad(idEspecialidad)
);



CREATE TABLE consulta (
    idConsulta SERIAL PRIMARY KEY,
    idPersona INT NOT NULL,
    idMedico INT NOT NULL,
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE,
    FOREIGN KEY (idMedico) REFERENCES medico(idMedico)
);

CREATE TABLE sintoma (
    idSintoma SERIAL PRIMARY KEY,
    sintoma VARCHAR(255) NOT NULL
);

CREATE TABLE consulta_sintoma (
    idConsulta INT NOT NULL,
    idSintoma INT NOT NULL,
    PRIMARY KEY (idConsulta, idSintoma),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idSintoma) REFERENCES sintoma(idSintoma)
);

CREATE TABLE medicamento (
    idMedicamento SERIAL PRIMARY KEY,
    medicamento VARCHAR(255) NOT NULL
);

CREATE TABLE consulta_medicamento (
    idConsulta INT NOT NULL,
    idMedicamento INT NOT NULL,
    PRIMARY KEY (idConsulta, idMedicamento),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idMedicamento) REFERENCES medicamento(idMedicamento)
);

CREATE TABLE tipo_diagnostico (
    idTipoDiagnostico SERIAL PRIMARY KEY,
    tipoDiagnostico VARCHAR(100) NOT NULL
);

CREATE TABLE diagnostico (
    idDiagnostico SERIAL PRIMARY KEY,
    idTipoDiagnostico INT,
    diagnostico TEXT NOT NULL,
    FOREIGN KEY (idTipoDiagnostico) REFERENCES tipo_diagnostico(idTipoDiagnostico)
);

CREATE TABLE consulta_diagnostico (
    idConsulta INT NOT NULL,
    idDiagnostico INT NOT NULL,
    PRIMARY KEY (idConsulta, idDiagnostico),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idDiagnostico) REFERENCES diagnostico(idDiagnostico)
);

CREATE TABLE tipo_tratamiento (
    idTipoTratamiento SERIAL PRIMARY KEY,
    tipoTratamiento VARCHAR(100) NOT NULL
);

CREATE TABLE tratamiento (
    idTratamiento SERIAL PRIMARY KEY,
    idTipoTratamiento INT,
    tratamiento TEXT NOT NULL,
    FOREIGN KEY (idTipoTratamiento) REFERENCES tipo_tratamiento(idTipoTratamiento)
);

CREATE TABLE consulta_tratamiento (
    idConsulta INT NOT NULL,
    idTratamiento INT NOT NULL,
    PRIMARY KEY (idConsulta, idTratamiento),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idTratamiento) REFERENCES tratamiento(idTratamiento)
);

CREATE TABLE examen (
    idExamen SERIAL PRIMARY KEY,
    idPersona INT NOT NULL,
    fecha DATE NOT NULL,
    archivo VARCHAR(255), -- nombre o URL del archivo
    datosExtraidos TEXT,
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE
);
