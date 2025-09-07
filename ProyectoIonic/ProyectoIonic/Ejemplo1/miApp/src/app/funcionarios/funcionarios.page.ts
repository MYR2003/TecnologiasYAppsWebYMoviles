import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-funcionarios',
  standalone: true,
  templateUrl: 'funcionarios.page.html',
  styleUrls: ['funcionarios.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel, IonButton],
})
export class FuncionariosPage {
  constructor(private router: Router) {}

  verDetalleFuncionario(funcionarioId: string, nombre: string) {
    this.router.navigate(['/tabs/detalle-funcionario'], {
      queryParams: { id: funcionarioId, nombre: nombre }
    });
  }
}
