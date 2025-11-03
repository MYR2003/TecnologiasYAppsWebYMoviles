import { Component, OnDestroy, OnInit } from '@angular/core';
import { CommonModule, NgFor, NgIf } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';
import { Observable, Subscription, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { Consulta } from '../microservicios/consulta/consulta';
import { TranslationService } from '../core/i18n/translation.service';
import { TranslatePipe } from '../core/i18n/translate.pipe';

interface ChartPoint {
  index: number;
  label: string;
  value: number;
  x: number;
  y: number;
}

@Component({
  selector: 'app-dashboards',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule, NgFor, NgIf, TranslatePipe],
  templateUrl: './dashboards.page.html',
  styleUrls: ['./dashboards.page.scss']
})
export class DashboardsPage implements OnInit, OnDestroy {
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
  labelsSemana: string[] = [];
  labelsMes = Array.from({length: 30}, (_, i) => (i+1).toString());
  labelsAnio: string[] = [];
  selectedPoint: ChartPoint | null = null;
  private readonly chartHeight = 240;
  private readonly chartPadding = { top: 24, right: 28, bottom: 48, left: 32 };
  private readonly chartStep = 80;
  chartData = this.buildLineChartData([], []);
  private selectedPointIndex: number | null = null;
  private readonly languageSubscription: Subscription;

  constructor(private consulta: Consulta, private readonly translation: TranslationService) {
    // Simula carga de datos con Observable (puedes cambiar delay o error para probar)
    this.data$ = of({
  totalExamenes: 0,
      totalPersonas: 14,
      tendenciaExamenes: 8,
      tendenciaPersonas: 6,
      exPorDiaSemana: [5, 6, 7, 8, 10],
      exPorDiaMes: [2, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9, 9, 10, 11, 12, 12, 13, 14, 15, 16, 17, 17, 18, 19, 20, 21, 21, 22, 23, 24],
      exPorDiaAnio: [18, 24, 32, 38, 42, 48, 54, 60, 64, 70, 76, 82]
    }).pipe(delay(1500));
    this.refreshLocalizedContent(false);
    this.languageSubscription = this.translation.languageChanges$.subscribe(() => {
      this.refreshLocalizedContent();
    });
    this.loadData();
  }

  ngOnInit() {
    this.loadConsultas();
  }

  ngOnDestroy(): void {
    this.languageSubscription.unsubscribe();
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
  const totalAnual = (data.exPorDiaAnio ?? []).reduce((acum: number, valor: number) => acum + valor, 0);
  this.totalExamenes = totalAnual || data.totalExamenes || 0;
        this.totalPersonas = data.totalPersonas;
        this.tendenciaExamenes = Math.abs(data.tendenciaExamenes);
        this.tendenciaPersonas = Math.abs(data.tendenciaPersonas);
        this.exPorDiaSemana = data.exPorDiaSemana;
        this.exPorDiaMes = data.exPorDiaMes;
        this.exPorDiaAnio = data.exPorDiaAnio;
        this.loading = false;
        // Estado vacío si no hay datos
        if (this.totalExamenes === 0 && this.totalPersonas === 0) {
          this.empty = true;
        }
        this.selectedPointIndex = null;
        this.updateChartData();
      },
      error: (err) => {
        this.loading = false;
        this.error = this.translation.translate('dashboards.loadError');
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
  get periodLabel(): string {
    if (this.periodo === 'semana') return this.translation.translate('dashboards.periodLabel.week');
    if (this.periodo === 'mes') return this.translation.translate('dashboards.periodLabel.month');
    return this.translation.translate('dashboards.periodLabel.year');
  }

  get consultasHeader(): string {
    if (this.totalConsultas > 0 && this.consultas.length > 0) {
      const start = (this.currentPage - 1) * this.pageSize + 1;
      const end = start + this.consultas.length - 1;
      return this.translation.translate('dashboards.consultationsRange', {
        start,
        end,
        total: this.totalConsultas,
      });
    }
    return this.translation.translate('dashboards.consultationsZero');
  }

  onPeriodoChange() {
    this.selectedPointIndex = null;
    this.updateChartData();
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

  selectPoint(point: ChartPoint) {
    this.selectedPointIndex = point.index;
    this.selectedPoint = this.chartData.points[point.index] ?? { ...point };
  }

  private updateChartData() {
    this.chartData = this.buildLineChartData(this.exPorDia, this.labels);
    if (this.chartData.points.length === 0) {
      this.selectedPointIndex = null;
      this.selectedPoint = null;
      return;
    }

    if (
      this.selectedPointIndex === null ||
      this.selectedPointIndex < 0 ||
      this.selectedPointIndex >= this.chartData.points.length
    ) {
      this.selectedPointIndex = this.chartData.points.length - 1;
    }

    this.selectedPoint = this.chartData.points[this.selectedPointIndex];
  }

  private buildLineChartData(values: number[], labels: string[]) {
    const count = values?.length ?? 0;
    if (!values || count === 0) {
      return {
        polyline: '',
        points: [] as ChartPoint[],
        width: 0,
        height: this.chartHeight,
        padding: this.chartPadding,
        guides: [] as { y: number; label: string }[],
      };
    }

    const width = this.chartPadding.left + this.chartPadding.right + (count - 1) * this.chartStep;
    const min = Math.min(...values);
    const max = Math.max(...values);
    const range = max - min || 1;
    const chartHeight = this.chartHeight;
    const usableHeight = chartHeight - this.chartPadding.top - this.chartPadding.bottom;
    const stepX = count > 1 ? (width - this.chartPadding.left - this.chartPadding.right) / (count - 1) : 0;

    const points: ChartPoint[] = values.map((value, index) => {
      const x = this.chartPadding.left + stepX * index;
      const y = chartHeight - this.chartPadding.bottom - ((value - min) / range) * usableHeight;
      return {
        index,
        label: labels[index] ?? `#${index + 1}`,
        value,
        x,
        y,
      };
    });

    const polyline = points.map((point) => `${point.x},${point.y}`).join(' ');

    const guideCount = 4;
    const guides = Array.from({ length: guideCount }, (_, i) => {
      const ratio = i / (guideCount - 1);
      const y = this.chartPadding.top + (1 - ratio) * usableHeight;
      const labelValue = Math.round(min + ratio * range);
      return { y, label: `${labelValue}` };
    });

    return {
      polyline,
      points,
      width,
      height: chartHeight,
      padding: this.chartPadding,
      guides,
    };
  }

  private refreshLocalizedContent(updateChart = true) {
    this.labelsSemana = this.translation.translateList('dashboards.chart.weekLabels');
    this.labelsAnio = this.translation.translateList('dashboards.chart.yearMonthLabels');
    if (updateChart) {
      this.updateChartData();
    }
  }

}
