import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardSubtitle, IonCardContent, IonList, IonItem, IonIcon, IonLabel, IonGrid, IonRow, IonCol, IonButton } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { addIcons } from 'ionicons';
import { calculator, list, addCircle, apps, phonePortrait } from 'ionicons/icons';

@Component({
  selector: 'app-tab1',
  templateUrl: 'tab1.page.html',
  styleUrls: ['tab1.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardSubtitle, IonCardContent, IonList, IonItem, IonIcon, IonLabel, IonGrid, IonRow, IonCol, IonButton, RouterModule],
})
export class Tab1Page {
  constructor() {
    addIcons({ calculator, list, addCircle, apps, phonePortrait });
  }
}
