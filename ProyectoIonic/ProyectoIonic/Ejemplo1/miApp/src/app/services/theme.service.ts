import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private isDarkMode = false;

  constructor() {
    // Detectar preferencia inicial del sistema
    this.initializeTheme();
  }

  private initializeTheme() {
    // Verificar si hay una preferencia guardada
    const savedTheme = localStorage.getItem('clinic-theme');
    
    if (savedTheme) {
      this.isDarkMode = savedTheme === 'dark';
    } else {
      // Usar preferencia del sistema si no hay guardada
      this.isDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;
    }
    
    this.applyTheme();
  }

  toggleTheme() {
    this.isDarkMode = !this.isDarkMode;
    this.applyTheme();
    this.saveThemePreference();
  }

  setTheme(isDark: boolean) {
    this.isDarkMode = isDark;
    this.applyTheme();
    this.saveThemePreference();
  }

  private applyTheme() {
    const body = document.body;
    
    if (this.isDarkMode) {
      body.classList.remove('theme-light');
      body.classList.add('theme-dark');
    } else {
      body.classList.remove('theme-dark');
      body.classList.add('theme-light');
    }
  }

  private saveThemePreference() {
    localStorage.setItem('clinic-theme', this.isDarkMode ? 'dark' : 'light');
  }

  getCurrentTheme(): boolean {
    return this.isDarkMode;
  }

  getThemeName(): string {
    return this.isDarkMode ? 'Modo Oscuro' : 'Modo Claro';
  }
}
