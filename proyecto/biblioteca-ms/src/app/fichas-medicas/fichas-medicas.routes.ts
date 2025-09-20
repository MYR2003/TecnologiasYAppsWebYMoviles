import { Routes } from '@angular/router';
import { FichasMedicasPage } from './fichas-medicas.page';

export const routes: Routes = [
  {
    path: ':idPersona',
    component: FichasMedicasPage
  }
];
