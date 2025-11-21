import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Examen {
  idexamen: number;
  idpersona: number;
  idtipoexamen: number;
  examen: string;
  fecha_subida: string;
  imagen: string; // Data URI (base64)
}

export interface SolicitudAcceso {
  id: number;
  examen_id: number;
  usuario_solicitante_id: number;
  estado: 'pendiente' | 'aprobado' | 'rechazado';
  fecha_solicitud: string;
  fecha_respuesta?: string;
  solicitante_nombre?: string;
  solicitante_apellido?: string;
  nombre_examen?: string;
}

@Injectable({ providedIn: 'root' })
export class ExamenesService {
  private apiUrl = 'http://localhost:3010';

  constructor(private http: HttpClient) {}

  subirImagen(file: File, idPersona: number, idTipoExamen: number = 1): Observable<Examen> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('idpersona', idPersona.toString());
    formData.append('idtipoexamen', idTipoExamen.toString());
    formData.append('nombre_examen', file.name);
    return this.http.post<Examen>(`${this.apiUrl}/subir`, formData);
  }

  getExamenesPorPersona(idPersona: number): Observable<Examen[]> {
    return this.http.get<Examen[]>(`${this.apiUrl}/persona/${idPersona}`);
  }

  getExamen(idExamen: number): Observable<Examen> {
    return this.http.get<Examen>(`${this.apiUrl}/${idExamen}`);
  }

  eliminarExamen(idExamen: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${idExamen}`);
  }
}
