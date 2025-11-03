import { DOCUMENT } from '@angular/common';
import { Inject, Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import {
  DEFAULT_LANGUAGE,
  LanguageCode,
  LanguageOption,
  RTL_LANGUAGES,
  SUPPORTED_LANGUAGES,
  TRANSLATIONS,
  TranslationValue,
} from './translations';

@Injectable({ providedIn: 'root' })
export class TranslationService {
  private readonly STORAGE_KEY = 'app:language';
  private readonly language$ = new BehaviorSubject<LanguageCode>(DEFAULT_LANGUAGE);

  readonly languageChanges$ = this.language$.asObservable();

  constructor(@Inject(DOCUMENT) private readonly documentRef: Document) {
    const stored = (typeof window !== 'undefined') ? window.localStorage.getItem(this.STORAGE_KEY) as LanguageCode | null : null;
    const initial = stored && TRANSLATIONS[stored] ? stored : DEFAULT_LANGUAGE;
    this.applyLanguage(initial, false);
  }

  get currentLanguage(): LanguageCode {
    return this.language$.value;
  }

  getSupportedLanguages(): LanguageOption[] {
    return [...SUPPORTED_LANGUAGES];
  }

  setLanguage(language: LanguageCode, persist = true): void {
    if (!TRANSLATIONS[language]) {
      language = DEFAULT_LANGUAGE;
    }
    this.applyLanguage(language, persist);
  }

  resetLanguage(): void {
    this.applyLanguage(DEFAULT_LANGUAGE, true);
  }

  translate(key: string, params?: Record<string, unknown>): string {
    const value = this.resolveValue(this.currentLanguage, key);
    const text = Array.isArray(value) ? value.join(', ') : value;
    return this.interpolate(text, params);
  }

  translateList(key: string): string[] {
    const value = this.resolveValue(this.currentLanguage, key);
    if (Array.isArray(value)) {
      return value.slice();
    }
    return [this.interpolate(value, undefined)];
  }

  private applyLanguage(language: LanguageCode, persist: boolean): void {
    this.language$.next(language);
    const docEl = this.documentRef.documentElement;
    docEl.setAttribute('lang', language);
    docEl.setAttribute('dir', RTL_LANGUAGES.has(language) ? 'rtl' : 'ltr');
    if (persist && typeof window !== 'undefined') {
      window.localStorage.setItem(this.STORAGE_KEY, language);
    }
  }

  private resolveValue(language: LanguageCode, key: string): TranslationValue {
    const dictionary = TRANSLATIONS[language] ?? TRANSLATIONS[DEFAULT_LANGUAGE];
    const fallbackDictionary = TRANSLATIONS[DEFAULT_LANGUAGE];
    const value = dictionary[key] ?? fallbackDictionary[key];
    if (!value) {
      return key;
    }
    return value;
  }

  private interpolate(template: string, params?: Record<string, unknown>): string {
    if (!params) {
      return template;
    }
    return template.replace(/\{\{\s*(\w+)\s*\}\}/g, (_match, key) => {
      const value = params[key];
      return value !== undefined && value !== null ? String(value) : '';
    });
  }
}
