import { Component } from '@angular/core';
import { IonContent, IonButton, IonButtons, IonIcon, IonHeader, IonToolbar, IonTitle, IonCard, IonCardHeader, IonCardTitle, IonCardContent } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';

@Component({
    selector: 'app-martin01',
    templateUrl: 'martin01.page.html',
    styleUrls: ['martin01.page.scss'],
    imports: [IonContent, RouterModule, IonButton, IonButtons, IonIcon, IonHeader, IonToolbar, IonTitle, IonCard, IonCardHeader, IonCardTitle, IonCardContent],
})
export class Martin01 {
    constructor(private router: Router) {}

    IrAmartin02() {this.router.navigate(['tabs/martin02']);}
    IrAmartin03() {this.router.navigate(['tabs/martin03']);}
    IrAmartin04() {this.router.navigate(['tabs/martin04']);}
    IrAmartin05() {this.router.navigate(['tabs/martin05']);}
    IrAmartin06() {this.router.navigate(['tabs/martin06']);}
}