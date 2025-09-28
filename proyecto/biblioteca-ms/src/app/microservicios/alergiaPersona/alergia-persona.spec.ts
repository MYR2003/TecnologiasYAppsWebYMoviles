import { TestBed } from '@angular/core/testing';

import { AlergiaPersona } from './alergia-persona';

describe('AlergiaPersona', () => {
  let service: AlergiaPersona;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(AlergiaPersona);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
