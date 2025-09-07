import { Component } from '@angular/core';
import { IonContent, IonCard, IonCardContent, IonIcon } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { addIcons } from 'ionicons';
import { medicalOutline, peopleOutline, peopleCircleOutline } from 'ionicons/icons';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  imports: [IonContent, IonCard, IonCardContent, IonIcon, RouterModule],
})
export class HomePage {
  constructor() {
    addIcons({ medicalOutline, peopleOutline, peopleCircleOutline });
  }
}
