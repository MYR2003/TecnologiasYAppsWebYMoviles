import { Component } from '@angular/core';
import { IonApp, IonRouterOutlet, IonMenu, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonIcon, IonLabel, MenuController } from '@ionic/angular/standalone';
import { ThemeService } from './services/theme.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  imports: [IonApp, IonRouterOutlet, IonMenu, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem, IonIcon, IonLabel],
})
export class AppComponent {
  constructor(
    private themeService: ThemeService,
    private menuController: MenuController,
    private router: Router
  ) {
    // El servicio se inicializa automáticamente al inyectarse
  }

  async navigateAndCloseMenu(route: string) {
    await this.menuController.close('main-menu');
    this.router.navigate([route]);
  }
}
