import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { firstValueFrom } from 'rxjs';
import { AuthService } from '../core/auth/auth.service';
import { TranslatePipe } from '../core/i18n/translate.pipe';
import { Persona } from '../microservicios/persona/persona';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule, TranslatePipe],
  templateUrl: './login.page.html',
  styleUrls: ['./login.page.scss'],
})
export class LoginPage implements OnInit {
  rut = '';
  apellido = '';
  loading = false;
  error: string | null = null;

  constructor(
    private readonly personaService: Persona,
    private readonly authService: AuthService,
    private readonly router: Router
  ) {}

  ngOnInit(): void {
    // Limpiar campos al inicializar
    this.rut = '';
    this.apellido = '';
    this.error = null;
    
    // Si ya está autenticado, redirigir
    if (this.authService.isAuthenticated) {
      this.router.navigate(['/']);
    }
  }

  private normalizeRut(value: string): string {
    return value.toLowerCase().replace(/[^0-9k]/g, '').trim();
  }

  async onSubmit(): Promise<void> {
    const rutIngresado = this.rut.trim();
    const rutNormalizado = this.normalizeRut(rutIngresado);
    const apellidoNormalizado = this.apellido.trim().toLowerCase();

    if (!rutNormalizado || !apellidoNormalizado) {
      this.error = 'login.errors.emptyFields';
      return;
    }

    this.loading = true;
    this.error = null;

    try {
      const personas = await this.personaService.getPersona();

      const personaEncontrada = personas?.find((registro: any) => {
        const rutRegistro = this.normalizeRut(registro.rut?.toString() ?? '');
        const apellidoRegistro = registro.apellido?.toString().toLowerCase().trim() ?? '';
        return rutRegistro === rutNormalizado && apellidoRegistro === apellidoNormalizado;
      });

      if (personaEncontrada) {
        this.authService.login({
          idpersona: Number(personaEncontrada.idpersona),
          nombre: personaEncontrada.nombre ?? '',
          apellido: personaEncontrada.apellido ?? '',
          rut: personaEncontrada.rut ?? '',
          telefono: personaEncontrada.telefono?.toString(),
          domicilio: personaEncontrada.domicilio ?? '',
          sistemadesalud: personaEncontrada.sistemadesalud ?? '',
        });

        await this.router.navigate(['/examenes']);
      } else {
        this.error = 'login.errors.invalidCredentials';
      }
    } catch (err) {
      console.error('Error en login:', err);
      this.error = 'login.errors.serverError';
    } finally {
      this.loading = false;
    }
  }
}
