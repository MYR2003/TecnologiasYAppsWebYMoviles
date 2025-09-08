import { Component, EnvironmentInjector, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonTabs, IonTabBar, IonTabButton, IonIcon, IonLabel, IonHeader, IonToolbar, IonTitle, IonButtons, IonMenuButton, IonButton, IonBadge, IonAvatar } from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { triangle, ellipse, square, peopleOutline, peopleCircleOutline, medicalOutline, sunnyOutline, moonOutline, analyticsOutline, settingsOutline, person, documentTextOutline, barChartOutline, trendingUpOutline, pieChartOutline, calendarOutline, arrowForwardOutline, cashOutline, timeOutline, notificationsOutline, searchOutline, sunny, moon, pulse, documentText } from 'ionicons/icons';
import { ThemeService } from '../services/theme.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-tabs',
  templateUrl: 'tabs.page.html',
  styleUrls: ['tabs.page.scss'],
  imports: [CommonModule, IonTabs, IonTabBar, IonTabButton, IonIcon, IonLabel, IonHeader, IonToolbar, IonTitle, IonButtons, IonMenuButton, IonButton, IonBadge, IonAvatar],
})
export class TabsPage {
  public environmentInjector = inject(EnvironmentInjector);
  public notificationCount = 3;
  public activeUsers = 8;
  public lastSync = '14:32';

  constructor(
    public themeService: ThemeService,
    private router: Router
  ) {
    addIcons({ 
      triangle, 
      ellipse, 
      square, 
      peopleOutline, 
      peopleCircleOutline, 
      medicalOutline, 
      sunnyOutline, 
      moonOutline,
      analyticsOutline,
      settingsOutline,
      person,
      documentTextOutline,
      barChartOutline,
      trendingUpOutline,
      pieChartOutline,
      calendarOutline,
      arrowForwardOutline,
      cashOutline,
      timeOutline,
      notificationsOutline,
      searchOutline,
      sunny,
      moon,
      pulse,
      documentText
    });
    
    // Actualizar datos del sistema cada 30 segundos
    setInterval(() => {
      this.updateSystemStatus();
    }, 30000);
  }

  // === FUNCIONALIDADES DEL HEADER MÉDICO ===
  
  toggleTheme() {
    this.themeService.toggleTheme();
  }

  getCurrentTheme() {
    return this.themeService.getCurrentTheme();
  }

  // Abrir notificaciones médicas
  openNotifications() {
    console.log('Abriendo notificaciones médicas...');
    // Implementar modal o página de notificaciones
  }

  // Búsqueda rápida de fichas médicas
  openQuickSearch() {
    console.log('Abriendo búsqueda rápida...');
    this.router.navigate(['/tabs/pacientes'], { queryParams: { search: true } });
  }

  // Abrir perfil de usuario
  openUserProfile() {
    console.log('Abriendo perfil de usuario...');
    this.router.navigate(['/tabs/perfil']);
  }

  // === SISTEMA DE ESTADO EN TIEMPO REAL ===
  
  updateSystemStatus() {
    // Simular actualización del estado del sistema
    this.lastSync = new Date().toLocaleTimeString('es-ES', { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
    
    // Simular cambios en usuarios activos
    this.activeUsers = Math.floor(Math.random() * 15) + 5;
    
    console.log(`Sistema actualizado - Usuarios activos: ${this.activeUsers}, Última sync: ${this.lastSync}`);
  }

  // Leer todas las notificaciones
  markAllNotificationsAsRead() {
    this.notificationCount = 0;
    console.log('Todas las notificaciones marcadas como leídas');
  }
}
