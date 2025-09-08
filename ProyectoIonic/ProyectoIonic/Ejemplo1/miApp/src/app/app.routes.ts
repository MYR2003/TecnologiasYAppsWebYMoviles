import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./tabs/tabs.routes').then((m) => m.routes),
  },
  {
    path: 'polo1',
    loadComponent: () => import('./polo1/polo1.page').then( m => m.Polo1Page)
  },
  {
    path: 'polo2',
    loadComponent: () => import('./polo2/polo2.page').then( m => m.Polo2Page)
  },
  {
    path: 'polo3',
    loadComponent: () => import('./polo3/polo3.page').then( m => m.Polo3Page)
  },
  {
    path: 'polo4',
    loadComponent: () => import('./polo4/polo4.page').then( m => m.Polo4Page)
  },
  {
    path: 'polo5',
    loadComponent: () => import('./polo5/polo5.page').then( m => m.Polo5Page)
  },
  {
    path: 'polo6',
    loadComponent: () => import('./polo6/polo6.page').then( m => m.Polo6Page)
  },
];
