import { Component } from '@angular/core';
import { IonContent, IonButton  } from '@ionic/angular/standalone';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';

@Component({
    selector: 'app-martin05',
    templateUrl: 'martin05.page.html',
    styleUrls: ['martin05.page.scss'],
    imports: [IonContent, RouterModule, IonButton ],
})
export class Martin05 {
    constructor(private router: Router) {}

    Anterior() {this.router.navigate(['tabs/martin04']);}
    Siguiente() {this.router.navigate(['tabs/martin06']);}
}