
import { Router } from '@angular/router';



import { Component } from '@angular/core';
import { IonApp, IonRouterOutlet, IonHeader, IonToolbar, IonTitle, IonButtons, IonButton, IonIcon, IonMenu, IonMenuButton, IonContent, IonList, IonItem, IonLabel, IonFooter } from '@ionic/angular/standalone';
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
    IonLabel,
    IonFooter
  ],
})
export class AppComponent {
  isDarkMode = false;

  closeMenu() {
    const menu = document.querySelector('ion-menu');
    if (menu && (menu as any).close) {
      (menu as any).close();
    }
  }

  constructor(private router: Router) {
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

  async navigateTo(path: string) {
    const menu = document.querySelector('ion-menu');
    if (menu && (menu as any).close) {
      await (menu as any).close();
    }
    // Forzar recarga si ya estamos en la ruta
    if (this.router.url === path || (path === '/' && this.router.url === '')) {
      await this.router.navigateByUrl('/', { skipLocationChange: true });
      await this.router.navigate([path], { replaceUrl: true });
    } else {
      await this.router.navigate([path]);
    }
  }
}
