import { TestBed } from '@angular/core/testing';

import { Sintoma } from './sintoma';

describe('Sintoma', () => {
  let service: Sintoma;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Sintoma);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
