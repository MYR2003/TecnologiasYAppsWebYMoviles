export interface Medico {
  idMedico: number;
  idEspecialidad?: number;
  nombre: string;
  apellido: string;
  rut: string;
  fechaNacimiento?: string;
  telefono?: string;
  email?: string;
}
