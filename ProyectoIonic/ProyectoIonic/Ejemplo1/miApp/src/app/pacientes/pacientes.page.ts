import { Component } from '@angular/core';
import { IonContent, IonList, IonItem, IonLabel, IonButton, IonAvatar, IonIcon } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-pacientes',
  standalone: true,
  templateUrl: 'pacientes.page.html',
  styleUrls: ['pacientes.scss'],
  imports: [CommonModule, IonContent, IonList, IonItem, IonLabel, IonButton, IonAvatar, IonIcon],
})
export class PacientesPage {
  constructor(private router: Router) {}

  verFichaPaciente(pacienteId: string) {
    this.router.navigate(['/tabs/ficha'], { queryParams: { id: pacienteId } });
  }
}
