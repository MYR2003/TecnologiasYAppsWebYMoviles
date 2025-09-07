import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton } from '@ionic/angular/standalone';

@Component({
  selector: 'app-detalle-beneficio',
  standalone: true,
  templateUrl: './detalle-beneficio.page.html',
  styleUrls: ['./detalle-beneficio.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton],
})
export class DetalleBeneficioPage {
  constructor() {
  }
}
