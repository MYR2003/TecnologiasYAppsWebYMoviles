import { Component, OnInit } from '@angular/core';
import { CommonModule, NgFor, NgIf } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { Consulta } from '../microservicios/consulta/consulta';

@Component({
  selector: 'app-dashboards',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule, NgFor, NgIf],
  templateUrl: './dashboards.page.html',
  styleUrls: ['./dashboards.page.scss']
})
export class DashboardsPage {
  consultas: any[] = [];
  // Estados para loading, error, empty y datos
  loading = true;
  error: string | null = null;
  empty = false;

  // Variables para paginación
  currentPage = 1;
  pageSize = 10;
  totalConsultas = 0;
  totalPages = 0;
  loadingMore = false;

  // Datos reactivos con Observable
  data$: Observable<any>;

  // Datos de ejemplo
  totalExamenes = 0;
  totalPersonas = 0;
  tendenciaExamenes = 0;
  tendenciaPersonas = 0;
  periodo: 'semana' | 'mes' | 'anio' = 'semana';
  exPorDiaSemana: number[] = [];
  exPorDiaMes: number[] = [];
  exPorDiaAnio: number[] = [];
  labelsSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie'];
  labelsMes = Array.from({length: 30}, (_, i) => (i+1).toString());
  labelsAnio = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

  constructor(private consulta: Consulta) {
    // Simula carga de datos con Observable (puedes cambiar delay o error para probar)
    this.data$ = of({
      totalExamenes: 26,
      totalPersonas: 10,
      tendenciaExamenes: 8,
      tendenciaPersonas: -2,
      exPorDiaSemana: [5, 7, 3, 6, 5],
      exPorDiaMes: [2, 4, 3, 5, 6, 7, 8, 5, 4, 3, 2, 1, 0, 2, 3, 4, 5, 6, 7, 8, 5, 4, 3, 2, 1, 0, 2, 3, 4, 5],
      exPorDiaAnio: [20, 35, 18, 40, 22, 55, 30, 60, 28, 45, 33, 50]
    }).pipe(delay(1500));
    this.loadData();
  }

  ngOnInit() {
    this.loadConsultas();
  }

  loadConsultas() {
    if (this.loadingMore) {
      return;
    }

    this.loadingMore = true;
    const offset = (this.currentPage - 1) * this.pageSize;
    console.log('[Dashboards] Solicitar consultas', { pageSize: this.pageSize, offset: offset, page: this.currentPage });

    this.consulta.getConsulta(this.pageSize, offset).subscribe({
      next: (response) => {
        console.log('[Dashboards] Respuesta consultas', response);
        if (response.data && response.data.length > 0) {
          // Decodificar los textos con problemas de encoding
          this.consultas = response.data.map((c: any) => ({
            ...c,
            motivo: this.fixEncoding(c.motivo),
            observaciones: this.fixEncoding(c.observaciones)
          }));
          this.totalConsultas = response.total;
          this.totalPages = Math.ceil(this.totalConsultas / this.pageSize);
          
          console.log(`Mostrando página ${this.currentPage} de ${this.totalPages} (${this.consultas.length} consultas de ${this.totalConsultas} totales)`);
        } else {
          this.consultas = [];
          this.totalConsultas = 0;
          this.totalPages = 0;
        }

        this.loadingMore = false;
      },
      error: (err) => {
        console.error('Error al cargar consultas:', err);
        this.loadingMore = false;
      }
    });
  }

  goToPreviousPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.loadConsultas();
    }
  }

  goToNextPage() {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.loadConsultas();
    }
  }

  get hasPreviousPage(): boolean {
    return this.currentPage > 1;
  }

  get hasNextPage(): boolean {
    return this.currentPage < this.totalPages;
  }

  onIonInfinite(event: any) {
    // Ya no se usa el infinite scroll
    event?.target?.complete();
  }

  loadData() {
    this.loading = true;
    this.error = null;
    this.empty = false;
    this.data$.subscribe({
      next: (data) => {
        this.totalExamenes = data.totalExamenes;
        this.totalPersonas = data.totalPersonas;
        this.tendenciaExamenes = data.tendenciaExamenes;
        this.tendenciaPersonas = data.tendenciaPersonas;
        this.exPorDiaSemana = data.exPorDiaSemana;
        this.exPorDiaMes = data.exPorDiaMes;
        this.exPorDiaAnio = data.exPorDiaAnio;
        this.loading = false;
        // Estado vacío si no hay datos
        if (this.totalExamenes === 0 && this.totalPersonas === 0) {
          this.empty = true;
        }
      },
      error: (err) => {
        this.loading = false;
        this.error = 'Error al cargar los datos';
      }
    });
  }

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
  get maxValue(): number {
    const data = this.exPorDia;
    if (!data || data.length === 0) return 1;
    return Math.max(...data);
  }
  get periodLabel(): string {
    if (this.periodo === 'semana') return 'por día (semana)';
    if (this.periodo === 'mes') return 'por día (mes)';
    return 'por mes (año)';
  }
  
  fixEncoding(text: string | null | undefined): string {
    if (!text) return '';
    
    // Reemplazos directos para las palabras más comunes
    let fixed = text;
    fixed = fixed.replace(/RevisiÃƒÂ³n/g, 'Revisión');
    fixed = fixed.replace(/RevisiÃ³n/g, 'Revisión');
    fixed = fixed.replace(/revisiÃ³n/g, 'revisión');
    fixed = fixed.replace(/operaciÃ³n/g, 'operación');
    fixed = fixed.replace(/informaciÃ³n/g, 'información');
    fixed = fixed.replace(/atenciÃ³n/g, 'atención');
    fixed = fixed.replace(/DuraciÃ³n/g, 'Duración');
    fixed = fixed.replace(/duraciÃ³n/g, 'duración');
    fixed = fixed.replace(/examinaciÃ³n/g, 'examinación');
    
    // Reemplazos de caracteres individuales
    fixed = fixed.replace(/Ã³/g, 'ó');
    fixed = fixed.replace(/Ã©/g, 'é');
    fixed = fixed.replace(/Ã¡/g, 'á');
    fixed = fixed.replace(/Ã­/g, 'í');
    fixed = fixed.replace(/Ãº/g, 'ú');
    fixed = fixed.replace(/Ã±/g, 'ñ');
    
    return fixed;
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
