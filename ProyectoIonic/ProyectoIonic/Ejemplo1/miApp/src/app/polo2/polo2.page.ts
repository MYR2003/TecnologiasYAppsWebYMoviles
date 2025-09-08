import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonContent, IonHeader, IonTitle, IonToolbar, IonButton, IonIcon, IonLabel } from '@ionic/angular/standalone';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-polo2',
  templateUrl: './polo2.page.html',
  styleUrls: ['./polo2.page.scss'],
  standalone: true,
  imports: [
    IonContent, 
    IonHeader, 
    IonTitle, 
    IonToolbar, 
    CommonModule, 
    FormsModule,
    IonButton,
    IonIcon,
    IonLabel,
    RouterLink
  ]
})
export class Polo2Page implements OnInit {
  constructor() { }

  ngOnInit() {
  }
}