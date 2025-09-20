import { Component, inject } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { LibrosService, Libro } from '../core/servicios/libros.service';
import { TarjetaLibroComponent } from '../compartidos/componentes/tarjeta-libro/tarjeta-libro.component';
import { ReservasMiniComponent } from '../compartidos/componentes/reservas-mini/reservas-mini.component';

@Component({
  selector: 'app-tab1',
  standalone: true,
  imports: [IonicModule, CommonModule, RouterModule, TarjetaLibroComponent, ReservasMiniComponent],
  templateUrl: './tab1.page.html',
  styleUrls: ['./tab1.page.scss']
})
export class Tab1Page {
  private svc = inject(LibrosService);
  private router = inject(Router);
  libros: Libro[] = [];

  ngOnInit() {
    this.svc.listar().subscribe(ls => this.libros = ls);
  }

  irAPrestamos() {
    this.router.navigateByUrl('/tabs/tab2');
  }
}
