import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Persona {
  constructor(private http: HttpClient) {}

  async getPersona(): Promise<any[]> {
    const response = await firstValueFrom(this.http.get<any>('http://localhost:3016?limit=10000'));
    return response.data || [];
  }

}
