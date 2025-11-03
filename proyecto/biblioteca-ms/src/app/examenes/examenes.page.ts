import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { ExamenesService, Examen } from '../core/servicios/examenes.service';
import { PersonasService, Persona } from '../core/servicios/personas.service';
import { FormsModule } from '@angular/forms';
import { TranslationService } from '../core/i18n/translation.service';
import { TranslatePipe } from '../core/i18n/translate.pipe';

@Component({
  selector: 'app-examenes',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule, TranslatePipe],
  templateUrl: './examenes.page.html',
  styleUrls: ['./examenes.page.scss']
})
export class ExamenesPage {
  examenes: Examen[] = [];
  loading = false;
  error = '';
  empty = false;
  selectedFile: File | null = null;
  idPersona = 1; // Simulación, luego usar auth
  nombreUsuario = 'Usuario Actual'; // Dinámico, reemplazar con servicio de auth
  showStatusMessages = false;
  // personas: Persona[] = [];

  constructor(private examenesService: ExamenesService, private router: Router, private readonly translation: TranslationService) {}



  ngOnInit() {
    this.selectedFile = null;
    this.cargarExamenes();
  }

  cargarExamenes() {
    this.loading = true;
    this.error = '';
      this.examenesService.getExamenesPorPersona(this.idPersona).subscribe({
      next: (data) => {
        this.examenes = data;
        this.empty = data.length === 0;
        this.loading = false;
      },
      error: (err) => {
        this.error = this.translation.translate('exams.loadError');
        this.loading = false;
      }
    });
  }

  onFileChange(event: any) {
  const file = event.target.files[0];
  this.selectedFile = file;
  }

  subirImagen() {
    this.enableStatusMessages();
    if (!this.selectedFile) return;
    this.idPersona = Number(this.idPersona);
    console.log('idPersona al subir:', this.idPersona);
    this.loading = true;
    this.error = '';
    this.examenesService.subirImagen(this.selectedFile, this.idPersona).subscribe({
      next: (examen) => {
        this.examenes.unshift(examen);
        this.selectedFile = null;
        this.loading = false;
        // Navegación automática a la tab Registrar Persona, pasando datos extraídos
        let datosExtraidos = {};
        try {
          datosExtraidos = examen.datosExtraidos ? JSON.parse(examen.datosExtraidos) : {};
        } catch (e) {
          datosExtraidos = {};
        }
        this.router.navigate(['/registrar-persona'], { state: { datosExtraidos } });
      },
      error: () => {
        this.error = this.translation.translate('exams.uploadError');
        this.loading = false;
      }
    });
  }

  eliminarExamen(idExamen: number) {
  this.enableStatusMessages();
  console.log('Intentando eliminar examen con id:', idExamen);
  this.loading = true;
  this.error = '';
  this.examenesService.eliminarExamen(idExamen).subscribe({
      next: () => {
      this.examenes = this.examenes.filter(e => e.idExamen !== idExamen);
        this.empty = this.examenes.length === 0;
        this.loading = false;
      },
      error: () => {
        this.error = this.translation.translate('exams.deleteError');
        this.loading = false;
      }
    });
  }

  private enableStatusMessages() {
    if (!this.showStatusMessages) {
      this.showStatusMessages = true;
    }
  }
}
