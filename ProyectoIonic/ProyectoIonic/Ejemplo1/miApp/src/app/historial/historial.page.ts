import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel } from '@ionic/angular/standalone';

@Component({
  selector: 'app-historial',
  standalone: true,
  templateUrl: './historial.page.html',
  styleUrls: ['./historial.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel],
})
export class HistorialPage {}
