import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton } from '@ionic/angular/standalone';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-detalle-funcionario',
  standalone: true,
  templateUrl: './detalle-funcionario.page.html',
  styleUrls: ['./detalle-funcionario.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonButton],
})
export class DetalleFuncionarioPage implements OnInit {
  funcionarioId: string = '';
  nombreFuncionario: string = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      this.funcionarioId = params['id'] || '';
      this.nombreFuncionario = params['nombre'] || 'Funcionario';
    });
  }

  volverFuncionarios() {
    this.router.navigate(['/tabs/funcionarios']);
  }

  verBeneficios() {
    this.router.navigate(['/tabs/beneficios']);
  }
}
