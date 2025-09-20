import { Component, inject } from '@angular/core';
import { IonicModule, ToastController } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MedicosService, Medico } from '../core/servicios/medicos.service';
import { TarjetaMedicoComponent } from '../compartidos/componentes/tarjeta-medico/tarjeta-medico.component';

@Component({
  selector: 'app-tab2',
  standalone: true,
  imports: [IonicModule, CommonModule, FormsModule, TarjetaMedicoComponent],
  templateUrl: './tab2.page.html',
  styleUrls: ['./tab2.page.scss']
})
export class Tab2Page {
  private svc = inject(MedicosService);
  medicos: Medico[] = [];
  medicoEdit: Medico | null = null;

  ngOnInit() {
    this.svc.listar().subscribe(ls => this.medicos = ls);
  }

  agregarMedico(form: any) {
    if (!form || !form.valid) return;
    const nuevo: Medico = {
      idMedico: Date.now(),
      idEspecialidad: 1,
      nombre: form.value.nombre,
      apellido: form.value.apellido,
      rut: form.value.rut,
      fechaNacimiento: form.value.fechaNacimiento,
      telefono: form.value.telefono,
      email: form.value.email
    };
    this.svc.crear(nuevo).subscribe(m => {
      this.medicos.push(m);
      form.resetForm();
    });
  }

  editarMedico(m: Medico) {
    this.medicoEdit = { ...m };
  }

  guardarEdicion(form: any) {
    if (!form || !form.valid || !this.medicoEdit) return;
    const editado = { ...this.medicoEdit, ...form.value };
    this.svc.actualizar(editado.idMedico, editado).subscribe(res => {
      const idx = this.medicos.findIndex(x => x.idMedico === editado.idMedico);
      if (idx > -1) this.medicos[idx] = res;
      this.medicoEdit = null;
      form.resetForm();
    });
  }

  eliminarMedico(id: number) {
    this.svc.eliminar(id).subscribe(() => {
      this.medicos = this.medicos.filter(x => x.idMedico !== id);
    });
  }
}
