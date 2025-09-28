import { TestBed } from '@angular/core/testing';

import { ConsultaTratamiento } from './consulta-tratamiento';

describe('ConsultaTratamiento', () => {
  let service: ConsultaTratamiento;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ConsultaTratamiento);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
