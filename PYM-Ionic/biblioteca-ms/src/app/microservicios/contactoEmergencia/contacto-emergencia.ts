import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ContactoEmergencia {
  constructor(private http: HttpClient) {}

  async getContactoEmergencia(): Promise<any[]> {
    return await firstValueFrom(this.http.get<any[]>('http://localhost:3003'))
  } 
}
