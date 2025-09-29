import { Component } from '@angular/core';
import { CommonModule, NgFor, NgIf } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-dashboards',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule, NgFor, NgIf],
  templateUrl: './dashboards.page.html',
  styleUrls: ['./dashboards.page.scss']
})
export class DashboardsPage {
  // Datos de ejemplo
  totalExamenes = 26;
  totalPersonas = 10;
  tendenciaExamenes = 8; // +8% respecto a semana anterior
  tendenciaPersonas = -2; // -2% respecto a semana anterior

  periodo: 'semana' | 'mes' | 'anio' = 'semana';

  exPorDiaSemana = [5, 7, 3, 6, 5];
  exPorDiaMes = [2, 4, 3, 5, 6, 7, 8, 5, 4, 3, 2, 1, 0, 2, 3, 4, 5, 6, 7, 8, 5, 4, 3, 2, 1, 0, 2, 3, 4, 5];
  exPorDiaAnio = [20, 35, 18, 40, 22, 55, 30, 60, 28, 45, 33, 50];
  labelsSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];
  labelsMes = Array.from({length: 30}, (_, i) => (i+1).toString());
  labelsAnio = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

  get exPorDia() {
    if (this.periodo === 'semana') return this.exPorDiaSemana;
    if (this.periodo === 'mes') return this.exPorDiaMes;
    if (this.periodo === 'anio') return this.exPorDiaAnio;
    return [];
  }
  get labels() {
    if (this.periodo === 'semana') return this.labelsSemana;
    if (this.periodo === 'mes') return this.labelsMes;
    if (this.periodo === 'anio') return this.labelsAnio;
    return [];
  }
      public getSparklinePoints(data: number[], width: number, height: number): string {
        if (!data || data.length < 2) return '';
        const max = Math.max(...data);
        const min = Math.min(...data);
        const len = data.length;
        const step = width / (len - 1);
        return data.map((v: number, i: number) => {
          const y = height - ((v - min) / (max - min || 1)) * (height - 4) - 2;
          const x = i * step;
          return `${x},${y}`;
        }).join(' ');
      }
}
