import { ComponentFixture, TestBed } from "@angular/core/testing";
import { Martin06 } from "./martin06.page";

describe('Martin06', () => {
    let component: Martin06;
    let fixture: ComponentFixture<Martin06>;

    beforeEach(async () => {
        fixture = TestBed.createComponent(Martin06);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    })
})