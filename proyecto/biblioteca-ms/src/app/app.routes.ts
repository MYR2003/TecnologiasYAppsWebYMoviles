import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./examenes/examenes.page').then(m => m.ExamenesPage),
    pathMatch: 'full',
  },
];
