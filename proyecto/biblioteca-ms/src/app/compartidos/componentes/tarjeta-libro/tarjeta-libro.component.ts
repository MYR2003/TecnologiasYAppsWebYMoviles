import { Component, Input } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { Libro } from '../../../core/servicios/libros.service';

@Component({
  selector: 'app-tarjeta-libro',
  standalone: true,
  imports: [IonicModule, CommonModule],
  templateUrl: './tarjeta-libro.component.html',
  styleUrls: ['./tarjeta-libro.component.scss']
})
export class TarjetaLibroComponent {
  @Input() libro!: Libro;

  reservar() {
    const reservas = JSON.parse(localStorage.getItem('reservas') || '[]');
    reservas.push({ libroId: this.libro.id, dias: 7 });
    localStorage.setItem('reservas', JSON.stringify(reservas));
    // Dispara evento para actualizar contador en otros componentes
    window.dispatchEvent(new StorageEvent('storage'));
  }
}

