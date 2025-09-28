import { TestBed } from '@angular/core/testing';

import { ConsultaSintoma } from './consulta-sintoma';

describe('ConsultaSintoma', () => {
  let service: ConsultaSintoma;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ConsultaSintoma);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
