import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Consulta {
  constructor(private http: HttpClient) {}

  // Normaliza la respuesta: soporta tanto array plano como objeto paginado { data, total, ... }
  getConsulta(limit: number = 100, offset: number = 0): Observable<{ data: any[]; total: number; limit: number; offset: number; hasMore: boolean; }> {
    const url = `http://localhost:3002?limit=${limit}&offset=${offset}`;
    return this.http.get<any>(url).pipe(
      map((resp: any) => {
        if (Array.isArray(resp)) {
          const data = resp;
          const total = data.length;
          return { data, total, limit, offset, hasMore: total >= limit };
        }
        // Si ya viene con la forma paginada
        return {
          data: resp.data ?? [],
          total: Number(resp.total ?? (resp.data?.length ?? 0)),
          limit: Number(resp.limit ?? limit),
          offset: Number(resp.offset ?? offset),
          hasMore: Boolean(resp.hasMore ?? ((resp.data?.length ?? 0) >= limit))
        };
      })
    );
  }

  getConsultaSimple(): Observable<any[]> {
    return this.http.get<any[]>('http://localhost:3002?limit=100');
  }
}