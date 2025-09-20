import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs';

export interface PrestamoItem { libroId: number; dias: number; }
export interface Prestamo { id?: number; usuarioId: number; items: PrestamoItem[]; estado: 'activo' | 'devuelto'; }

@Injectable({ providedIn: 'root' })
export class PrestamosService {
  private http = inject(HttpClient);
  private base = environment.servicios.prestamos; // http://localhost:4003

  listar(): Observable<Prestamo[]> {
    return this.http.get<Prestamo[]>(`${this.base}/prestamos`);
  }

  crear(p: Prestamo): Observable<Prestamo> {
    return this.http.post<Prestamo>(`${this.base}/prestamos`, p);
  }
}
