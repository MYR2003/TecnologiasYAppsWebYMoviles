import { Component, inject } from '@angular/core';
import { IonicModule, ToastController } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { PrestamosService, Prestamo } from '../core/servicios/prestamos.service';

@Component({
  selector: 'app-tab2',
  standalone: true,
  imports: [IonicModule, CommonModule],
  templateUrl: './tab2.page.html',
  styleUrls: ['./tab2.page.scss']
})
export class Tab2Page {
  private prestamos = inject(PrestamosService);
  private toast = inject(ToastController);

  reservas: { libroId: number; dias: number; }[] = [];
  mensaje = '';

  ionViewWillEnter() {
    this.reservas = JSON.parse(localStorage.getItem('reservas') || '[]');
  }

  async confirmarPrestamo() {
    if (this.reservas.length === 0) { this.mensaje = 'No hay reservas.'; return; }

    const p: Prestamo = { usuarioId: 0, items: this.reservas, estado: 'activo' };
    this.prestamos.crear(p).subscribe(async resp => {
      this.mensaje = `Préstamo #${resp.id} creado`;
      localStorage.removeItem('reservas');
      this.reservas = [];
      (await this.toast.create({ message: this.mensaje, duration: 1500 })).present();
    });
  }
}
