import { TestBed } from '@angular/core/testing';

import { TipoDiagnostico } from './tipo-diagnostico';

describe('TipoDiagnostico', () => {
  let service: TipoDiagnostico;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoDiagnostico);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
