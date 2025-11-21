import { Component, Input } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { Persona } from '../../../core/servicios/personas.service';

@Component({
  selector: 'app-tarjeta-persona',
  standalone: true,
  imports: [IonicModule, CommonModule],
  templateUrl: './tarjeta-persona.component.html',
  styleUrls: ['./tarjeta-persona.component.scss']
})
export class TarjetaPersonaComponent {
  @Input() persona!: Persona;
}
