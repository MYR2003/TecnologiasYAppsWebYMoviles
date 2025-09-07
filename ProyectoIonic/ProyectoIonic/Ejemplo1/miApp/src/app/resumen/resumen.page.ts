import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonGrid, IonRow, IonCol, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton } from '@ionic/angular/standalone';

@Component({
  selector: 'app-resumen',
  standalone: true,
  templateUrl: './resumen.page.html',
  styleUrls: ['./resumen.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonGrid, IonRow, IonCol, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton],
})
export class ResumenPage {
  constructor(
    private router: Router
  ) {
  }

  verHabitos() {
    this.router.navigate(['/tabs/habitos']);
  }
}
