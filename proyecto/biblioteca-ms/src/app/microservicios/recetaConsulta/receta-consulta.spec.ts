import { TestBed } from '@angular/core/testing';

import { RecetaConsulta } from './receta-consulta';

describe('RecetaConsulta', () => {
  let service: RecetaConsulta;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(RecetaConsulta);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
