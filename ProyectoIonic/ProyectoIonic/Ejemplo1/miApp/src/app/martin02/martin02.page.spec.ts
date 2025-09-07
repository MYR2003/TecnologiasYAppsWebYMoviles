import { ComponentFixture, TestBed } from "@angular/core/testing";
import { Martin02 } from "./martin02.page";

describe('Martin02', () => {
    let component: Martin02;
    let fixture: ComponentFixture<Martin02>;

    beforeEach(async () => {
        fixture = TestBed.createComponent(Martin02);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    })
})