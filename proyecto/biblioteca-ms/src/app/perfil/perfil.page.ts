import { CommonModule, NgFor, NgIf } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { firstValueFrom } from 'rxjs';
import { Alergia } from '../microservicios/alergia/alergia';
import { AlergiaPersona } from '../microservicios/alergiaPersona/alergia-persona';
import { ContactoEmergencia } from '../microservicios/contactoEmergencia/contacto-emergencia';
import { FichaMedica } from '../microservicios/fichaMedica/ficha-medica';
import { Persona } from '../microservicios/persona/persona';
import { PersonaContacto } from '../microservicios/personaContacto/persona-contacto';
import { TranslatePipe } from '../core/i18n/translate.pipe';
import { ExamenAccesoService, SolicitudAcceso } from '../core/servicios/examen-acceso.service';
import { AuthService } from '../core/auth/auth.service';

interface PersonaRecord {
  idpersona: number;
  nombre: string;
  apellido: string;
  rut: string;
  fechanacimiento?: string;
  sistemadesalud?: string;
  domicilio?: string;
  telefono?: string;
}

interface ContactoDetalle {
  idcontacto: number;
  nombre: string;
  apellido?: string;
  rut?: string;
  telefono?: string;
  direccion?: string;
  relacion?: string;
  esPrincipal: boolean;
}

interface FichaMedicaRecord {
  idfichamedica: number;
  altura?: number;
  peso?: number;
  presion?: number;
}

interface Beneficio {
  dia: string;
  nombreLocal: string;
  tipoLocal: string;
  descuento: string;
  descripcion: string;
  direccion: string;
  telefono: string;
  horario: string;
  icono: string;
}

@Component({
  selector: 'app-perfil',
  standalone: true,
  imports: [CommonModule, IonicModule, NgIf, NgFor, TranslatePipe, RouterLink],
  templateUrl: './perfil.page.html',
  styleUrls: ['./perfil.page.scss'],
})
export class PerfilPage implements OnInit {
  loading = true;
  error: string | null = null;

  persona?: PersonaRecord;
  contactoPrincipal?: ContactoDetalle;
  contactosSecundarios: ContactoDetalle[] = [];
  alergias: string[] = [];
  fichaMedica?: FichaMedicaRecord;
  
  // Nuevas propiedades para solicitudes de acceso
  solicitudesPendientes: SolicitudAcceso[] = [];
  loadingSolicitudes = false;

  // Propiedades para beneficios
  beneficios: Beneficio[] = [];
  beneficioSeleccionado: Beneficio | null = null;
  mostrarDetalleBeneficio = false;

  constructor(
    private readonly personaService: Persona,
    private readonly personaContactoService: PersonaContacto,
    private readonly contactoEmergenciaService: ContactoEmergencia,
    private readonly alergiaPersonaService: AlergiaPersona,
    private readonly alergiaService: Alergia,
    private readonly fichaMedicaService: FichaMedica,
    private readonly route: ActivatedRoute,
    private readonly examenAccesoService: ExamenAccesoService,
    private readonly authService: AuthService,
    private readonly router: Router,
  ) {}

  async ngOnInit(): Promise<void> {
    await this.loadProfile();
    await this.cargarSolicitudesPendientes();
    this.inicializarBeneficios();
  }

  get personaIniciales(): string {
    if (!this.persona) {
      return '';
    }
    const nombre = this.persona.nombre?.trim()?.charAt(0) ?? '';
    const apellido = this.persona.apellido?.trim()?.charAt(0) ?? '';
    return (nombre + apellido).toUpperCase();
  }

  get edadPersona(): number | null {
    const fecha = this.persona?.fechanacimiento;
    if (!fecha) {
      return null;
    }
    return this.calcularEdad(fecha);
  }

  get rutaEditarPerfil(): string {
    return '/registrar-persona';
  }

  private async loadProfile(): Promise<void> {
    this.loading = true;
    this.error = null;
    try {
      // Obtener el usuario autenticado
      const currentUser = this.authService.currentUserValue;
      if (!currentUser) {
        this.error = 'profile.messages.noAuth';
        await this.router.navigate(['/login']);
        return;
      }

      const personas = await this.personaService.getPersona();
      if (!personas || personas.length === 0) {
        this.error = 'profile.messages.noPerson';
        return;
      }

      // Buscar la persona por el ID del usuario autenticado
      const persona = personas.find((p) => Number(p.idpersona) === currentUser.idpersona);
      if (!persona) {
        this.error = 'profile.messages.personNotFound';
        return;
      }
      
      this.persona = persona;

      const [personaContactos, contactosEmergencia, alergiasPersona, alergiasCatalogo, fichas] = await Promise.all([
        this.personaContactoService.getPersonaContacto(),
        this.contactoEmergenciaService.getContactoEmergencia(),
        this.alergiaPersonaService.getAlergiaPersona(),
        this.alergiaService.getAlergia(),
        this.fichaMedicaService.getFichaMedica(),
      ]);

      this.prepararContactos(personaContactos ?? [], contactosEmergencia ?? []);
      this.prepararAlergias(alergiasPersona ?? [], alergiasCatalogo ?? []);
      this.prepararFichaMedica(fichas ?? []);
    } catch (err) {
      console.error('Error al cargar el perfil del paciente', err);
      this.error = 'profile.messages.genericError';
    } finally {
      this.loading = false;
    }
  }

