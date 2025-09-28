import { TestBed } from '@angular/core/testing';

import { FichaMedica } from './ficha-medica';

describe('FichaMedica', () => {
  let service: FichaMedica;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(FichaMedica);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
