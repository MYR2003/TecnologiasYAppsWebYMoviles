import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardSubtitle, IonCardContent, IonList, IonItem, IonIcon, IonLabel, IonGrid, IonRow, IonCol, IonButton } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { addIcons } from 'ionicons';
import { calculator, list, addCircle, apps, phonePortrait } from 'ionicons/icons';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardSubtitle, IonCardContent, IonList, IonItem, IonIcon, IonLabel, IonGrid, IonRow, IonCol, IonButton, RouterModule],
})
export class HomePage {
  constructor() {
    addIcons({ calculator, list, addCircle, apps, phonePortrait });
  }
}
