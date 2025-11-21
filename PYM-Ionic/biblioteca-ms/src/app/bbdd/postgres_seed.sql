-- Alergia
INSERT INTO alergia (alergia) VALUES
('Penicilina'),
('Polen'),
('Mariscos');

-- Personas
INSERT INTO persona (nombre, apellido, rut, fechaNacimiento) VALUES
('Juan', 'Pérez', '12.345.678-9', '1980-04-12'),
('María', 'González', '11.222.333-4', '1990-09-30');

-- AlergiaPersona
INSERT INTO alergia_persona (idPersona, idAlergia) VALUES
(1, 1),
(2, 2);

-- Contactos de emergencia
INSERT INTO contacto_emergencia (nombre, apellido, rut, fechaNacimiento) VALUES
('Ana', 'Pérez', '21.111.222-3', '1960-01-05'),
('Carlos', 'González', NULL, '1965-06-20');

-- PersonaContacto
INSERT INTO persona_contacto (idPersona, idContacto) VALUES
(1, 1),
(2, 2);

-- Especialidades
INSERT INTO especialidad (especialidad) VALUES
('Medicina General'),
('Pediatría');

-- Medicos
INSERT INTO medico (idEspecialidad, nombre, apellido, rut, fechaNacimiento) VALUES
(1, 'Dr. Martín', 'Rojas', '10.111.222-3', '1975-03-15'),
(2, 'Dra. Laura', 'Soto', '10.222.333-4', '1982-11-22');



-- Consultas
INSERT INTO consulta (idPersona, idMedico) VALUES
(1, 1),
(2, 2);

-- Sintomas
INSERT INTO sintoma (sintoma) VALUES
('Tos'),
('Fiebre'),
('Dolor de cabeza');

-- ConsultaSintoma
INSERT INTO consulta_sintoma (idConsulta, idSintoma) VALUES
(2, 1),
(2, 2);

-- Medicamentos
INSERT INTO medicamento (medicamento) VALUES
('Amoxicilina'),
('Paracetamol');

-- ConsultaMedicamento
INSERT INTO consulta_medicamento (idConsulta, idMedicamento) VALUES
(2, 1),
(2, 2);

-- Tipos de diagnóstico
INSERT INTO tipo_diagnostico (tipoDiagnostico) VALUES
('Presuntivo'),
('Definitivo');

-- Diagnósticos
INSERT INTO diagnostico (idTipoDiagnostico, diagnostico) VALUES
(1, 'Infección respiratoria aguda');

-- ConsultaDiagnostico
INSERT INTO consulta_diagnostico (idConsulta, idDiagnostico) VALUES
(2, 1);

-- Tipos de tratamiento
INSERT INTO tipo_tratamiento (tipoTratamiento) VALUES
('Farmacológico'),
('Terapéutico');

-- Tratamientos
INSERT INTO tratamiento (idTipoTratamiento, tratamiento) VALUES
(1, 'Antibiótico oral');

-- ConsultaTratamiento
INSERT INTO consulta_tratamiento (idConsulta, idTratamiento) VALUES
(2, 1);
