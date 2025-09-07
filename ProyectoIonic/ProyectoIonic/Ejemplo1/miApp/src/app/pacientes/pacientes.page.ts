import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-pacientes',
  standalone: true,
  templateUrl: 'pacientes.page.html',
  styleUrls: ['pacientes.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton],
})
export class PacientesPage {
  constructor(private router: Router) {}

  verFichaPaciente(pacienteId: string) {
    this.router.navigate(['/tabs/ficha'], { queryParams: { id: pacienteId } });
  }
}
