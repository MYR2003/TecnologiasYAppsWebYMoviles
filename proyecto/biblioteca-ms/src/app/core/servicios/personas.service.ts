import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs';

export interface Persona {
  idPersona: number;
  nombre: string;
  apellido: string;
  rut: string;
  fechaNacimiento: string;
  sistemaDeSalud: string;
  domicilio: string;
  numero: string;
  alergias?: number[];
  contactosEmergencia?: number[];
  fichasMedicas?: number[];
}

@Injectable({ providedIn: 'root' })
export class PersonasService {
  private http = inject(HttpClient);
  private base = environment.servicios.personas; // http://52.87.237.243:3001

  listar(): Observable<Persona[]> {
    return this.http.get<Persona[]>(`${this.base}/personas`);
  }

  obtener(id: number): Observable<Persona> {
    return this.http.get<Persona>(`${this.base}/personas/${id}`);
  }

  crear(p: Persona): Observable<Persona> {
    return this.http.post<Persona>(`${this.base}/personas`, p);
  }

  actualizar(id: number, p: Partial<Persona>): Observable<Persona> {
    return this.http.patch<Persona>(`${this.base}/personas/${id}`, p);
  }

  eliminar(id: number): Observable<any> {
    return this.http.delete(`${this.base}/personas/${id}`);
  }
}
