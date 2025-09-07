import { ComponentFixture, TestBed } from "@angular/core/testing";
import { Martin04 } from "./martin04.page";

describe('Martin04', () => {
    let component: Martin04;
    let fixture: ComponentFixture<Martin04>;

    beforeEach(async () => {
        fixture = TestBed.createComponent(Martin04);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    })
})