  private prepararContactos(relaciones: any[], contactos: any[]): void {
    if (!this.persona) {
      return;
    }
    const relacionados = relaciones
      .filter((rel) => Number(rel.idpersona) === Number(this.persona?.idpersona))
      .map<ContactoDetalle>((rel) => {
        const detalle = contactos.find((c) => Number(c.idcontacto) === Number(rel.idcontacto));
        return {
          idcontacto: Number(rel.idcontacto),
          nombre: detalle?.nombre ?? 'Contacto',
          apellido: detalle?.apellido,
          rut: detalle?.rut ?? undefined,
          telefono: detalle?.telefono ?? undefined,
          direccion: detalle?.direccion ?? undefined,
          relacion: rel.relacion ?? undefined,
          esPrincipal: Boolean(rel.esprincipal),
        };
      })
      .sort((a, b) => (a.esPrincipal === b.esPrincipal ? 0 : a.esPrincipal ? -1 : 1));

    this.contactoPrincipal = relacionados[0];
    this.contactosSecundarios = relacionados.slice(1);
  }

  private prepararAlergias(alergiasPersona: any[], alergiasCatalogo: any[]): void {
    if (!this.persona) {
      this.alergias = [];
      return;
    }
    const ids = new Set(
      alergiasPersona
        .filter((item) => Number(item.idpersona) === Number(this.persona?.idpersona))
        .map((item) => Number(item.idalergia))
    );
    this.alergias = Array.from(ids)
      .map((id) => alergiasCatalogo.find((alergia) => Number(alergia.idalergia) === id)?.alergia)
      .filter((nombre): nombre is string => Boolean(nombre))
      .map((nombre) => this.normalizarTexto(nombre) ?? nombre);
  }

  private prepararFichaMedica(fichas: any[]): void {
    if (!this.persona) {
      this.fichaMedica = undefined;
      return;
    }

    if (fichas.length === 0) {
      this.fichaMedica = undefined;
      return;
    }

    const personaId = Number(this.persona.idpersona);
    const ficha = fichas.find((f) => Number(f.idpersona) === personaId);
    
    if (ficha) {
      this.fichaMedica = {
        idfichamedica: Number(ficha.idfichamedica),
        altura: ficha.altura !== undefined ? Number(ficha.altura) : undefined,
        peso: ficha.peso !== undefined ? Number(ficha.peso) : undefined,
        presion: ficha.presion !== undefined ? Number(ficha.presion) : undefined,
      };
    } else {
      this.fichaMedica = undefined;
    }
  }

