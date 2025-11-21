
CREATE TABLE alergia (
    idalergia integer NOT NULL,
    alergia character varying(255) NOT NULL
);


ALTER TABLE alergia OWNER TO myr;

--
-- Name: alergia_idalergia_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE alergia_idalergia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE alergia_idalergia_seq OWNER TO myr;

--
-- Name: alergia_idalergia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE alergia_idalergia_seq OWNED BY alergia.idalergia;


--
-- Name: alergia_persona; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE alergia_persona (
    idpersona integer NOT NULL,
    idalergia integer NOT NULL,
    nota text
);


ALTER TABLE alergia_persona OWNER TO myr;

--
-- Name: consulta; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE consulta (
    idconsulta integer NOT NULL,
    idpersona integer NOT NULL,
    idmedico integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    motivo text,
    duracionminutos integer,
    observaciones text,
    idfichamedica integer
);


ALTER TABLE consulta OWNER TO myr;

--
-- Name: consulta_diagnostico; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE consulta_diagnostico (
    idconsulta integer NOT NULL,
    iddiagnostico integer NOT NULL,
    esprincipal boolean DEFAULT false
);


ALTER TABLE consulta_diagnostico OWNER TO myr;

--
-- Name: consulta_idconsulta_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE consulta_idconsulta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE consulta_idconsulta_seq OWNER TO myr;

--
-- Name: consulta_idconsulta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE consulta_idconsulta_seq OWNED BY consulta.idconsulta;


--
-- Name: consulta_sintoma; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE consulta_sintoma (
    idconsulta integer NOT NULL,
    idsintoma integer NOT NULL,
    severidad integer,
    nota text
);


ALTER TABLE consulta_sintoma OWNER TO myr;

--
-- Name: consulta_tratamiento; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE consulta_tratamiento (
    idconsulta integer NOT NULL,
    idtratamiento integer NOT NULL,
    instrucciones text,
    fechainicio date,
    fechafin date
);


ALTER TABLE consulta_tratamiento OWNER TO myr;

--
-- Name: contacto_emergencia; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE contacto_emergencia (
    idcontacto integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100),
    rut character varying(20),
    fechanacimiento date,
    telefono character varying(50),
    direccion character varying(255)
);


ALTER TABLE contacto_emergencia OWNER TO myr;

--
-- Name: contacto_emergencia_idcontacto_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE contacto_emergencia_idcontacto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE contacto_emergencia_idcontacto_seq OWNER TO myr;

--
-- Name: contacto_emergencia_idcontacto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE contacto_emergencia_idcontacto_seq OWNED BY contacto_emergencia.idcontacto;


--
-- Name: diagnostico; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE diagnostico (
    iddiagnostico integer NOT NULL,
    idtipodiagnostico integer,
    diagnostico text NOT NULL
);


ALTER TABLE diagnostico OWNER TO myr;

--
-- Name: diagnostico_iddiagnostico_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE diagnostico_iddiagnostico_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE diagnostico_iddiagnostico_seq OWNER TO myr;

--
-- Name: diagnostico_iddiagnostico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE diagnostico_iddiagnostico_seq OWNED BY diagnostico.iddiagnostico;


--
-- Name: especialidad; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE especialidad (
    idespecialidad integer NOT NULL,
    especialidad character varying(100) NOT NULL
);


ALTER TABLE especialidad OWNER TO myr;

--
-- Name: especialidad_idespecialidad_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE especialidad_idespecialidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE especialidad_idespecialidad_seq OWNER TO myr;

--
-- Name: especialidad_idespecialidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE especialidad_idespecialidad_seq OWNED BY especialidad.idespecialidad;


--
-- Name: examen; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE examen (
    idexamen integer NOT NULL,
    examen character varying(255)
);


ALTER TABLE examen OWNER TO myr;

--
-- Name: examen_idexamen_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE examen_idexamen_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE examen_idexamen_seq OWNER TO myr;

--
-- Name: examen_idexamen_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE examen_idexamen_seq OWNED BY examen.idexamen;


--
-- Name: examenconsulta; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE examenconsulta (
    idexamen integer NOT NULL,
    idconsulta integer NOT NULL,
    resultadosexamen character varying(255)
);


ALTER TABLE examenconsulta OWNER TO myr;

--
-- Name: fichamedica; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE fichamedica (
    idfichamedica integer NOT NULL,
    altura double precision,
    peso double precision,
    presion double precision
);


ALTER TABLE fichamedica OWNER TO myr;

--
-- Name: fichamedica_idfichamedica_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE fichamedica_idfichamedica_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE fichamedica_idfichamedica_seq OWNER TO myr;

