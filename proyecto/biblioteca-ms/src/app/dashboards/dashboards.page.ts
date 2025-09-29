import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-dashboards',
  standalone: true,
  imports: [CommonModule, IonicModule],
  templateUrl: './dashboards.page.html',
  styleUrls: ['./dashboards.page.scss']
})
export class DashboardsPage {
  // Datos de ejemplo
  totalExamenes = 26;
  totalPersonas = 10;
  exPorDia = [5, 7, 3, 6, 5];
  labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];
}
