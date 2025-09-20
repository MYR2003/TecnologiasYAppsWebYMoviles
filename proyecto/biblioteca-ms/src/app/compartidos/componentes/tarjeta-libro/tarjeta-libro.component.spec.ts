import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { TarjetaLibroComponent } from './tarjeta-libro.component';

describe('TarjetaLibroComponent', () => {
  let component: TarjetaLibroComponent;
  let fixture: ComponentFixture<TarjetaLibroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      imports: [TarjetaLibroComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(TarjetaLibroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
