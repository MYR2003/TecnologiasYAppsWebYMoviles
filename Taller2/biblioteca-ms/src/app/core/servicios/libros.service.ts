import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs';

export interface Libro { id: number; titulo: string; autor: string; stock: number; }

@Injectable({ providedIn: 'root' })
export class LibrosService {
  private http = inject(HttpClient);
  private base = environment.servicios.libros; // http://localhost:4002

  listar(): Observable<Libro[]> {
    return this.http.get<Libro[]>(`${this.base}/libros`);
  }

  obtener(id: number): Observable<Libro> {
    return this.http.get<Libro>(`${this.base}/libros/${id}`);
  }
}
