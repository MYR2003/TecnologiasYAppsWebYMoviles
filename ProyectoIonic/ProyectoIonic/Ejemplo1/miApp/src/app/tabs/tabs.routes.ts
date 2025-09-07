import { Routes } from '@angular/router';
import { TabsPage } from './tabs.page';

export const routes: Routes = [
  {
    path: 'tabs',
    component: TabsPage,
    children: [
      { path: 'home', loadComponent: () => import('../home/home.page').then(m => m.HomePage) },
      { path: 'pacientes', loadComponent: () => import('../pacientes/pacientes.page').then(m => m.PacientesPage) },
      { path: 'funcionarios', loadComponent: () => import('../funcionarios/funcionarios.page').then(m => m.FuncionariosPage) },
      { path: 'perfil', loadComponent: () => import('../perfil/perfil.page').then(m => m.PerfilPage) },
      { path: 'dashboards', loadComponent: () => import('../dashboards/dashboards.page').then(m => m.DashboardsPage) },
      { path: 'beneficios', loadComponent: () => import('../beneficios/beneficios.page').then(m => m.BeneficiosPage) },
      { path: 'consultas', loadComponent: () => import('../consultas/consultas.page').then(m => m.ConsultasPage) },
      { path: 'medicamentos', loadComponent: () => import('../medicamentos/medicamentos.page').then(m => m.MedicamentosPage) },
      { path: 'diagnosticos', loadComponent: () => import('../diagnosticos/diagnosticos.page').then(m => m.DiagnosticosPage) },
      { path: 'procedimientos', loadComponent: () => import('../procedimientos/procedimientos.page').then(m => m.ProcedimientosPage) },
      { path: 'alergias', loadComponent: () => import('../alergias/alergias.page').then(m => m.AlergiasPage) },
      { path: 'operaciones', loadComponent: () => import('../operaciones/operaciones.page').then(m => m.OperacionesPage) },
      { path: 'resumen', loadComponent: () => import('../resumen/resumen.page').then(m => m.ResumenPage) },
      { path: 'habitos', loadComponent: () => import('../habitos/habitos.page').then(m => m.HabitosPage) },
      { path: 'ficha', loadComponent: () => import('../ficha/ficha.page').then(m => m.FichaPage) },
      { path: 'historial', loadComponent: () => import('../historial/historial.page').then(m => m.HistorialPage) },
      { path: 'detalle-funcionario', loadComponent: () => import('../detalle-funcionario/detalle-funcionario.page').then(m => m.DetalleFuncionarioPage) },
      { path: 'detalle-beneficio', loadComponent: () => import('../detalle-beneficio/detalle-beneficio.page').then(m => m.DetalleBeneficioPage) },
      { path: 'martin01', loadComponent: () => import('../martin01/martin01.page').then(m => m.Martin01) },
      { path: 'martin02', loadComponent: () => import('../martin02/martin02.page').then(m => m.Martin02) },
      { path: '', redirectTo: '/tabs/home', pathMatch: 'full' },
    ],
  },
  { path: '', redirectTo: '/tabs/home', pathMatch: 'full' },
];