import { Component, Input } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { Medico } from '../../../core/servicios/medicos.service';

@Component({
  selector: 'app-tarjeta-medico',
  standalone: true,
  imports: [IonicModule, CommonModule],
  templateUrl: './tarjeta-medico.component.html',
  styleUrls: ['./tarjeta-medico.component.scss']
})
export class TarjetaMedicoComponent {
  @Input() medico!: Medico;
}
