import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Consulta {
  constructor(private http: HttpClient) {}

  getConsulta(): Observable<any[]> {
    const vari = this.http.get<any[]>('http://localhost:3002')
    console.log(vari)
    return vari
    //return firstValueFrom(this.http.get<any[]>('http://localhost:3002'))
  }
}