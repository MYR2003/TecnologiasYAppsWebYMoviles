import { TestBed } from '@angular/core/testing';

import { TipoTratamiento } from './tipo-tratamiento';

describe('TipoTratamiento', () => {
  let service: TipoTratamiento;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TipoTratamiento);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
