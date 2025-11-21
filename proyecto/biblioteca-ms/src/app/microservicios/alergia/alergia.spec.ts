import { TestBed } from '@angular/core/testing';

import { Alergia } from './alergia';

describe('Alergia', () => {
  let service: Alergia;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Alergia);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
