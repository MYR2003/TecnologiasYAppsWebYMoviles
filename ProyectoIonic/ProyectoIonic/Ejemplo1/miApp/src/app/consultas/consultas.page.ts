import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton, IonGrid, IonRow, IonCol, IonIcon, IonButtons, IonSegment, IonSegmentButton, IonAvatar, IonChip } from '@ionic/angular/standalone';
import { Router } from '@angular/router';

@Component({
  selector: 'app-consultas',
  standalone: true,
  templateUrl: './consultas.page.html',
  styleUrls: ['./consultas.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton, IonGrid, IonRow, IonCol, IonIcon, IonButtons, IonSegment, IonSegmentButton, IonAvatar, IonChip],
})
export class ConsultasPage {
  selectedSegment: string = 'recientes';

  constructor(private router: Router) {}

  // === MÉTODOS CENTRADOS EN FICHAS MÉDICAS ===
  
  verFichaMedica(fichaId: string) {
    console.log(`Abriendo ficha médica ${fichaId} desde historia`);
    this.router.navigate(['/tabs/ficha'], { queryParams: { id: fichaId } });
  }

  verHistorialCompleto(fichaId: string) {
    console.log(`Ver historial completo de ficha ${fichaId}`);
    this.router.navigate(['/tabs/historial'], { queryParams: { ficha: fichaId } });
  }

  crearNuevaFicha() {
    console.log('Crear nueva ficha médica desde historia');
    this.router.navigate(['/tabs/ficha'], { queryParams: { modo: 'nuevo' } });
  }

  buscarFichas() {
    console.log('Buscar fichas médicas');
    // Implementar funcionalidad de búsqueda de fichas
  }

  renovarPrescripcion(fichaId: string) {
    console.log(`Renovar prescripción para ficha ${fichaId}`);
    // Implementar renovación de prescripción
  }

  // === MÉTODOS DE ANÁLISIS MÉDICO ===
  
  verMedicamentos() {
    this.router.navigate(['/tabs/medicamentos']);
  }

  verDiagnosticos() {
    this.router.navigate(['/tabs/diagnosticos']);
  }

  // === CONTROL DE SEGMENTOS ===
  
  segmentChanged(event: any) {
    this.selectedSegment = event.detail.value;
    console.log(`Filtro de historia cambiado a: ${this.selectedSegment}`);
  }
}
