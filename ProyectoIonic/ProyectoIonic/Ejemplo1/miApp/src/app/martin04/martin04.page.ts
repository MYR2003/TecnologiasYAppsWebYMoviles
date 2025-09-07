import { Component } from '@angular/core';
import { IonContent, IonButton } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';

@Component({
    selector: 'app-martin04',
    templateUrl: 'martin04.page.html',
    styleUrls: ['martin04.page.scss'],
    imports: [IonContent, RouterModule, IonButton ],
})
export class Martin04 {
    constructor(private router: Router) {}

    Anterior() {this.router.navigate(['tabs/martin03']);}
    Siguiente() {this.router.navigate(['tabs/martin05']);}
}