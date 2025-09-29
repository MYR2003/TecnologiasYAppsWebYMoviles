


import { Component } from '@angular/core';
import { IonApp, IonRouterOutlet, IonHeader, IonToolbar, IonTitle, IonButtons, IonButton, IonIcon, IonMenu, IonMenuButton, IonContent, IonList, IonItem, IonLabel } from '@ionic/angular/standalone';
import { isPlatform } from '@ionic/angular';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  imports: [
    IonApp,
    IonRouterOutlet,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonButtons,
    IonButton,
    IonIcon,
    IonMenu,
    IonMenuButton,
    IonContent,
    IonList,
    IonItem,
    IonLabel
  ],
})
export class AppComponent {
  isDarkMode = false;

  constructor() {
    // Detectar modo inicial
    this.isDarkMode = document.body.classList.contains('dark');
  }

  toggleDarkMode() {
    this.isDarkMode = !this.isDarkMode;
    document.body.classList.toggle('dark', this.isDarkMode);
  }

  refrescar() {
    window.location.reload();
  }
}
