import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton } from '@ionic/angular/standalone';
import { Router } from '@angular/router';

@Component({
  selector: 'app-procedimientos',
  standalone: true,
  templateUrl: './procedimientos.page.html',
  styleUrls: ['./procedimientos.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton],
})
export class ProcedimientosPage {
  constructor(private router: Router) {
  }

  verOperaciones() {
    this.router.navigate(['/tabs/operaciones']);
  }

  verDiagnosticos() {
    this.router.navigate(['/tabs/diagnosticos']);
  }
}
