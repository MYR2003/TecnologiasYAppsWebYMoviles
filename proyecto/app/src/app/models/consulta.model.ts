export interface Consulta {
  idConsulta: number;
  idPersona: number;
  idMedico: number;
  fecha: string;
  motivo?: string;
  duracionMinutos?: number;
  observaciones?: string;
}
