import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { Router } from '@angular/router';
import { addIcons } from 'ionicons';
import { calculator, add, checkmarkCircle, refresh, home, list } from 'ionicons/icons';

@Component({
  selector: 'app-nombre-pagina',
  templateUrl: './nombre-pagina.page.html',
  styleUrls: ['./nombre-pagina.page.scss'],
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule, IonicModule] 
})
export class NombrePaginaPage implements OnInit {
  num1: number | null = null;
  num2: number | null = null;
  resultado: number | null = null;

  constructor(private router: Router) {
    addIcons({ calculator, add, checkmarkCircle, refresh, home, list });
  }

  sumar() {
    if (this.num1 !== null || this.num2 !== null) {
      this.resultado = (this.num1 || 0) + (this.num2 || 0);
    }
  }

  limpiar() {
    this.num1 = null;
    this.num2 = null;
    this.resultado = null;
  }

  onInputChange() {
    // Reset result when inputs change
    this.resultado = null;
  }

  irAFuncionarios() {
    this.router.navigate(['/tabs/funcionarios']);       
  }

  ngOnInit() {}
}
