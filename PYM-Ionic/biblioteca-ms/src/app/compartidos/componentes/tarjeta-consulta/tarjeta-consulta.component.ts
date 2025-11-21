import { Component, Input } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { Consulta } from '../../../core/servicios/consultas.service';

@Component({
  selector: 'app-tarjeta-consulta',
  standalone: true,
  imports: [IonicModule, CommonModule],
  templateUrl: './tarjeta-consulta.component.html',
  styleUrls: ['./tarjeta-consulta.component.scss']
})
export class TarjetaConsultaComponent {
  @Input() consulta!: Consulta;
}