--
-- Name: fichamedica_idfichamedica_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE fichamedica_idfichamedica_seq OWNED BY fichamedica.idfichamedica;


--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE medicamento (
    idmedicamento integer NOT NULL,
    medicamento character varying(50)
);


ALTER TABLE medicamento OWNER TO myr;

--
-- Name: medicamento_idmedicamento_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE medicamento_idmedicamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE medicamento_idmedicamento_seq OWNER TO myr;

--
-- Name: medicamento_idmedicamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE medicamento_idmedicamento_seq OWNED BY medicamento.idmedicamento;


--
-- Name: medicamentoreceta; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE medicamentoreceta (
    idmedicamento integer NOT NULL,
    idreceta integer NOT NULL,
    cantidad double precision,
    medida character varying(50),
    instrucciones text
);


ALTER TABLE medicamentoreceta OWNER TO myr;

--
-- Name: medico; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE medico (
    idmedico integer NOT NULL,
    idespecialidad integer,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    rut character varying(20) NOT NULL,
    fechanacimiento date,
    telefono character varying(50),
    email character varying(100)
);


ALTER TABLE medico OWNER TO myr;

--
-- Name: medico_idmedico_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE medico_idmedico_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE medico_idmedico_seq OWNER TO myr;

--
-- Name: medico_idmedico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE medico_idmedico_seq OWNED BY medico.idmedico;


--
-- Name: persona; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE persona (
    idpersona integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    rut character varying(20) NOT NULL,
    fechanacimiento date,
    sistemadesalud character varying(50),
    domicilio character varying(255),
    telefono character varying(50)
);


ALTER TABLE persona OWNER TO myr;

--
-- Name: persona_contacto; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE persona_contacto (
    idpersona integer NOT NULL,
    idcontacto integer NOT NULL,
    relacion character varying(50),
    esprincipal boolean DEFAULT false
);


ALTER TABLE persona_contacto OWNER TO myr;

--
-- Name: persona_idpersona_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE persona_idpersona_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE persona_idpersona_seq OWNER TO myr;

--
-- Name: persona_idpersona_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE persona_idpersona_seq OWNED BY persona.idpersona;


--
-- Name: receta; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE receta (
    idreceta integer NOT NULL
);


ALTER TABLE receta OWNER TO myr;

--
-- Name: receta_idreceta_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE receta_idreceta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE receta_idreceta_seq OWNER TO myr;

--
-- Name: receta_idreceta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE receta_idreceta_seq OWNED BY receta.idreceta;


--
-- Name: recetaconsulta; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE recetaconsulta (
    idreceta integer NOT NULL,
    idconsulta integer NOT NULL
);


ALTER TABLE recetaconsulta OWNER TO myr;

--
-- Name: sintoma; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE sintoma (
    idsintoma integer NOT NULL,
    sintoma character varying(255) NOT NULL
);


ALTER TABLE sintoma OWNER TO myr;

--
-- Name: sintoma_idsintoma_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE sintoma_idsintoma_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sintoma_idsintoma_seq OWNER TO myr;

--
-- Name: sintoma_idsintoma_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE sintoma_idsintoma_seq OWNED BY sintoma.idsintoma;


--
-- Name: tipo_diagnostico; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE tipo_diagnostico (
    idtipodiagnostico integer NOT NULL,
    tipodiagnostico character varying(100) NOT NULL
);


ALTER TABLE tipo_diagnostico OWNER TO myr;

--
-- Name: tipo_diagnostico_idtipodiagnostico_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE tipo_diagnostico_idtipodiagnostico_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tipo_diagnostico_idtipodiagnostico_seq OWNER TO myr;

--
-- Name: tipo_diagnostico_idtipodiagnostico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE tipo_diagnostico_idtipodiagnostico_seq OWNED BY tipo_diagnostico.idtipodiagnostico;


--
-- Name: tipo_tratamiento; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE tipo_tratamiento (
    idtipotratamiento integer NOT NULL,
    tipotratamiento character varying(100) NOT NULL
);


ALTER TABLE tipo_tratamiento OWNER TO myr;

--
-- Name: tipo_tratamiento_idtipotratamiento_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE tipo_tratamiento_idtipotratamiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tipo_tratamiento_idtipotratamiento_seq OWNER TO myr;

--
-- Name: tipo_tratamiento_idtipotratamiento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE tipo_tratamiento_idtipotratamiento_seq OWNED BY tipo_tratamiento.idtipotratamiento;


--
-- Name: tipoexamen; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE tipoexamen (
    idtipoexamen integer NOT NULL,
    tipoexamen character varying(100)
);


