import { TestBed } from '@angular/core/testing';

import { PersonaContacto } from './persona-contacto';

describe('PersonaContacto', () => {
  let service: PersonaContacto;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PersonaContacto);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
