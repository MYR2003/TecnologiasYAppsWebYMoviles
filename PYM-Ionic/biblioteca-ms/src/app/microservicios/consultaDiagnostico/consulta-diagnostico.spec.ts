import { TestBed } from '@angular/core/testing';

import { ConsultaDiagnostico } from './consulta-diagnostico';

describe('ConsultaDiagnostico', () => {
  let service: ConsultaDiagnostico;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ConsultaDiagnostico);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
