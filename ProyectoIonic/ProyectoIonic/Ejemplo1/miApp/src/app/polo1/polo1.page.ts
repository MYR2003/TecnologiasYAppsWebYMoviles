import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonContent, IonHeader, IonTitle, IonToolbar, IonButton, IonIcon, IonLabel } from '@ionic/angular/standalone';
import { RouterLink } from '@angular/router';

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
    RouterLink
  ]
})
export class Polo1Page implements OnInit {
  constructor() { }

  ngOnInit() {
  }
}