import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ExamenConsulta {
  constructor(private http: HttpClient) {}

  async getExamenConsulta(): Promise<any[]> {
    return await firstValueFrom(this.http.get<any[]>('http://localhost:3058'))
  }
}

