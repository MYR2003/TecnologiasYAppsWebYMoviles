import { Component } from '@angular/core';
import { PersonasService } from '../core/servicios/personas.service';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-registrar-persona',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule],
  templateUrl: './registrar-persona.page.html',
  styleUrls: ['./registrar-persona.page.scss']
})
export class RegistrarPersonaPage {
  persona = {
    nombre: '',
    apellido: '',
    rut: '',
    fechaNacimiento: '',
    // ...otros campos
  };
  loading = false;
  error = '';
  success = false;

  constructor(private personasService: PersonasService, private router: Router) {}

  salir() {
    this.router.navigate(['/']);
  }

  ngOnInit() {
    // Recibe datos extraídos desde navigation state
    const nav = window.history.state;
    if (nav && nav.datosExtraidos) {
      this.persona = { ...this.persona, ...nav.datosExtraidos };
    }
  }

  guardarPersona() {
    this.loading = true;
    this.error = '';
    this.success = false;
    this.personasService.crear({
      idPersona: 0, // El backend lo ignora o lo asigna
      nombre: this.persona.nombre,
      apellido: this.persona.apellido,
      rut: this.persona.rut,
      fechaNacimiento: this.persona.fechaNacimiento,
      sistemaDeSalud: '',
      domicilio: '',
      numero: '',
      alergias: [],
      contactosEmergencia: [],
      fichasMedicas: []
    }).subscribe({
      next: (resp) => {
  this.success = true;
  this.loading = false;
  // Redirigir a la página de Exámenes
  this.router.navigate(['/']);
      },
      error: (err) => {
        this.error = 'Error al guardar persona';
        this.loading = false;
      }
    });
  }
}
