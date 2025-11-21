import { TestBed } from '@angular/core/testing';

import { TipoExamen } from './tipo-examen';

describe('TipoExamen', () => {
  let service: TipoExamen;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoExamen);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
