import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { TranslatePipe } from '../../../core/i18n/translate.pipe';

interface FooterNavItem {
  iconName?: string;
  iconText?: string;
  label: string;
  url: string;
  exact?: boolean;
}

@Component({
  selector: 'app-footer-nav',
  standalone: true,
  imports: [CommonModule, IonicModule, RouterModule, TranslatePipe],
  templateUrl: './footer-nav.component.html',
  styleUrls: ['./footer-nav.component.scss'],
})
export class FooterNavComponent {
  readonly navItems: FooterNavItem[] = [
    { iconText: '🏠︎', label: 'profile.nav.home', url: '/', exact: true },
    { iconText: '🗎', label: 'profile.nav.exams', url: '/examenes' },
    { iconText: 'ጸ', label: 'profile.nav.profile', url: '/perfil' },
  ];
}
