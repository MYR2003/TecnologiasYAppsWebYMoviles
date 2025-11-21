import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

export interface UserSession {
  idpersona: number;
  nombre: string;
  apellido: string;
  rut: string;
  telefono?: string;
  domicilio?: string;
  sistemadesalud?: string;
}

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private readonly STORAGE_KEY = 'pym_user_session';
  private currentUserSubject: BehaviorSubject<UserSession | null>;
  public currentUser$: Observable<UserSession | null>;

  constructor() {
    const storedSession = this.loadSessionFromStorage();
    this.currentUserSubject = new BehaviorSubject<UserSession | null>(storedSession);
    this.currentUser$ = this.currentUserSubject.asObservable();
  }

  public get currentUserValue(): UserSession | null {
    return this.currentUserSubject.value;
  }

  public get isAuthenticated(): boolean {
    return this.currentUserValue !== null;
  }

  public login(user: UserSession): void {
    this.saveSessionToStorage(user);
    this.currentUserSubject.next(user);
  }

  public logout(): void {
    this.clearSessionFromStorage();
    this.currentUserSubject.next(null);
  }

  private loadSessionFromStorage(): UserSession | null {
    try {
      const stored = localStorage.getItem(this.STORAGE_KEY);
      if (!stored) {
        return null;
      }
      return JSON.parse(stored) as UserSession;
    } catch {
      return null;
    }
  }

  private saveSessionToStorage(user: UserSession): void {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(user));
    } catch (error) {
      console.error('Error saving session to storage', error);
    }
  }

  private clearSessionFromStorage(): void {
    try {
      localStorage.removeItem(this.STORAGE_KEY);
    } catch (error) {
      console.error('Error clearing session from storage', error);
    }
  }
}
