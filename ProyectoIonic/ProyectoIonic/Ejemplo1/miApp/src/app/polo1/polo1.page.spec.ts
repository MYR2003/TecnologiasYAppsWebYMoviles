import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Polo1Page } from './polo1.page';

describe('Polo1Page', () => {
  let component: Polo1Page;
  let fixture: ComponentFixture<Polo1Page>;

  beforeEach(() => {
    fixture = TestBed.createComponent(Polo1Page);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
