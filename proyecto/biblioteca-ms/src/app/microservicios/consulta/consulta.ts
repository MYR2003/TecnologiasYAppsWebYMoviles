import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Consulta {
  constructor(private http: HttpClient) {}

  async getConsulta(): Promise<any[]> {
    return await firstValueFrom(this.http.get<any[]>('http://localhost:3002'))
  }
}
