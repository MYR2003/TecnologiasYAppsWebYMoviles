import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonGrid, IonRow, IonCol } from '@ionic/angular/standalone';
import { Router } from '@angular/router';

@Component({
  selector: 'app-medicamentos',
  standalone: true,
  templateUrl: './medicamentos.page.html',
  styleUrls: ['./medicamentos.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonGrid, IonRow, IonCol],
})
export class MedicamentosPage {
  constructor(private router: Router) {
  }

  verProcedimientos() {
    this.router.navigate(['/tabs/procedimientos']);
  }

  verAlergias() {
    this.router.navigate(['/tabs/alergias']);
  }
}
