import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Examen {
  idExamen: number;
  idPersona: number;
  fecha: string;
  imagen: string; // URL o base64
  datosExtraidos: string; // JSON o texto plano
}

@Injectable({ providedIn: 'root' })
export class ExamenesService {
  // Cambiar a backend en EC2
  private apiUrl = 'http://44.197.129.106:3000/api/examenes';

  constructor(private http: HttpClient) {}

  subirImagen(file: File, idPersona: number): Observable<Examen> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('idPersona', idPersona.toString());
    return this.http.post<Examen>(`${this.apiUrl}/subir`, formData);
  }

  getExamenesPorPersona(idPersona: number): Observable<Examen[]> {
    return this.http.get<Examen[]>(`${this.apiUrl}?idPersona=${idPersona}`);
  }

  getExamen(idExamen: number): Observable<Examen> {
    return this.http.get<Examen>(`${this.apiUrl}/${idExamen}`);
  }

  eliminarExamen(idExamen: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${idExamen}`);
  }
}
