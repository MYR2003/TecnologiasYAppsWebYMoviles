import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, map, tap } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Consulta {
  constructor(private http: HttpClient) {}

  // Normaliza la respuesta: soporta tanto array plano como objeto paginado { data, total, ... }
  getConsulta(limit: number = 100, offset: number = 0): Observable<{ data: any[]; total: number; limit: number; offset: number; hasMore: boolean; }> {
    // NOTE: include trailing slash before query so it matches Express route '/'
    const url = `http://localhost:3002/?limit=${limit}&offset=${offset}`;
    return this.http.get<any>(url).pipe(
      tap((raw) => console.log('[ConsultaService] GET', url, '-> raw:', raw)),
      map((resp: any) => {
        if (Array.isArray(resp)) {
          const data = resp;
          const total = data.length;
          const normalized = { data, total, limit, offset, hasMore: total >= limit };
          console.log('[ConsultaService] normalized(array):', normalized);
          return normalized;
        }
        // Si ya viene con la forma paginada
        const normalized = {
          data: resp.data ?? [],
          total: Number(resp.total ?? (resp.data?.length ?? 0)),
          limit: Number(resp.limit ?? limit),
          offset: Number(resp.offset ?? offset),
          hasMore: Boolean(resp.hasMore ?? ((resp.data?.length ?? 0) >= limit))
        };
        console.log('[ConsultaService] normalized(paginated):', normalized);
        return normalized;
      })
    );
  }

  getConsultaSimple(): Observable<any[]> {
    const url = 'http://localhost:3002/?limit=100';
    console.log('[ConsultaService] GET simple', url);
    return this.http.get<any[]>(url);
  }
}