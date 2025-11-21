import { Routes } from '@angular/router';
import { authGuard } from './core/auth/auth.guard';

export const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./landing/landing.routes').then(m => m.routes),
  },
  {
    path: 'login',
    loadChildren: () => import('./login/login.routes').then(m => m.routes),
  },
  {
    path: 'examenes',
    loadChildren: () => import('./examenes/examenes.routes').then(m => m.routes),
    canActivate: [authGuard],
  },
  {
    path: 'registrar-persona',
    loadChildren: () => import('./registrar-persona/registrar-persona.routes').then(m => m.routes),
  },
  {
    path: 'dashboards',
    loadChildren: () => import('./dashboards/dashboards.routes').then(m => m.routes),
    canActivate: [authGuard],
  },
  {
    path: 'perfil',
    loadChildren: () => import('./perfil/perfil.routes').then(m => m.routes),
    canActivate: [authGuard],
  },
  {
    path: 'perfil/:id',
    loadChildren: () => import('./perfil/perfil.routes').then(m => m.routes),
    canActivate: [authGuard],
  },
];
