import { Component } from '@angular/core';
import { IonContent, IonList, IonItem, IonLabel, IonButton, IonAvatar, IonIcon, IonHeader, IonToolbar, IonTitle, IonSegment, IonSegmentButton, IonChip, IonButtons } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-pacientes',
  standalone: true,
  templateUrl: 'pacientes.page.html',
  styleUrls: ['pacientes.page.scss'],
  imports: [CommonModule, IonContent, IonList, IonItem, IonLabel, IonButton, IonAvatar, IonIcon, IonHeader, IonToolbar, IonTitle, IonSegment, IonSegmentButton, IonChip, IonButtons],
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

  // Nuevas funcionalidades médicas
  llamarPaciente(pacienteId: string) {
    // Funcionalidad para llamar al paciente
    console.log(`Llamando al paciente ${pacienteId}`);
  }

  llamarFuncionario(funcionarioId: string) {
    // Funcionalidad para llamar al funcionario
    console.log(`Llamando al funcionario ${funcionarioId}`);
  }

  buscarPersona() {
    // Funcionalidad de búsqueda
    console.log('Abriendo búsqueda...');
  }

  agregarPersona() {
    // Funcionalidad para agregar nueva persona
    console.log('Agregando nueva persona...');
  }

  // Métodos para obtener estadísticas (podrían venir de un servicio)
  getPacientesActivos(): number {
    return 127;
  }

  getPersonalMedico(): number {
    return 18;
  }

  getCitasHoy(): number {
    return 24;
  }
}
