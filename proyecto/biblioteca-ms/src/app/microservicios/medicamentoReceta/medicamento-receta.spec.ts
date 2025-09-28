import { TestBed } from '@angular/core/testing';

import { MedicamentoReceta } from './medicamento-receta';

describe('MedicamentoReceta', () => {
  let service: MedicamentoReceta;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MedicamentoReceta);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
