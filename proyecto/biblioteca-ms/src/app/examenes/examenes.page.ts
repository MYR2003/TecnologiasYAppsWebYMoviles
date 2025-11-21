import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { ExamenesService, Examen } from '../core/servicios/examenes.service';
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
  idPersona = 1; // TODO: Obtener del servicio de autenticación
  showStatusMessages = false;

  constructor(
    private examenesService: ExamenesService, 
    private router: Router, 
    private readonly translation: TranslationService
  ) {}

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
        this.error = 'Error al cargar exámenes';
        this.loading = false;
        console.error(err);
      }
    });
  }

  onFileChange(event: any) {
    const file = event.target.files[0];
    if (file) {
      // Validar tipo de archivo
      const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf'];
      if (!allowedTypes.includes(file.type)) {
        this.error = 'Solo se permiten archivos JPG, PNG o PDF';
        this.selectedFile = null;
        return;
      }
      
      // Validar tamaño (50MB máximo)
      const maxSize = 50 * 1024 * 1024;
      if (file.size > maxSize) {
        this.error = 'El archivo es demasiado grande. Máximo 50MB';
        this.selectedFile = null;
        return;
      }
      
      this.selectedFile = file;
      this.error = '';
    }
  }

  subirImagen() {
    this.enableStatusMessages();
    if (!this.selectedFile) {
      this.error = 'No se ha seleccionado ningún archivo';
      return;
    }

    this.loading = true;
    this.error = '';
    
    this.examenesService.subirImagen(this.selectedFile, this.idPersona).subscribe({
      next: (examen) => {
        this.examenes.unshift(examen);
        this.selectedFile = null;
        this.loading = false;
        this.empty = false;
        
        // Resetear el input de archivo
        const fileInput = document.getElementById('fileInput') as HTMLInputElement;
        if (fileInput) {
          fileInput.value = '';
        }
      },
      error: (err) => {
        this.error = 'Error al subir el archivo';
        this.loading = false;
        console.error(err);
      }
    });
  }

  eliminarExamen(idExamen: number) {
    this.enableStatusMessages();
    this.loading = true;
    this.error = '';
    
    this.examenesService.eliminarExamen(idExamen).subscribe({
      next: () => {
        this.examenes = this.examenes.filter(e => e.idexamen !== idExamen);
        this.empty = this.examenes.length === 0;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al eliminar el examen';
        this.loading = false;
        console.error(err);
      }
    });
  }

  private enableStatusMessages() {
    if (!this.showStatusMessages) {
      this.showStatusMessages = true;
    }
  }
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
