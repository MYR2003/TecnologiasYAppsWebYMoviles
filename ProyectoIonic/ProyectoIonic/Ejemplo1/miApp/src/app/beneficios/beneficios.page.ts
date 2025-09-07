import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonList,
  IonItem,
  IonLabel,
  IonButton,
} from '@ionic/angular/standalone';
import { Router } from '@angular/router';

@Component({
  selector: 'app-beneficios',
  standalone: true,
  templateUrl: './beneficios.page.html',
  styleUrls: ['./beneficios.page.scss'],
  imports: [
    CommonModule,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonList,
    IonItem,
    IonLabel,
    IonButton,
  ],
})
export class BeneficiosPage {
  constructor(private router: Router) {}

  verDetalleBeneficio(beneficioId: string, nombre: string) {
    this.router.navigate(['/tabs/detalle-beneficio'], {
      queryParams: { id: beneficioId, nombre: nombre }
    });
  }
}