ALTER TABLE tipoexamen OWNER TO myr;

--
-- Name: tipoexamen_idtipoexamen_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE tipoexamen_idtipoexamen_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tipoexamen_idtipoexamen_seq OWNER TO myr;

--
-- Name: tipoexamen_idtipoexamen_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE tipoexamen_idtipoexamen_seq OWNED BY tipoexamen.idtipoexamen;


--
-- Name: tratamiento; Type: TABLE; Schema: public; Owner: myr
--

CREATE TABLE tratamiento (
    idtratamiento integer NOT NULL,
    idtipotratamiento integer,
    tratamiento text NOT NULL,
    descripcion text
);


ALTER TABLE tratamiento OWNER TO myr;

--
-- Name: tratamiento_idtratamiento_seq; Type: SEQUENCE; Schema: public; Owner: myr
--

CREATE SEQUENCE tratamiento_idtratamiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tratamiento_idtratamiento_seq OWNER TO myr;

--
-- Name: tratamiento_idtratamiento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myr
--

ALTER SEQUENCE tratamiento_idtratamiento_seq OWNED BY tratamiento.idtratamiento;


--
-- Name: alergia idalergia; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY alergia ALTER COLUMN idalergia SET DEFAULT nextval('alergia_idalergia_seq'::regclass);


--
-- Name: consulta idconsulta; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta ALTER COLUMN idconsulta SET DEFAULT nextval('consulta_idconsulta_seq'::regclass);


--
-- Name: contacto_emergencia idcontacto; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY contacto_emergencia ALTER COLUMN idcontacto SET DEFAULT nextval('contacto_emergencia_idcontacto_seq'::regclass);


--
-- Name: diagnostico iddiagnostico; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY diagnostico ALTER COLUMN iddiagnostico SET DEFAULT nextval('diagnostico_iddiagnostico_seq'::regclass);


--
-- Name: especialidad idespecialidad; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY especialidad ALTER COLUMN idespecialidad SET DEFAULT nextval('especialidad_idespecialidad_seq'::regclass);


--
-- Name: examen idexamen; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY examen ALTER COLUMN idexamen SET DEFAULT nextval('examen_idexamen_seq'::regclass);


--
-- Name: fichamedica idfichamedica; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY fichamedica ALTER COLUMN idfichamedica SET DEFAULT nextval('fichamedica_idfichamedica_seq'::regclass);


--
-- Name: medicamento idmedicamento; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medicamento ALTER COLUMN idmedicamento SET DEFAULT nextval('medicamento_idmedicamento_seq'::regclass);


--
-- Name: medico idmedico; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medico ALTER COLUMN idmedico SET DEFAULT nextval('medico_idmedico_seq'::regclass);


--
-- Name: persona idpersona; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY persona ALTER COLUMN idpersona SET DEFAULT nextval('persona_idpersona_seq'::regclass);


--
-- Name: receta idreceta; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY receta ALTER COLUMN idreceta SET DEFAULT nextval('receta_idreceta_seq'::regclass);


--
-- Name: sintoma idsintoma; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY sintoma ALTER COLUMN idsintoma SET DEFAULT nextval('sintoma_idsintoma_seq'::regclass);


--
-- Name: tipo_diagnostico idtipodiagnostico; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tipo_diagnostico ALTER COLUMN idtipodiagnostico SET DEFAULT nextval('tipo_diagnostico_idtipodiagnostico_seq'::regclass);


--
-- Name: tipo_tratamiento idtipotratamiento; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tipo_tratamiento ALTER COLUMN idtipotratamiento SET DEFAULT nextval('tipo_tratamiento_idtipotratamiento_seq'::regclass);


--
-- Name: tipoexamen idtipoexamen; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tipoexamen ALTER COLUMN idtipoexamen SET DEFAULT nextval('tipoexamen_idtipoexamen_seq'::regclass);


--
-- Name: tratamiento idtratamiento; Type: DEFAULT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tratamiento ALTER COLUMN idtratamiento SET DEFAULT nextval('tratamiento_idtratamiento_seq'::regclass);


--
-- Name: alergia_persona alergia_persona_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY alergia_persona
    ADD CONSTRAINT alergia_persona_pkey PRIMARY KEY (idpersona, idalergia);


--
-- Name: alergia alergia_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY alergia
    ADD CONSTRAINT alergia_pkey PRIMARY KEY (idalergia);


--
-- Name: consulta_diagnostico consulta_diagnostico_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_diagnostico
    ADD CONSTRAINT consulta_diagnostico_pkey PRIMARY KEY (idconsulta, iddiagnostico);


