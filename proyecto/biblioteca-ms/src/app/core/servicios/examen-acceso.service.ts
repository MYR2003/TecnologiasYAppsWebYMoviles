import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface SolicitudAcceso {
  id: number;
  examen_id: number;
  usuario_solicitante_id: number;
  estado: 'pendiente' | 'aprobado' | 'rechazado';
  fecha_solicitud: string;
  fecha_respuesta?: string;
  solicitante_nombre?: string;
  solicitante_apellido?: string;
  nombre_examen?: string;
  idexamen?: number;
  fecha_subida?: string;
}

@Injectable({ providedIn: 'root' })
export class ExamenAccesoService {
  private apiUrl = 'http://localhost:3057';

  constructor(private http: HttpClient) {}

  // Obtener solicitudes pendientes para un paciente
  getSolicitudesPendientesPaciente(idPaciente: number): Observable<SolicitudAcceso[]> {
    return this.http.get<SolicitudAcceso[]>(`${this.apiUrl}/paciente/${idPaciente}/pendientes`);
  }

  // Aprobar o rechazar una solicitud
  responderSolicitud(id: number, estado: 'aprobado' | 'rechazado'): Observable<SolicitudAcceso> {
    return this.http.put<SolicitudAcceso>(`${this.apiUrl}/${id}`, { estado });
  }

  // Solicitar acceso a un examen (usado por mÃ©dico)
  solicitarAcceso(examenId: number, medicoId: number): Observable<SolicitudAcceso> {
    return this.http.post<SolicitudAcceso>(this.apiUrl, {
      examen_id: examenId,
      usuario_solicitante_id: medicoId
    });
  }

  // Verificar estado de solicitud
  verificarEstadoSolicitud(examenId: number, medicoId: number): Observable<{estado: string, solicitud: SolicitudAcceso | null}> {
    return this.http.get<{estado: string, solicitud: SolicitudAcceso | null}>(
      `${this.apiUrl}/estado/${examenId}/${medicoId}`
    );
  }

  // Verificar si tiene acceso aprobado
  verificarAcceso(examenId: number, medicoId: number): Observable<{tieneAcceso: boolean, acceso: SolicitudAcceso | null}> {
    return this.http.get<{tieneAcceso: boolean, acceso: SolicitudAcceso | null}>(
      `${this.apiUrl}/verificar/${examenId}/${medicoId}`
    );
  }

  // Obtener solicitudes de un mÃ©dico
  getSolicitudesMedico(idMedico: number): Observable<SolicitudAcceso[]> {
    return this.http.get<SolicitudAcceso[]>(`${this.apiUrl}/medico/${idMedico}`);
  }
}

