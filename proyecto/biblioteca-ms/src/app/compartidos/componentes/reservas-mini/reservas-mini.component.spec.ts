import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { ReservasMiniComponent } from './reservas-mini.component';

describe('ReservasMiniComponent', () => {
  let component: ReservasMiniComponent;
  let fixture: ComponentFixture<ReservasMiniComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      imports: [ReservasMiniComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(ReservasMiniComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
