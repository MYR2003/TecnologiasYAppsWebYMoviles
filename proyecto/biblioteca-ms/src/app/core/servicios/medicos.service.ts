import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs';

export interface Medico {
  idMedico: number;
  idEspecialidad: number;
  nombre: string;
  apellido: string;
  rut: string;
  fechaNacimiento: string;
  telefono: string;
  email: string;
}

@Injectable({ providedIn: 'root' })
export class MedicosService {
  private http = inject(HttpClient);
  private base = environment.servicios.medicos; // http://localhost:3002

  listar(): Observable<Medico[]> {
    return this.http.get<Medico[]>(`${this.base}/medicos`);
  }

  obtener(id: number): Observable<Medico> {
    return this.http.get<Medico>(`${this.base}/medicos/${id}`);
  }

  crear(m: Medico): Observable<Medico> {
    return this.http.post<Medico>(`${this.base}/medicos`, m);
  }

  actualizar(id: number, m: Partial<Medico>): Observable<Medico> {
    return this.http.patch<Medico>(`${this.base}/medicos/${id}`, m);
  }

  eliminar(id: number): Observable<any> {
    return this.http.delete(`${this.base}/medicos/${id}`);
  }
}
