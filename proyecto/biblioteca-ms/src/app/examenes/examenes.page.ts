import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { ExamenesService, Examen } from '../core/servicios/examenes.service';
import { FormsModule } from '@angular/forms';
import { TranslationService } from '../core/i18n/translation.service';
import { TranslatePipe } from '../core/i18n/translate.pipe';
import { AuthService } from '../core/auth/auth.service';

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
  idPersona: number | null = null;
  showStatusMessages = false;

  constructor(
    private examenesService: ExamenesService, 
    private router: Router, 
    private readonly translation: TranslationService,
    private readonly authService: AuthService
  ) {}

  ngOnInit() {
    // Obtener el ID del usuario autenticado
    const currentUser = this.authService.currentUserValue;
    if (!currentUser) {
      this.error = 'No hay usuario autenticado';
      this.router.navigate(['/login']);
      return;
    }
    
    this.idPersona = currentUser.idpersona;
    this.selectedFile = null;
    this.cargarExamenes();
  }

  cargarExamenes() {
    if (!this.idPersona) {
      this.error = 'No se pudo obtener el ID del usuario';
      return;
    }
    
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

    if (!this.idPersona) {
      this.error = 'No se pudo obtener el ID del usuario';
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
