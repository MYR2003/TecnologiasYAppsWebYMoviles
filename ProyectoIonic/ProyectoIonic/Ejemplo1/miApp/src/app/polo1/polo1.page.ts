import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { 
  IonContent, 
  IonHeader, 
  IonTitle, 
  IonToolbar, 
  IonButton, 
  IonIcon, 
  IonLabel, 
  IonCard, 
  IonCardHeader, 
  IonCardTitle, 
  IonCardContent,
  IonButtons,
  IonBadge,
  IonChip
} from '@ionic/angular/standalone';
import { Router } from '@angular/router';

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
    IonButtons,
    IonBadge,
    IonIcon,
    IonCard,
    IonCardHeader,
    IonCardTitle,
    IonCardContent,
    IonChip
  ]
})
export class Polo1Page implements OnInit {
  // Properties for the template
  notificationCount = 3;
  lastUpdate = new Date().toLocaleTimeString();

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

  verReportesAdmin() {
    // Navigate to admin reports or show reports modal
    console.log('Viewing admin reports...');
  }
}