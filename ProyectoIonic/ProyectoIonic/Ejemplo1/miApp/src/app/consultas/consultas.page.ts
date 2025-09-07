import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton, IonGrid, IonRow, IonCol } from '@ionic/angular/standalone';
import { Router } from '@angular/router';

@Component({
  selector: 'app-consultas',
  standalone: true,
  templateUrl: './consultas.page.html',
  styleUrls: ['./consultas.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton, IonGrid, IonRow, IonCol],
})
export class ConsultasPage {
  constructor(private router: Router) {}

  verMedicamentos() {
    this.router.navigate(['/tabs/medicamentos']);
  }

  verDiagnosticos() {
    this.router.navigate(['/tabs/diagnosticos']);
  }
}