  private calcularEdad(fecha: string | Date): number {
    const nacimiento = new Date(fecha);
    const hoy = new Date();
    let edad = hoy.getFullYear() - nacimiento.getFullYear();
    const mes = hoy.getMonth() - nacimiento.getMonth();
    if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
      edad--;
    }
    return edad;
  }

  private normalizarTexto(texto: string | null | undefined): string | undefined {
    if (!texto) {
      return undefined;
    }
    return texto
      .replace(/ÃƒÂ³|Ã³/g, 'ó')
      .replace(/ÃƒÂ¡|Ã¡/g, 'á')
      .replace(/ÃƒÂ©|Ã©/g, 'é')
      .replace(/ÃƒÂ­|Ã­/g, 'í')
      .replace(/ÃƒÂº|Ãº/g, 'ú')
      .replace(/ÃƒÂ±|Ã±/g, 'ñ')
      .replace(/ÃƒÂ/g, 'Á')
      .replace(/Ã‰/g, 'É')
      .replace(/Ãš/g, 'Ú');
  }

  // Nuevos métodos para manejo de solicitudes
  async cargarSolicitudesPendientes(): Promise<void> {
    if (!this.persona) return;
    
    this.loadingSolicitudes = true;
    try {
      this.solicitudesPendientes = await firstValueFrom(
        this.examenAccesoService.getSolicitudesPendientesPaciente(this.persona.idpersona)
      );
    } catch (error) {
      console.error('Error al cargar solicitudes pendientes', error);
    } finally {
      this.loadingSolicitudes = false;
    }
  }

  async responderSolicitud(solicitud: SolicitudAcceso, estado: 'aprobado' | 'rechazado'): Promise<void> {
    this.loadingSolicitudes = true;
    try {
      await firstValueFrom(
        this.examenAccesoService.responderSolicitud(solicitud.id, estado)
      );
      
      // Eliminar de la lista de pendientes
      this.solicitudesPendientes = this.solicitudesPendientes.filter(s => s.id !== solicitud.id);
    } catch (error) {
      console.error('Error al responder solicitud', error);
      this.error = 'Error al procesar la solicitud';
    } finally {
      this.loadingSolicitudes = false;
    }
  }

  getNombreSolicitante(solicitud: SolicitudAcceso): string {
    return `${solicitud.solicitante_nombre || ''} ${solicitud.solicitante_apellido || ''}`.trim();
  }

  async cerrarSesion(): Promise<void> {
    // Limpiar completamente la sesión
    this.authService.logout();
    
    // Limpiar todos los datos del componente
    this.persona = undefined;
    this.contactoPrincipal = undefined;
    this.contactosSecundarios = [];
    this.alergias = [];
    this.fichaMedica = undefined;
    this.solicitudesPendientes = [];
    
    // Navegar al login
    await this.router.navigate(['/login'], { replaceUrl: true });
  }

  inicializarBeneficios(): void {
    this.beneficios = [
      {
        dia: 'Lunes',
        nombreLocal: 'Farmacia SaludPlus',
        tipoLocal: 'Farmacia',
        descuento: '20% de descuento',
        descripcion: 'Obtén un 20% de descuento en todos los medicamentos genéricos y productos de cuidado personal. Válido presentando tu credencial de paciente.',
        direccion: 'Av. Principal 1234, Centro',
        telefono: '+56 2 2345 6789',
        horario: 'Lunes a Viernes: 8:00 - 20:00, Sábados: 9:00 - 14:00',
        icono: 'medical'
      },
      {
        dia: 'Martes',
        nombreLocal: 'Óptica VisiónClara',
        tipoLocal: 'Óptica',
        descuento: '15% de descuento',
        descripcion: 'Descuento del 15% en lentes recetados, monturas de marca y exámenes de vista. Incluye servicio de ajuste gratuito.',
        direccion: 'Calle Comercio 567, Local 12',
        telefono: '+56 2 3456 7890',
        horario: 'Lunes a Sábado: 10:00 - 19:00',
        icono: 'eye'
      },
      {
        dia: 'Miércoles',
        nombreLocal: 'Centro de Kinesiología MoviBien',
        tipoLocal: 'Centro de Rehabilitación',
        descuento: '25% de descuento',
        descripcion: 'Obtén 25% de descuento en sesiones de kinesiología, fisioterapia y rehabilitación física. Profesionales certificados con equipamiento moderno.',
        direccion: 'Av. Salud 890, Piso 3',
        telefono: '+56 2 4567 8901',
        horario: 'Lunes a Viernes: 8:00 - 19:00, Sábados: 9:00 - 13:00',
        icono: 'fitness'
      },
      {
        dia: 'Jueves',
        nombreLocal: 'Laboratorio Clínico AnálisisTotal',
        tipoLocal: 'Laboratorio Clínico',
        descuento: '30% de descuento',
        descripcion: 'Descuento del 30% en exámenes de sangre, orina y otros análisis clínicos. Resultados en 24 horas. Sin necesidad de hora previa.',
        direccion: 'Pasaje Los Médicos 234',
        telefono: '+56 2 5678 9012',
        horario: 'Lunes a Viernes: 7:00 - 18:00, Sábados: 8:00 - 12:00',
        icono: 'flask'
      },
      {
        dia: 'Viernes',
        nombreLocal: 'Nutrición y Bienestar NutriVida',
        tipoLocal: 'Centro de Nutrición',
        descuento: '20% de descuento',
        descripcion: 'Ahorra 20% en consultas nutricionales, planes alimenticios personalizados y seguimiento mensual con nutricionistas certificados.',
        direccion: 'Calle Saludable 456, Oficina 201',
        telefono: '+56 2 6789 0123',
        horario: 'Lunes a Viernes: 9:00 - 18:00',
        icono: 'nutrition'
      },
      {
        dia: 'Sábado',
        nombreLocal: 'Gimnasio FitSalud',
        tipoLocal: 'Gimnasio',
        descuento: '35% de descuento',
        descripcion: 'Obtén 35% de descuento en membresías mensuales y trimestrales. Incluye acceso a clases grupales, máquinas cardiovasculares y zona de pesas.',
        direccion: 'Av. Deportiva 789, Segundo Piso',
        telefono: '+56 2 7890 1234',
        horario: 'Lunes a Viernes: 6:00 - 22:00, Sábados y Domingos: 8:00 - 20:00',
        icono: 'barbell'
      },
      {
        dia: 'Domingo',
        nombreLocal: 'Centro de Masajes RelaxMed',
        tipoLocal: 'Centro de Terapias',
        descuento: '25% de descuento',
        descripcion: 'Disfruta de un 25% de descuento en masajes terapéuticos, descontracturantes y relajantes. Terapeutas profesionales en un ambiente tranquilo.',
        direccion: 'Plaza Bienestar 321, Local 5',
        telefono: '+56 2 8901 2345',
        horario: 'Todos los días: 10:00 - 20:00',
        icono: 'hand-left'
      }
    ];
  }

  verDetalleBeneficio(beneficio: Beneficio): void {
    this.beneficioSeleccionado = beneficio;
    this.mostrarDetalleBeneficio = true;
  }

  cerrarDetalleBeneficio(): void {
    this.mostrarDetalleBeneficio = false;
    this.beneficioSeleccionado = null;
  }
}
