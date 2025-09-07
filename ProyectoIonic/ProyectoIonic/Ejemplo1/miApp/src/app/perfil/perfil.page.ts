import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  IonContent,
  IonList,
  IonItem,
  IonLabel,
  IonAvatar,
  IonButton,
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonCardContent,
  IonToggle,
  IonIcon,
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
    IonButton,
    IonCard,
    IonCardHeader,
    IonCardTitle,
    IonCardContent,
    IonToggle,
    IonIcon,
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
}