import { Component } from '@angular/core';
import { IonContent, IonButton  } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';

@Component({
    selector: 'app-martin06',
    templateUrl: 'martin06.page.html',
    styleUrls: ['martin06.page.scss'],
    imports: [IonContent, RouterModule, IonButton ],
})
export class Martin06 {
    constructor(private router: Router) {}

    Anterior() {this.router.navigate(['tabs/martin05']);}
    Siguiente() {this.router.navigate(['tabs/martin01']);}
}