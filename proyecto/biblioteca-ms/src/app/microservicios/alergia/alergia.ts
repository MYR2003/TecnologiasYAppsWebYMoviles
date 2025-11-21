import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Alergia {
  constructor(private http: HttpClient) {}

  async getAlergia(): Promise<any[]> {
    return await firstValueFrom(this.http.get<any[]>('http://localhost:3001'));
  }
}
