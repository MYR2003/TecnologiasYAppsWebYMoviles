-- Esquema MySQL para sistema de fichas médicas
-- Basado en el modelo final acordado

DROP TABLE IF EXISTS consulta_tratamiento;
DROP TABLE IF EXISTS tratamiento;
DROP TABLE IF EXISTS tipo_tratamiento;
DROP TABLE IF EXISTS consulta_diagnostico;
DROP TABLE IF EXISTS diagnostico;
DROP TABLE IF EXISTS tipo_diagnostico;
DROP TABLE IF EXISTS consulta_medicamento;
DROP TABLE IF EXISTS medicamento;
DROP TABLE IF EXISTS consulta_sintoma;
DROP TABLE IF EXISTS sintoma;
DROP TABLE IF EXISTS consulta;
DROP TABLE IF EXISTS ficha_medica;
DROP TABLE IF EXISTS medico;
DROP TABLE IF EXISTS especialidad;
DROP TABLE IF EXISTS persona_contacto;
DROP TABLE IF EXISTS contacto_emergencia;
DROP TABLE IF EXISTS alergias_persona;
DROP TABLE IF EXISTS persona;
DROP TABLE IF EXISTS alergias;

CREATE TABLE alergias (
    idAlergia INT AUTO_INCREMENT PRIMARY KEY,
    alergia VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE persona (
    idPersona INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rut VARCHAR(20) NOT NULL UNIQUE,
    fechaNacimiento DATE,
    sistemaDeSalud VARCHAR(50),
    domicilio VARCHAR(255),
    numero VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE alergias_persona (
    idPersona INT NOT NULL,
    idAlergia INT NOT NULL,
    nota TEXT,
    PRIMARY KEY (idPersona, idAlergia),
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE,
    FOREIGN KEY (idAlergia) REFERENCES alergias(idAlergia) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE contacto_emergencia (
    idContacto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    rut VARCHAR(20),
    fechaNacimiento DATE,
    telefono VARCHAR(50),
    direccion VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE persona_contacto (
    idPersona INT NOT NULL,
    idContacto INT NOT NULL,
    relacion VARCHAR(50),
    esPrincipal BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (idPersona, idContacto),
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE,
    FOREIGN KEY (idContacto) REFERENCES contacto_emergencia(idContacto) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE especialidad (
    idEspecialidad INT AUTO_INCREMENT PRIMARY KEY,
    especialidad VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE medico (
    idMedico INT AUTO_INCREMENT PRIMARY KEY,
    idEspecialidad INT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rut VARCHAR(20) NOT NULL UNIQUE,
    fechaNacimiento DATE,
    telefono VARCHAR(50),
    email VARCHAR(100),
    FOREIGN KEY (idEspecialidad) REFERENCES especialidad(idEspecialidad)
) ENGINE=InnoDB;

CREATE TABLE ficha_medica (
    idFicha INT AUTO_INCREMENT PRIMARY KEY,
    idPersona INT NOT NULL,
    idMedico INT NOT NULL,
    fecha DATETIME NOT NULL,
    altura DECIMAL(5,2),
    peso DECIMAL(6,2),
    presion VARCHAR(50),
    observaciones TEXT,
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE,
    FOREIGN KEY (idMedico) REFERENCES medico(idMedico)
) ENGINE=InnoDB;

CREATE TABLE consulta (
    idConsulta INT AUTO_INCREMENT PRIMARY KEY,
    idPersona INT NOT NULL,
    idMedico INT NOT NULL,
    fecha DATETIME NOT NULL,
    motivo TEXT,
    duracionMinutos INT,
    observaciones TEXT,
    FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE,
    FOREIGN KEY (idMedico) REFERENCES medico(idMedico)
) ENGINE=InnoDB;

CREATE TABLE sintoma (
    idSintoma INT AUTO_INCREMENT PRIMARY KEY,
    sintoma VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE consulta_sintoma (
    idConsulta INT NOT NULL,
    idSintoma INT NOT NULL,
    severidad INT,
    nota TEXT,
    PRIMARY KEY (idConsulta, idSintoma),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idSintoma) REFERENCES sintoma(idSintoma)
) ENGINE=InnoDB;

CREATE TABLE medicamento (
    idMedicamento INT AUTO_INCREMENT PRIMARY KEY,
    medicamento VARCHAR(255) NOT NULL,
    presentacion VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE consulta_medicamento (
    idConsulta INT NOT NULL,
    idMedicamento INT NOT NULL,
    dosis VARCHAR(100),
    frecuencia VARCHAR(100),
    duracion VARCHAR(100),
    indicaciones TEXT,
    PRIMARY KEY (idConsulta, idMedicamento),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idMedicamento) REFERENCES medicamento(idMedicamento)
) ENGINE=InnoDB;

CREATE TABLE tipo_diagnostico (
    idTipoDiagnostico INT AUTO_INCREMENT PRIMARY KEY,
    tipoDiagnostico VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE diagnostico (
    idDiagnostico INT AUTO_INCREMENT PRIMARY KEY,
    idTipoDiagnostico INT,
    diagnostico TEXT NOT NULL,
    codigoCIE VARCHAR(50),
    FOREIGN KEY (idTipoDiagnostico) REFERENCES tipo_diagnostico(idTipoDiagnostico)
) ENGINE=InnoDB;

CREATE TABLE consulta_diagnostico (
    idConsulta INT NOT NULL,
    idDiagnostico INT NOT NULL,
    esPrincipal BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (idConsulta, idDiagnostico),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idDiagnostico) REFERENCES diagnostico(idDiagnostico)
) ENGINE=InnoDB;

CREATE TABLE tipo_tratamiento (
    idTipoTratamiento INT AUTO_INCREMENT PRIMARY KEY,
    tipoTratamiento VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tratamiento (
    idTratamiento INT AUTO_INCREMENT PRIMARY KEY,
    idTipoTratamiento INT,
    tratamiento TEXT NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (idTipoTratamiento) REFERENCES tipo_tratamiento(idTipoTratamiento)
) ENGINE=InnoDB;

CREATE TABLE consulta_tratamiento (
    idConsulta INT NOT NULL,
    idTratamiento INT NOT NULL,
    instrucciones TEXT,
    fechaInicio DATE,
    fechaFin DATE,
    PRIMARY KEY (idConsulta, idTratamiento),
    FOREIGN KEY (idConsulta) REFERENCES consulta(idConsulta) ON DELETE CASCADE,
    FOREIGN KEY (idTratamiento) REFERENCES tratamiento(idTratamiento)
) ENGINE=InnoDB;
