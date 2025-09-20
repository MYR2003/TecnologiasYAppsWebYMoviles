import { Component, inject } from '@angular/core';
import { NgForm } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule, Router } from '@angular/router';
import { PersonasService, Persona } from '../core/servicios/personas.service';
import { TarjetaPersonaComponent } from '../compartidos/componentes/tarjeta-persona/tarjeta-persona.component';

@Component({
  selector: 'app-tab1',
  standalone: true,
  imports: [IonicModule, CommonModule, FormsModule, RouterModule, TarjetaPersonaComponent],
  templateUrl: './tab1.page.html',
  styleUrls: ['./tab1.page.scss']
})
export class Tab1Page {
  private svc = inject(PersonasService);
  private router = inject(Router);
  personas: Persona[] = [];
  personaEdit: Persona | null = null;

  ngOnInit() {
    this.svc.listar().subscribe(ls => this.personas = ls);
  }

  agregarPersona(form?: NgForm) {
    if (!form || !form.valid) return;
    const nueva: Persona = {
      idPersona: Date.now(),
      nombre: form.value.nombre,
      apellido: form.value.apellido,
      rut: form.value.rut,
      fechaNacimiento: form.value.fechaNacimiento,
      sistemaDeSalud: form.value.sistemaDeSalud,
      domicilio: form.value.domicilio,
      numero: form.value.numero
    };
    this.svc.crear(nueva).subscribe(p => {
      this.personas.push(p);
      form.resetForm();
    });
  }

  editarPersona(p: Persona) {
    this.personaEdit = { ...p };
    // Aquí podrías abrir un modal o reutilizar el formulario para editar
  }

  guardarEdicion(form?: NgForm) {
    if (!form || !form.valid || !this.personaEdit) return;
    const editado = { ...this.personaEdit, ...form.value };
    this.svc.actualizar(editado.idPersona, editado).subscribe(res => {
      const idx = this.personas.findIndex(x => x.idPersona === editado.idPersona);
      if (idx > -1) this.personas[idx] = res;
      this.personaEdit = null;
      form.resetForm();
    });
  }

  eliminarPersona(id: number) {
    this.svc.eliminar(id).subscribe(() => {
      this.personas = this.personas.filter(x => x.idPersona !== id);
    });
  }
}
