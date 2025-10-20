import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Consulta {
  constructor(private http: HttpClient) {}

  getConsulta(limit: number = 100, offset: number = 0): Observable<any> {
    const url = `http://localhost:3002?limit=${limit}&offset=${offset}`;
    return this.http.get<any>(url);
  }

  // Método legacy para mantener compatibilidad (devuelve solo los datos)
  getConsultaSimple(): Observable<any[]> {
    return this.http.get<any[]>('http://localhost:3002?limit=100');
  }
}