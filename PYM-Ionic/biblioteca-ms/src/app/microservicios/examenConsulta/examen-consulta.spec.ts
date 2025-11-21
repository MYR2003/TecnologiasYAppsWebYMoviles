import { TestBed } from '@angular/core/testing';

import { ExamenConsulta } from './examen-consulta';

describe('ExamenConsulta', () => {
  let service: ExamenConsulta;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ExamenConsulta);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
