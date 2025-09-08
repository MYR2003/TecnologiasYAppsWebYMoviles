import { Component } from '@angular/core';
import { IonContent, IonList, IonItem, IonLabel, IonButton, IonAvatar, IonIcon, IonHeader, IonToolbar, IonTitle, IonSegment, IonSegmentButton, IonChip } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-pacientes',
  standalone: true,
  templateUrl: 'pacientes.page.html',
  styleUrls: ['pacientes.scss'],
  imports: [CommonModule, IonContent, IonList, IonItem, IonLabel, IonButton, IonAvatar, IonIcon, IonHeader, IonToolbar, IonTitle, IonSegment, IonSegmentButton, IonChip],
})
export class PacientesPage {
  selectedSegment: string = 'pacientes';

  constructor(private router: Router) {}

  segmentChanged(event: any) {
    this.selectedSegment = event.detail.value;
  }

  verFichaPaciente(pacienteId: string) {
    this.router.navigate(['/tabs/ficha'], { queryParams: { id: pacienteId } });
  }

  verDetallesFuncionario(funcionarioId: string) {
    this.router.navigate(['/tabs/detalle-funcionario'], { queryParams: { id: funcionarioId } });
  }
}
