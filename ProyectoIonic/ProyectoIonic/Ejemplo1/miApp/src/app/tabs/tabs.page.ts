import { Component, EnvironmentInjector, inject } from '@angular/core';
import { IonTabs, IonTabBar, IonTabButton, IonIcon, IonLabel, IonHeader, IonToolbar, IonTitle, IonButtons, IonMenuButton, IonButton } from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { triangle, ellipse, square, peopleOutline, peopleCircleOutline, medicalOutline, sunnyOutline, moonOutline } from 'ionicons/icons';
import { ThemeService } from '../services/theme.service';

@Component({
  selector: 'app-tabs',
  templateUrl: 'tabs.page.html',
  styleUrls: ['tabs.page.scss'],
  imports: [IonTabs, IonTabBar, IonTabButton, IonIcon, IonLabel, IonHeader, IonToolbar, IonTitle, IonButtons, IonMenuButton, IonButton],
})
export class TabsPage {
  public environmentInjector = inject(EnvironmentInjector);

  constructor(public themeService: ThemeService) {
    addIcons({ 
      triangle, 
      ellipse, 
      square, 
      peopleOutline, 
      peopleCircleOutline, 
      medicalOutline, 
      sunnyOutline, 
      moonOutline 
    });
  }

  toggleTheme() {
    this.themeService.toggleTheme();
  }

  getCurrentTheme() {
    return this.themeService.getCurrentTheme();
  }
}
