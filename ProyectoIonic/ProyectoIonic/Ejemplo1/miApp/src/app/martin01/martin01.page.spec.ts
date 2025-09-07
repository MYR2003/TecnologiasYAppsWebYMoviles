import { ComponentFixture, TestBed } from "@angular/core/testing";
import { Martin01 } from "./martin01.page";

describe('Martin01', () => {
    let component: Martin01;
    let fixture: ComponentFixture<Martin01>;

    beforeEach(async () => {
        fixture = TestBed.createComponent(Martin01);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    })
})