--
-- Name: consulta consulta_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta
    ADD CONSTRAINT consulta_pkey PRIMARY KEY (idconsulta);


--
-- Name: consulta_sintoma consulta_sintoma_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_sintoma
    ADD CONSTRAINT consulta_sintoma_pkey PRIMARY KEY (idconsulta, idsintoma);


--
-- Name: consulta_tratamiento consulta_tratamiento_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_tratamiento
    ADD CONSTRAINT consulta_tratamiento_pkey PRIMARY KEY (idconsulta, idtratamiento);


--
-- Name: contacto_emergencia contacto_emergencia_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY contacto_emergencia
    ADD CONSTRAINT contacto_emergencia_pkey PRIMARY KEY (idcontacto);


--
-- Name: diagnostico diagnostico_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY diagnostico
    ADD CONSTRAINT diagnostico_pkey PRIMARY KEY (iddiagnostico);


--
-- Name: especialidad especialidad_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY especialidad
    ADD CONSTRAINT especialidad_pkey PRIMARY KEY (idespecialidad);


--
-- Name: examen examen_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY examen
    ADD CONSTRAINT examen_pkey PRIMARY KEY (idexamen);


--
-- Name: examenconsulta examenconsulta_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY examenconsulta
    ADD CONSTRAINT examenconsulta_pkey PRIMARY KEY (idexamen, idconsulta);


--
-- Name: fichamedica fichamedica_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY fichamedica
    ADD CONSTRAINT fichamedica_pkey PRIMARY KEY (idfichamedica);


--
-- Name: medicamento medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (idmedicamento);


--
-- Name: medicamentoreceta medicamentoreceta_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medicamentoreceta
    ADD CONSTRAINT medicamentoreceta_pkey PRIMARY KEY (idmedicamento, idreceta);


--
-- Name: medico medico_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medico
    ADD CONSTRAINT medico_pkey PRIMARY KEY (idmedico);


--
-- Name: medico medico_rut_key; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medico
    ADD CONSTRAINT medico_rut_key UNIQUE (rut);


--
-- Name: persona_contacto persona_contacto_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY persona_contacto
    ADD CONSTRAINT persona_contacto_pkey PRIMARY KEY (idpersona, idcontacto);


--
-- Name: persona persona_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (idpersona);


--
-- Name: persona persona_rut_key; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT persona_rut_key UNIQUE (rut);


--
-- Name: receta receta_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY receta
    ADD CONSTRAINT receta_pkey PRIMARY KEY (idreceta);


--
-- Name: recetaconsulta recetaconsulta_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY recetaconsulta
    ADD CONSTRAINT recetaconsulta_pkey PRIMARY KEY (idreceta, idconsulta);


--
-- Name: sintoma sintoma_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY sintoma
    ADD CONSTRAINT sintoma_pkey PRIMARY KEY (idsintoma);


--
-- Name: tipo_diagnostico tipo_diagnostico_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tipo_diagnostico
    ADD CONSTRAINT tipo_diagnostico_pkey PRIMARY KEY (idtipodiagnostico);


--
-- Name: tipo_tratamiento tipo_tratamiento_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tipo_tratamiento
    ADD CONSTRAINT tipo_tratamiento_pkey PRIMARY KEY (idtipotratamiento);


--
-- Name: tipoexamen tipoexamen_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tipoexamen
    ADD CONSTRAINT tipoexamen_pkey PRIMARY KEY (idtipoexamen);


--
-- Name: tratamiento tratamiento_pkey; Type: CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tratamiento
    ADD CONSTRAINT tratamiento_pkey PRIMARY KEY (idtratamiento);


--
-- Name: alergia_persona alergia_persona_idalergia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY alergia_persona
    ADD CONSTRAINT alergia_persona_idalergia_fkey FOREIGN KEY (idalergia) REFERENCES alergia(idalergia) ON DELETE CASCADE;


--
-- Name: alergia_persona alergia_persona_idpersona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY alergia_persona
    ADD CONSTRAINT alergia_persona_idpersona_fkey FOREIGN KEY (idpersona) REFERENCES persona(idpersona) ON DELETE CASCADE;


--
-- Name: consulta_diagnostico consulta_diagnostico_idconsulta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_diagnostico
    ADD CONSTRAINT consulta_diagnostico_idconsulta_fkey FOREIGN KEY (idconsulta) REFERENCES consulta(idconsulta) ON DELETE CASCADE;


--
-- Name: consulta_diagnostico consulta_diagnostico_iddiagnostico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_diagnostico
    ADD CONSTRAINT consulta_diagnostico_iddiagnostico_fkey FOREIGN KEY (iddiagnostico) REFERENCES diagnostico(iddiagnostico);


