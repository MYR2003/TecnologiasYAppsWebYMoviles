import { Component, OnInit } from '@angular/core';
import { CommonModule, NgFor, NgIf } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { Consulta } from '../microservicios/consulta/consulta';
import { TranslatePipe } from '../core/i18n/translate.pipe';
import { FooterNavComponent } from '../compartidos/componentes/footer-nav/footer-nav.component';
import { AuthService } from '../core/auth/auth.service';

@Component({
  selector: 'app-consultas',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule, NgFor, NgIf, TranslatePipe, FooterNavComponent],
  templateUrl: './consultas.page.html',
  styleUrls: ['./consultas.page.scss']
})
export class ConsultasPage implements OnInit {
  consultas: any[] = [];
  loading = false;
  loadingMore = false;

  // Variables para paginación
  currentPage = 1;
  pageSize = 10;
  totalConsultas = 0;
  totalPages = 0;

  constructor(
    private consulta: Consulta,
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadConsultas();
  }

  loadConsultas() {
    if (this.loadingMore) {
      return;
    }

    this.loadingMore = true;
    const offset = (this.currentPage - 1) * this.pageSize;
    console.log('[Consultas] Solicitar consultas', { pageSize: this.pageSize, offset: offset, page: this.currentPage });

    this.consulta.getConsulta(this.pageSize, offset).subscribe({
      next: (response) => {
        console.log('[Consultas] Respuesta consultas', response);
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

  fixEncoding(text: string): string {
    if (!text) return text;
    try {
      const bytes = new Uint8Array(text.split('').map(char => char.charCodeAt(0)));
      return new TextDecoder('utf-8').decode(bytes);
    } catch (e) {
      return text;
    }
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

  async cerrarSesion(): Promise<void> {
    this.authService.logout();
    await this.router.navigate(['/login'], { replaceUrl: true });
  }
}
