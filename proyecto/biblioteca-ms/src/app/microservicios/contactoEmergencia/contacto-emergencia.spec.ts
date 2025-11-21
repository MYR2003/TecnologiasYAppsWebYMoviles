import { TestBed } from '@angular/core/testing';

import { ContactoEmergencia } from './contacto-emergencia';

describe('ContactoEmergencia', () => {
  let service: ContactoEmergencia;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ContactoEmergencia);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
