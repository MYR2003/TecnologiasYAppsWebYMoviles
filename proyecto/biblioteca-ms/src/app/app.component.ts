
import { Component, OnDestroy } from '@angular/core';
import { NgFor, NgIf } from '@angular/common';
import { Router, NavigationEnd } from '@angular/router';
import {
  IonApp,
  IonRouterOutlet,
  IonMenu,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonList,
  IonItem,
  IonLabel,
  IonToggle,
  IonButton,
  IonRange,
  IonSelect,
  IonSelectOption,
  IonText,
} from '@ionic/angular/standalone';
import { FormsModule } from '@angular/forms';
import { Subscription } from 'rxjs';
import { filter } from 'rxjs/operators';
import { TranslationService } from './core/i18n/translation.service';
import { TranslatePipe } from './core/i18n/translate.pipe';
import { LanguageCode, LanguageOption } from './core/i18n/translations';
import { FooterNavComponent } from './compartidos/componentes/footer-nav/footer-nav.component';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  imports: [
    IonApp,
    IonRouterOutlet,
    IonMenu,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonList,
    IonItem,
    IonLabel,
    IonToggle,
    IonButton,
    IonRange,
    IonSelect,
    IonSelectOption,
  IonText,
  NgFor,
    NgIf,
    FormsModule,
    TranslatePipe,
    FooterNavComponent,
  ],
})
export class AppComponent implements OnDestroy {
  isDark = false;
  textScale = 16;
  language: LanguageCode;
  languages: LanguageOption[] = [];
  showFooter = true;

  private readonly TEXT_SCALE_KEY = 'accessibility:text-scale';
  private readonly DARK_MODE_KEY = 'accessibility:dark-mode';
  private readonly DEFAULT_TEXT_SCALE = 16;
  private readonly MIN_TEXT_SCALE = 14;
  private readonly MAX_TEXT_SCALE = 22;
  private readonly languageSubscription: Subscription;
  private readonly routerSubscription: Subscription;

  constructor(private router: Router, private readonly translation: TranslationService) {
    // Detectar modo inicial
    this.isDark = document.body.classList.contains('dark');
    document.body.classList.remove('high-contrast', 'dyslexia-font');
    document.documentElement.classList.remove('text-scale-normal', 'text-scale-large', 'text-scale-xlarge');
    localStorage.removeItem('accessibility:high-contrast');
    localStorage.removeItem('accessibility:dyslexia-font');
    this.languages = this.translation.getSupportedLanguages();
    this.language = this.translation.currentLanguage;
    this.languageSubscription = this.translation.languageChanges$.subscribe((lang) => {
      this.language = lang;
    });
    
    // Suscribirse a cambios de ruta para ocultar/mostrar el footer
    this.routerSubscription = this.router.events
      .pipe(filter((event) => event instanceof NavigationEnd))
      .subscribe((event: NavigationEnd) => {
        const isLoginPage = event.url.startsWith('/login');
        const isHomePage = event.url === '/' || event.url === '';
        this.showFooter = !isLoginPage && !isHomePage;
        
        // Agregar/quitar clase login-page al body
        if (isLoginPage) {
          document.body.classList.add('login-page');
        } else {
          document.body.classList.remove('login-page');
        }
        
        // Agregar/quitar clase home-page al body
        if (isHomePage) {
          document.body.classList.add('home-page');
        } else {
          document.body.classList.remove('home-page');
        }
      });
    
    // Establecer estado inicial del footer y clase body
    const isLoginPage = this.router.url.startsWith('/login');
    this.showFooter = !isLoginPage;
    if (isLoginPage) {
      document.body.classList.add('login-page');
    } else {
      document.body.classList.remove('login-page');
    }
    
    this.restorePreferences();
  }

  ngOnDestroy(): void {
    this.languageSubscription.unsubscribe();
    this.routerSubscription.unsubscribe();
  }

  navigateTo(url: string) {
    this.router.navigateByUrl(url);
  }

  toggleDarkMode(ev: CustomEvent<{ checked: boolean }>) {
    this.setDarkMode(ev.detail.checked);
  }

  onTextScaleChange(ev: CustomEvent<{ value: unknown }>) {
    const rawValue = ev.detail.value;
    const singleValue = Array.isArray(rawValue) ? rawValue[0] : rawValue;
    const nextValue = Number(singleValue);
    if (Number.isFinite(nextValue)) {
      this.setTextScale(nextValue);
    }
  }

  resetAccessibility() {
    this.setDarkMode(false);
    this.setTextScale(this.DEFAULT_TEXT_SCALE);
    this.translation.resetLanguage();
  }

  onLanguageChange(ev: CustomEvent<{ value: unknown }>) {
    const next = ev.detail.value as LanguageCode | null;
    if (next) {
      this.translation.setLanguage(next);
    }
  }

  private restorePreferences() {
    const storedDarkValue = localStorage.getItem(this.DARK_MODE_KEY);
    const darkMode = storedDarkValue !== null ? storedDarkValue === 'true' : this.isDark;
    this.setDarkMode(darkMode, false);

    const storedScale = localStorage.getItem(this.TEXT_SCALE_KEY);
    this.setTextScale(this.parseTextScale(storedScale), false);
    this.language = this.translation.currentLanguage;
  }

  private setDarkMode(isDark: boolean, persist = true) {
    this.isDark = isDark;
    document.body.classList.toggle('dark', isDark);
    if (persist) {
      localStorage.setItem(this.DARK_MODE_KEY, String(isDark));
    }
  }

  private setTextScale(size: number, persist = true) {
    const clamped = this.clampTextScale(size);
    this.textScale = clamped;
    const root = document.documentElement;
    root.classList.remove('text-scale-normal', 'text-scale-large', 'text-scale-xlarge');
    root.style.setProperty('--app-font-size', `${clamped}px`);
    if (persist) {
      localStorage.setItem(this.TEXT_SCALE_KEY, String(clamped));
    }
  }

  private parseTextScale(value: string | null): number {
    if (value === null) {
      return this.DEFAULT_TEXT_SCALE;
    }
    const parsed = Number(value);
    return Number.isFinite(parsed) ? this.clampTextScale(parsed) : this.DEFAULT_TEXT_SCALE;
  }

  private clampTextScale(value: number): number {
    return Math.min(this.MAX_TEXT_SCALE, Math.max(this.MIN_TEXT_SCALE, value));
  }
}