--
-- Name: consulta consulta_idmedico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta
    ADD CONSTRAINT consulta_idmedico_fkey FOREIGN KEY (idmedico) REFERENCES medico(idmedico);


--
-- Name: consulta consulta_idpersona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta
    ADD CONSTRAINT consulta_idpersona_fkey FOREIGN KEY (idpersona) REFERENCES persona(idpersona) ON DELETE CASCADE;


--
-- Name: consulta_sintoma consulta_sintoma_idconsulta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_sintoma
    ADD CONSTRAINT consulta_sintoma_idconsulta_fkey FOREIGN KEY (idconsulta) REFERENCES consulta(idconsulta) ON DELETE CASCADE;


--
-- Name: consulta_sintoma consulta_sintoma_idsintoma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_sintoma
    ADD CONSTRAINT consulta_sintoma_idsintoma_fkey FOREIGN KEY (idsintoma) REFERENCES sintoma(idsintoma);


--
-- Name: consulta_tratamiento consulta_tratamiento_idconsulta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_tratamiento
    ADD CONSTRAINT consulta_tratamiento_idconsulta_fkey FOREIGN KEY (idconsulta) REFERENCES consulta(idconsulta) ON DELETE CASCADE;


--
-- Name: consulta_tratamiento consulta_tratamiento_idtratamiento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta_tratamiento
    ADD CONSTRAINT consulta_tratamiento_idtratamiento_fkey FOREIGN KEY (idtratamiento) REFERENCES tratamiento(idtratamiento);


--
-- Name: diagnostico diagnostico_idtipodiagnostico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY diagnostico
    ADD CONSTRAINT diagnostico_idtipodiagnostico_fkey FOREIGN KEY (idtipodiagnostico) REFERENCES tipo_diagnostico(idtipodiagnostico);


--
-- Name: examenconsulta fk_consulta; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY examenconsulta
    ADD CONSTRAINT fk_consulta FOREIGN KEY (idconsulta) REFERENCES consulta(idconsulta);


--
-- Name: recetaconsulta fk_consulta; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY recetaconsulta
    ADD CONSTRAINT fk_consulta FOREIGN KEY (idconsulta) REFERENCES consulta(idconsulta);


--
-- Name: examenconsulta fk_examen; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY examenconsulta
    ADD CONSTRAINT fk_examen FOREIGN KEY (idexamen) REFERENCES examen(idexamen);


--
-- Name: consulta fk_fichamedica; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY consulta
    ADD CONSTRAINT fk_fichamedica FOREIGN KEY (idfichamedica) REFERENCES fichamedica(idfichamedica) ON DELETE CASCADE;


--
-- Name: medicamentoreceta fk_medicamento; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medicamentoreceta
    ADD CONSTRAINT fk_medicamento FOREIGN KEY (idmedicamento) REFERENCES medicamento(idmedicamento);


--
-- Name: medicamentoreceta fk_receta; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medicamentoreceta
    ADD CONSTRAINT fk_receta FOREIGN KEY (idreceta) REFERENCES receta(idreceta);


--
-- Name: recetaconsulta fk_receta; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY recetaconsulta
    ADD CONSTRAINT fk_receta FOREIGN KEY (idreceta) REFERENCES receta(idreceta);


-- Name: medico medico_idespecialidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY medico
    ADD CONSTRAINT medico_idespecialidad_fkey FOREIGN KEY (idespecialidad) REFERENCES especialidad(idespecialidad);


--
-- Name: persona_contacto persona_contacto_idcontacto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY persona_contacto
    ADD CONSTRAINT persona_contacto_idcontacto_fkey FOREIGN KEY (idcontacto) REFERENCES contacto_emergencia(idcontacto) ON DELETE CASCADE;


--
-- Name: persona_contacto persona_contacto_idpersona_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY persona_contacto
    ADD CONSTRAINT persona_contacto_idpersona_fkey FOREIGN KEY (idpersona) REFERENCES persona(idpersona) ON DELETE CASCADE;


--
-- Name: tratamiento tratamiento_idtipotratamiento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myr
--

ALTER TABLE ONLY tratamiento
    ADD CONSTRAINT tratamiento_idtipotratamiento_fkey FOREIGN KEY (idtipotratamiento) REFERENCES tipo_tratamiento(idtipotratamiento);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO myr;


--
-- PostgreSQL database dump complete
--

\unrestrict 1vFpUrN69X5L9amZVmXAwQSTEAd8bJjFifiIuh5J1VifEZocMdkiW5Ivw2ZHhpG

