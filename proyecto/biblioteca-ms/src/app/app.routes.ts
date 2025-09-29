import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./examenes/examenes.page').then(m => m.ExamenesPage),
    pathMatch: 'full',
  },
  {
    path: 'registrar-persona',
    loadChildren: () => import('./registrar-persona/registrar-persona.routes').then(m => m.routes),
  },
];
