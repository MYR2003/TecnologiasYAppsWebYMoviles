import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./examenes/examenes.routes').then(m => m.routes),
    pathMatch: 'full',
  },
  {
    path: 'registrar-persona',
    loadChildren: () => import('./registrar-persona/registrar-persona.routes').then(m => m.routes),
  },
  {
    path: 'dashboards',
    loadChildren: () => import('./dashboards/dashboards.routes').then(m => m.routes),
  },
];
