import { CommonModule, NgFor, NgIf } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { firstValueFrom } from 'rxjs';
import { Alergia } from '../microservicios/alergia/alergia';
import { AlergiaPersona } from '../microservicios/alergiaPersona/alergia-persona';
import { ContactoEmergencia } from '../microservicios/contactoEmergencia/contacto-emergencia';
import { Consulta } from '../microservicios/consulta/consulta';
import { FichaMedica } from '../microservicios/fichaMedica/ficha-medica';
import { Persona } from '../microservicios/persona/persona';
import { PersonaContacto } from '../microservicios/personaContacto/persona-contacto';
import { TranslatePipe } from '../core/i18n/translate.pipe';

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

interface ConsultaResumen {
  idconsulta: number;
  fecha: string;
  motivo?: string;
  observaciones?: string;
  duracionminutos?: number;
}

interface FichaMedicaRecord {
  idfichamedica: number;
  altura?: number;
  peso?: number;
  presion?: number;
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
  consultasRecientes: ConsultaResumen[] = [];
  totalConsultas = 0;
  ultimaConsulta?: ConsultaResumen;

  constructor(
    private readonly personaService: Persona,
    private readonly personaContactoService: PersonaContacto,
    private readonly contactoEmergenciaService: ContactoEmergencia,
    private readonly alergiaPersonaService: AlergiaPersona,
    private readonly alergiaService: Alergia,
    private readonly fichaMedicaService: FichaMedica,
  private readonly consultaService: Consulta,
  private readonly route: ActivatedRoute,
  ) {}

  async ngOnInit(): Promise<void> {
    await this.loadProfile();
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
      const personas = await this.personaService.getPersona();
      if (!personas || personas.length === 0) {
        this.error = 'profile.messages.noPerson';
        return;
      }

      const routeId = Number(this.route.snapshot.paramMap.get('id'));
      const persona = personas.find((p) => Number(p.idpersona) === routeId) ?? personas[0];
      this.persona = persona;

      const [personaContactos, contactosEmergencia, alergiasPersona, alergiasCatalogo, fichas, consultaResponse] = await Promise.all([
        this.personaContactoService.getPersonaContacto(),
        this.contactoEmergenciaService.getContactoEmergencia(),
        this.alergiaPersonaService.getAlergiaPersona(),
        this.alergiaService.getAlergia(),
        this.fichaMedicaService.getFichaMedica(),
        firstValueFrom(this.consultaService.getConsulta(200, 0)),
      ]);

      this.prepararContactos(personaContactos ?? [], contactosEmergencia ?? []);
      this.prepararAlergias(alergiasPersona ?? [], alergiasCatalogo ?? []);
      this.prepararConsultas((consultaResponse?.data ?? []), fichas ?? []);
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

  private prepararConsultas(consultas: any[], fichas: any[]): void {
    if (!this.persona) {
      return;
    }
    const personaId = Number(this.persona.idpersona);
    const propias = consultas
      .filter((consulta) => Number(consulta.idpersona) === personaId)
      .map<ConsultaResumen>((consulta) => ({
        idconsulta: Number(consulta.idconsulta),
        fecha: consulta.fecha,
        motivo: this.normalizarTexto(consulta.motivo),
        observaciones: this.normalizarTexto(consulta.observaciones),
        duracionminutos: consulta.duracionminutos !== undefined ? Number(consulta.duracionminutos) : undefined,
      }))
      .sort((a, b) => new Date(b.fecha).getTime() - new Date(a.fecha).getTime());

    this.totalConsultas = propias.length;
    this.consultasRecientes = propias.slice(0, 3);
    this.ultimaConsulta = propias[0];

    if (consultas.length === 0) {
      this.fichaMedica = undefined;
      return;
    }

    const consultaConFicha = consultas.find((consulta) => Number(consulta.idpersona) === personaId && consulta.idfichamedica);
    if (!consultaConFicha) {
      this.fichaMedica = undefined;
      return;
    }

    const ficha = fichas.find((registro) => Number(registro.idfichamedica) === Number(consultaConFicha.idfichamedica));
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
}
