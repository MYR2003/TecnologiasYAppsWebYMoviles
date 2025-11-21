import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonContent, IonButton } from '@ionic/angular/standalone';
import { RouterLink } from '@angular/router';
import { TranslatePipe } from '../core/i18n/translate.pipe';

@Component({
  standalone: true,
  selector: 'app-landing',
  templateUrl: './landing.page.html',
  styleUrls: ['./landing.page.scss'],
  imports: [CommonModule, IonContent, IonButton, RouterLink, TranslatePipe],
})
export class LandingPage {}

export default LandingPage;
