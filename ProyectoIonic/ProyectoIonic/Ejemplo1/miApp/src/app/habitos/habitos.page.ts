import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel } from '@ionic/angular/standalone';

@Component({
  selector: 'app-habitos',
  standalone: true,
  templateUrl: './habitos.page.html',
  styleUrls: ['./habitos.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonLabel],
})
export class HabitosPage {}
