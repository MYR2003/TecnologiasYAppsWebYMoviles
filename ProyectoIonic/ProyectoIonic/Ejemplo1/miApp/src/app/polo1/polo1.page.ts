import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonContent, IonHeader, IonTitle, IonToolbar, IonButton, IonIcon, IonLabel, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonList, IonItem } from '@ionic/angular/standalone';
import { RouterLink, Router } from '@angular/router';

@Component({
  selector: 'app-polo1',
  templateUrl: './polo1.page.html',
  styleUrls: ['./polo1.page.scss'],
  standalone: true,
  imports: [
    IonContent, 
    IonHeader, 
    IonTitle, 
    IonLabel,
    IonToolbar, 
    CommonModule, 
    FormsModule,
    IonButton,
    IonIcon,
    IonCard,
    IonCardHeader,
    IonCardTitle,
    IonCardContent,
    IonList,
    IonItem,
    RouterLink
  ]
})
export class Polo1Page implements OnInit {
  constructor(private router: Router) { }

  ngOnInit() {
  }

  IrApolo2() {
    this.router.navigate(['/tabs/polo2']);
  }

  IrApolo3() {
    this.router.navigate(['/tabs/polo3']);
  }

  IrApolo4() {
    this.router.navigate(['/tabs/polo4']);
  }

  IrApolo5() {
    this.router.navigate(['/tabs/polo5']);
  }

  IrApolo6() {
    this.router.navigate(['/tabs/polo6']);
  }
}