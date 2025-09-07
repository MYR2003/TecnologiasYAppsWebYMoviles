import { ComponentFixture, TestBed } from "@angular/core/testing";
import { Martin03 } from "./martin03.page";

describe('Martin03', () => {
    let component: Martin03;
    let fixture: ComponentFixture<Martin03>;

    beforeEach(async () => {
        fixture = TestBed.createComponent(Martin03);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    })
})