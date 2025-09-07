import { Component } from '@angular/core';
import { IonContent, IonCard, IonCardContent, IonIcon } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';

@Component({
    selector: 'app-martin02',
    templateUrl: 'martin02.page.html',
    styleUrls: ['martin02.page.scss'],
    imports: [IonContent, IonCard, IonCardContent, IonIcon, RouterModule],
})
export class Martin02 {
    constructor(private router: Router) {}

    funcion() {
        this.router.navigate(['tabs/martin02']);
    }
}