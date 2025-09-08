import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Polo5Page } from './polo5.page';

describe('Polo5Page', () => {
  let component: Polo5Page;
  let fixture: ComponentFixture<Polo5Page>;

  beforeEach(() => {
    fixture = TestBed.createComponent(Polo5Page);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
