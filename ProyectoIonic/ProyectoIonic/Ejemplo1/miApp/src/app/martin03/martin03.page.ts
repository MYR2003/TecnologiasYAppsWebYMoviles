import { Component } from '@angular/core';
import { IonContent, IonButton } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';

@Component({
    selector: 'app-martin03',
    templateUrl: 'martin03.page.html',
    styleUrls: ['martin03.page.scss'],
    imports: [IonContent, RouterModule, IonButton ],
})
export class Martin03 {
    constructor(private router: Router) {}

    Anterior() {this.router.navigate(['tabs/martin02']);}
    Siguiente() {this.router.navigate(['tabs/martin04']);}
}