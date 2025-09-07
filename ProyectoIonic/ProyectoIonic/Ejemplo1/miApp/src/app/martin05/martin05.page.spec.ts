import { ComponentFixture, TestBed } from "@angular/core/testing";
import { Martin05 } from "./martin05.page";

describe('Martin05', () => {
    let component: Martin05;
    let fixture: ComponentFixture<Martin05>;

    beforeEach(async () => {
        fixture = TestBed.createComponent(Martin05);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    })
})