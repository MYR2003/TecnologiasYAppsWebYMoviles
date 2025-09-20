-- Seeds de ejemplo para PostgreSQL
-- Inserciones en el orden que respeta FK

-- Alergia
INSERT INTO alergia (alergia) VALUES
('Penicilina'),
('Polen'),
('Mariscos');

-- Personas
INSERT INTO persona (nombre, apellido, rut, fechaNacimiento, sistemaDeSalud, domicilio, numero) VALUES
('Juan', 'Pérez', '12.345.678-9', '1980-04-12', 'Fonasa', 'Av. Siempre Viva 123', '+56912345678'),
('María', 'González', '11.222.333-4', '1990-09-30', 'Isapre', 'Calle Falsa 456', '+56987654321');

-- AlergiaPersona
INSERT INTO alergia_persona (idPersona, idAlergia, nota) VALUES
(1, 1, 'Anafilaxia leve'),
(2, 2, 'Rinitis estacional');

-- Contactos de emergencia
INSERT INTO contacto_emergencia (nombre, apellido, rut, fechaNacimiento, telefono, direccion) VALUES
('Ana', 'Pérez', '21.111.222-3', '1960-01-05', '+56911223344', 'Av. Siempre Viva 124'),
('Carlos', 'González', NULL, '1965-06-20', '+56999887766', 'Calle Falsa 457');

-- PersonaContacto
INSERT INTO persona_contacto (idPersona, idContacto, relacion, esPrincipal) VALUES
(1, 1, 'conyuge', TRUE),
(2, 2, 'padre', TRUE);

-- Especialidades
INSERT INTO especialidad (especialidad) VALUES
('Medicina General'),
('Pediatría');

-- Medicos
INSERT INTO medico (idEspecialidad, nombre, apellido, rut, fechaNacimiento, telefono, email) VALUES
(1, 'Dr. Martín', 'Rojas', '10.111.222-3', '1975-03-15', '+56922334455', 'martin.rojas@clinica.cl'),
(2, 'Dra. Laura', 'Soto', '10.222.333-4', '1982-11-22', '+56933445566', 'laura.soto@clinica.cl');

-- Fichas médicas
INSERT INTO ficha_medica (idPersona, idMedico, fecha, altura, peso, presion, observaciones) VALUES
(1, 1, '2024-01-10 09:30:00', 1.75, 78.5, '120/80', 'Paciente en buen estado general'),
(2, 2, '2024-02-05 11:00:00', 1.62, 60.2, '110/70', 'Sin observaciones importantes');

-- Consultas
INSERT INTO consulta (idPersona, idMedico, fecha, motivo, duracionMinutos, observaciones) VALUES
(1, 1, '2024-03-01 08:30:00', 'Control anual', 20, 'Solicita exámenes de rutina'),
(2, 2, '2024-03-15 10:00:00', 'Tos persistente', 30, 'Tratamiento prescrito');

-- Sintomas
INSERT INTO sintoma (sintoma) VALUES
('Tos'),
('Fiebre'),
('Dolor de cabeza');

-- ConsultaSintoma
INSERT INTO consulta_sintoma (idConsulta, idSintoma, severidad, nota) VALUES
(2, 1, 4, 'Productiva'),
(2, 2, 2, 'Intermitente');

-- Medicamentos
INSERT INTO medicamento (medicamento, presentacion) VALUES
('Amoxicilina', '500 mg'),
('Paracetamol', '500 mg');

-- ConsultaMedicamento
INSERT INTO consulta_medicamento (idConsulta, idMedicamento, dosis, frecuencia, duracion, indicaciones) VALUES
(2, 1, '500 mg', 'cada 8 horas', '7 días', 'Tomar con comida'),
(2, 2, '500 mg', 'cada 6-8 horas', 'según síntomas', 'No exceder 4 g/día');

-- Tipos de diagnóstico
INSERT INTO tipo_diagnostico (tipoDiagnostico) VALUES
('Presuntivo'),
('Definitivo');

-- Diagnósticos
INSERT INTO diagnostico (idTipoDiagnostico, diagnostico, codigoCIE) VALUES
(1, 'Infección respiratoria aguda', 'J06.9');

-- ConsultaDiagnostico
INSERT INTO consulta_diagnostico (idConsulta, idDiagnostico, esPrincipal) VALUES
(2, 1, TRUE);

-- Tipos de tratamiento
INSERT INTO tipo_tratamiento (tipoTratamiento) VALUES
('Farmacológico'),
('Terapéutico');

-- Tratamientos
INSERT INTO tratamiento (idTipoTratamiento, tratamiento, descripcion) VALUES
(1, 'Antibiótico oral', 'Amoxicilina 500 mg cada 8 horas por 7 días');

-- ConsultaTratamiento
INSERT INTO consulta_tratamiento (idConsulta, idTratamiento, instrucciones, fechaInicio, fechaFin) VALUES
(2, 1, 'Completar ciclo', '2024-03-15', '2024-03-22');
