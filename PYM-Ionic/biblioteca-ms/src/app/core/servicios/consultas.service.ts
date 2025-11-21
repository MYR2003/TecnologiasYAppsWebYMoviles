import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

export interface Consulta {
  idConsulta: number;
  idPersona: number;
  idMedico: number;
  fecha: string;
  motivo: string;
  duracionMinutos: number;
  observaciones: string;
}

@Injectable({ providedIn: 'root' })
export class ConsultasService {
  private url = environment.servicios.consultas + '/consultas';

  constructor(private http: HttpClient) {}

  listar(): Observable<Consulta[]> {
    return this.http.get<Consulta[]>(this.url);
  }

  crear(consulta: Consulta): Observable<Consulta> {
    return this.http.post<Consulta>(this.url, consulta);
  }

  editar(consulta: Consulta): Observable<Consulta> {
    return this.http.put<Consulta>(`${this.url}/${consulta.idConsulta}`, consulta);
  }

  eliminar(idConsulta: number): Observable<any> {
    return this.http.delete(`${this.url}/${idConsulta}`);
  }
}
