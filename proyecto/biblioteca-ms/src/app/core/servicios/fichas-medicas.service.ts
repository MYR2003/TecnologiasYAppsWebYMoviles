import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs';

export interface FichaMedica {
  idFicha: number;
  idPersona: number;
  idMedico: number;
  fecha: string;
  altura: number;
  peso: number;
  presion: string;
  observaciones: string;
}

@Injectable({ providedIn: 'root' })
export class FichasMedicasService {
  private http = inject(HttpClient);
  private base = environment.servicios.fichasMedicas; // http://localhost:3004

  listar(): Observable<FichaMedica[]> {
    return this.http.get<FichaMedica[]>(this.base);
  }

  obtener(id: number): Observable<FichaMedica> {
    return this.http.get<FichaMedica>(`${this.base}/${id}`);
  }

  crear(f: FichaMedica): Observable<FichaMedica> {
    return this.http.post<FichaMedica>(this.base, f);
  }

  actualizar(id: number, f: Partial<FichaMedica>): Observable<FichaMedica> {
    return this.http.put<FichaMedica>(`${this.base}/${id}`, f);
  }

  eliminar(id: number): Observable<any> {
    return this.http.delete(`${this.base}/${id}`);
  }
}
