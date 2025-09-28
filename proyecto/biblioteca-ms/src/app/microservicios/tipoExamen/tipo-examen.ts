import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class TipoExamen {
  constructor(private http: HttpClient) {}

  async getTipoExamen(): Promise<any[]> {
    return await firstValueFrom(this.http.get<any[]>('http://localhost:3023'))
  }
}
