import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MedicamentoReceta {
  constructor(private http: HttpClient) {}

  async getMedicamentoReceta(): Promise<any[]> {
    return await firstValueFrom(this.http.get<any[]>('http://localhost:3014'))
  }
}
