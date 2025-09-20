import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./tabs/tabs.routes').then((m) => m.routes),
  },
  {
    path: 'fichas-medicas',
    loadChildren: () => import('./fichas-medicas/fichas-medicas.routes').then(m => m.routes)
  },
];
