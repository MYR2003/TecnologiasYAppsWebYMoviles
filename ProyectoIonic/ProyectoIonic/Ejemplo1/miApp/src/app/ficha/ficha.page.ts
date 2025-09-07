import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton, IonGrid, IonRow, IonCol } from '@ionic/angular/standalone';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-ficha',
  standalone: true,
  templateUrl: './ficha.page.html',
  styleUrls: ['./ficha.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton, IonGrid, IonRow, IonCol],
})
export class FichaPage implements OnInit {
  pacienteId: string = '';
  pacienteNombre: string = '';

  constructor(
    private router: Router,
    private route: ActivatedRoute
  ) {
  }

  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      this.pacienteId = params['id'] || '001';
      this.setPacienteInfo();
    });
  }

  setPacienteInfo() {
    const pacientes: any = {
      '001': 'María González',
      '002': 'Juan Pérez', 
      '003': 'Lucía Torres',
      '004': 'Carlos Ramírez',
      '005': 'Andrea Silva'
    };
    this.pacienteNombre = pacientes[this.pacienteId] || 'Juan Pérez';
  }

  verHistorial() {
    this.router.navigate(['/tabs/historial'], { queryParams: { pacienteId: this.pacienteId } });
  }

  verResumen() {
    this.router.navigate(['/tabs/resumen'], { queryParams: { pacienteId: this.pacienteId } });
  }
}
