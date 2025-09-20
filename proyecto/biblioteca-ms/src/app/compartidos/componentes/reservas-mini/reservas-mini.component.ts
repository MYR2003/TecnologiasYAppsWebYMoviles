import { Component, signal } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-reservas-mini',
  standalone: true,
  imports: [IonicModule, CommonModule],
  templateUrl: './reservas-mini.component.html',
  styleUrls: ['./reservas-mini.component.scss']
})
export class ReservasMiniComponent {
  cantidad = signal(0);

  constructor() {
    this.sync();
    window.addEventListener('storage', () => this.sync());
  }

  private sync() {
    const r = JSON.parse(localStorage.getItem('reservas') || '[]');
    this.cantidad.set(r.length);
  }
}

