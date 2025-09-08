import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  IonContent,
  IonList,
  IonItem,
  IonLabel,
  IonAvatar,
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonCardContent,
  IonToggle,
  IonIcon,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonButtons,
  IonButton,
} from '@ionic/angular/standalone';
import { Router } from '@angular/router';
import { ThemeService } from '../services/theme.service';

@Component({
  selector: 'app-perfil',
  standalone: true,
  templateUrl: './perfil.page.html',
  styleUrls: ['./perfil.page.scss'],
  imports: [
    CommonModule,
    IonContent,
    IonList,
    IonItem,
    IonLabel,
    IonAvatar,
    IonCard,
    IonCardHeader,
    IonCardTitle,
    IonCardContent,
    IonToggle,
    IonIcon,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonButtons,
    IonButton,
  ],
})
export class PerfilPage {
  constructor(
    private router: Router,
    public themeService: ThemeService
  ) {}

  toggleTheme(event: any) {
    this.themeService.setTheme(event.detail.checked);
  }

  // Métodos para el header de perfil
  shareProfile() {
    // Funcionalidad para compartir perfil
    console.log('Compartir perfil del médico');
  }

  editProfile() {
    // Navegar a edición de perfil
    console.log('Editar perfil médico');
    // this.router.navigate(['/editar-perfil']);
  }

  showNotifications() {
    // Mostrar notificaciones del perfil
    console.log('Mostrar notificaciones del perfil');
  }
}