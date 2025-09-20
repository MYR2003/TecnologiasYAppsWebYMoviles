import { Component, inject } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { FichasMedicasService, FichaMedica } from '../core/servicios/fichas-medicas.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-fichas-medicas',
  standalone: true,
  imports: [IonicModule, CommonModule],
  template: `
    <ion-header>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-button (click)="volver()" color="primary">
            <ion-icon name="arrow-back"></ion-icon>
            Volver
          </ion-button>
        </ion-buttons>
        <ion-title>Fichas Médicas</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content class="ion-padding">
      <ng-container *ngIf="ficha; else vacio">
        <ion-card>
          <ion-card-header>
            <ion-card-title>Ficha Médica</ion-card-title>
            <ion-card-subtitle>{{ ficha.fecha | date:'medium' }}</ion-card-subtitle>
          </ion-card-header>
          <ion-card-content>
            <p><strong>ID Persona:</strong> {{ ficha.idPersona }}</p>
            <p><strong>ID Médico:</strong> {{ ficha.idMedico }}</p>
            <p><strong>Altura:</strong> {{ ficha.altura }} m</p>
            <p><strong>Peso:</strong> {{ ficha.peso }} kg</p>
            <p><strong>Presión:</strong> {{ ficha.presion }}</p>
            <p><strong>Observaciones:</strong> {{ ficha.observaciones }}</p>
          </ion-card-content>
        </ion-card>
      </ng-container>
      <ng-template #vacio>
        <h2>No hay ficha médica registrada para esta persona</h2>
      </ng-template>
    </ion-content>
  `,
  styleUrls: ['./fichas-medicas.page.scss']
})
export class FichasMedicasPage {
  private svc = inject(FichasMedicasService);
  private router = inject(Router);
  private route = inject(ActivatedRoute);
  ficha: FichaMedica | null = null;

  ngOnInit() {
    const idPersona = Number(this.route.snapshot.paramMap.get('idPersona'));
    this.svc.listar().subscribe(ls => {
      this.ficha = ls.find(f => f.idPersona === idPersona) || null;
    });
  }

  volver() {
    this.router.navigate(['/tabs/tab1']);
  }
}
