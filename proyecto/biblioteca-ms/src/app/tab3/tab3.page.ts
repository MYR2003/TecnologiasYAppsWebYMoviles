import { Component, inject } from '@angular/core';
import { NgForm } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ConsultasService, Consulta } from '../core/servicios/consultas.service';
import { TarjetaConsultaComponent } from '../compartidos/componentes/tarjeta-consulta/tarjeta-consulta.component';

@Component({
  selector: 'app-tab3',
  standalone: true,
  imports: [IonicModule, CommonModule, FormsModule, TarjetaConsultaComponent],
  templateUrl: './tab3.page.html',
  styleUrls: ['./tab3.page.scss']
})
export class Tab3Page {
  private svc = inject(ConsultasService);
  consultas: Consulta[] = [];
  consultaEdit: Consulta | null = null;

  ngOnInit() {
    this.svc.listar().subscribe(ls => this.consultas = ls);
  }

  agregarConsulta(form: NgForm) {
    if (!form || !form.valid) return;
    const nueva: Consulta = {
      idConsulta: Date.now(),
      idPersona: 1,
      idMedico: 1,
      fecha: new Date().toISOString(),
      motivo: form.value.motivo,
      duracionMinutos: form.value.duracionMinutos,
      observaciones: form.value.observaciones
    };
    this.svc.crear(nueva).subscribe(c => {
      this.consultas.push(c);
      form.resetForm();
    });
  }

  editarConsulta(c: Consulta) {
    this.consultaEdit = { ...c };
  }

  guardarEdicion(form: NgForm) {
    if (!form || !form.valid || !this.consultaEdit) return;
    this.svc.editar(this.consultaEdit).subscribe(c => {
      const idx = this.consultas.findIndex(x => x.idConsulta === c.idConsulta);
      if (idx > -1) this.consultas[idx] = c;
      this.consultaEdit = null;
    });
  }

  eliminarConsulta(idConsulta: number) {
    this.svc.eliminar(idConsulta).subscribe(() => {
      this.consultas = this.consultas.filter(c => c.idConsulta !== idConsulta);
    });
  }
}
