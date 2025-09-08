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
  selectedSegment: string = 'fichas';

  constructor(private router: Router) {}

  segmentChanged(event: any) {
    this.selectedSegment = event.detail.value;
  }

  // === MÉTODOS CENTRADOS EN FICHAS MÉDICAS ===
  
  abrirFichaMedica(fichaId: string) {
    console.log(`Abriendo ficha médica ${fichaId}`);
    this.router.navigate(['/tabs/ficha'], { queryParams: { id: fichaId } });
  }

  editarFicha(fichaId: string) {
    console.log(`Editando ficha médica ${fichaId}`);
    // Navegar a vista de edición de ficha
  }

  crearNuevaFicha() {
    console.log('Creando nueva ficha médica...');
    this.router.navigate(['/tabs/ficha'], { queryParams: { modo: 'nuevo' } });
  }

  verHistorialMedico(fichaId: string) {
    console.log(`Ver historial de ficha ${fichaId}`);
    this.router.navigate(['/tabs/historial'], { queryParams: { ficha: fichaId } });
  }

  imprimirFicha(fichaId: string) {
    console.log(`Imprimiendo ficha médica ${fichaId}`);
    // Funcionalidad de impresión
  }

  exportarFicha(fichaId: string) {
    console.log(`Exportando ficha médica ${fichaId}`);
    // Funcionalidad de exportación
  }

  // === MÉTODOS PARA PERSONAL MÉDICO ===
  
  verDetallesFuncionario(funcionarioId: string) {
    this.router.navigate(['/tabs/detalle-funcionario'], { queryParams: { id: funcionarioId } });
  }

  asignarFichaMedico(fichaId: string, medicoId: string) {
    console.log(`Asignando ficha ${fichaId} al médico ${medicoId}`);
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
