import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonContent, IonGrid, IonRow, IonCol, IonCard, IonCardHeader, IonCardTitle, IonCardContent } from '@ionic/angular/standalone';

@Component({
  selector: 'app-dashboards',
  standalone: true,
  templateUrl: './dashboards.page.html',
  styleUrls: ['./dashboards.page.scss'],
  imports: [CommonModule, IonContent, IonGrid, IonRow, IonCol, IonCard, IonCardHeader, IonCardTitle, IonCardContent],
})
export class DashboardsPage {}
