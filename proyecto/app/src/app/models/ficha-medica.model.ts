export interface FichaMedica {
  idFicha: number;
  idPersona: number;
  idMedico: number;
  fecha: string;
  altura?: number;
  peso?: number;
  presion?: string;
  observaciones?: string;
}
