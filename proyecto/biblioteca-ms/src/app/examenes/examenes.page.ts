import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { ExamenesService, Examen } from '../core/servicios/examenes.service';
import { PersonasService, Persona } from '../core/servicios/personas.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-examenes',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule],
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
  personas: Persona[] = [];

  constructor(private examenesService: ExamenesService, private personasService: PersonasService) {}

  onPersonaChange(event: any) {
    this.idPersona = Number(event.detail.value);
    this.cargarExamenes();
  }

  ngOnInit() {
    this.personasService.listar().subscribe({
      next: (data) => {
        this.personas = data;
        console.log('Personas cargadas:', this.personas);
        if (this.personas.length > 0) {
            this.idPersona = this.personas[0].idPersona;
  console.log('idPersona inicial:', this.idPersona);
        }
        this.cargarExamenes();
      },
      error: () => {
        this.error = 'Error al cargar personas';
      }
    });
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
      }
    });
  }

  onFileChange(event: any) {
  const file = event.target.files[0];
  this.selectedFile = file;
  }

  subirImagen() {
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
      },
      error: () => {
        this.error = 'Error al subir la imagen';
        this.loading = false;
      }
    });
  }

  eliminarExamen(idExamen: number) {
    this.loading = true;
    this.error = '';
    this.examenesService.eliminarExamen(idExamen).subscribe({
      next: () => {
      this.examenes = this.examenes.filter(e => e.idExamen !== idExamen);
        this.empty = this.examenes.length === 0;
        this.loading = false;
      },
      error: () => {
        this.error = 'Error al eliminar el examen';
        this.loading = false;
      }
    });
  }
}
