import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { firstValueFrom } from 'rxjs';
import { AuthService } from '../core/auth/auth.service';
import { TranslatePipe } from '../core/i18n/translate.pipe';
import { Medico } from '../microservicios/medico/medico';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, IonicModule, FormsModule, TranslatePipe],
  templateUrl: './login.page.html',
  styleUrls: ['./login.page.scss'],
})
export class LoginPage {
  rut = '';
  apellido = '';
  loading = false;
  error: string | null = null;

  constructor(
    private readonly medicoService: Medico,
    private readonly authService: AuthService,
    private readonly router: Router
  ) {
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
      const medicos = await this.medicoService.getMedico();

      const medicoEncontrado = medicos?.find((registro: any) => {
        const rutRegistro = this.normalizeRut(registro.rut?.toString() ?? '');
        const apellidoRegistro = registro.apellido?.toString().toLowerCase().trim() ?? '';
        return rutRegistro === rutNormalizado && apellidoRegistro === apellidoNormalizado;
      });

      if (medicoEncontrado) {
        this.authService.login({
          idmedico: Number(medicoEncontrado.idmedico),
          nombre: medicoEncontrado.nombre ?? '',
          apellido: medicoEncontrado.apellido ?? '',
          rut: medicoEncontrado.rut ?? '',
          especialidad: medicoEncontrado.idespecialidad?.toString(),
          telefono: medicoEncontrado.telefono?.toString(),
          email: medicoEncontrado.email ?? '',
        });

        await this.router.navigate(['/']);
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
