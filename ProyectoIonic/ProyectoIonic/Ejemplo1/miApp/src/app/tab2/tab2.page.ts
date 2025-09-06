import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardContent, IonCardHeader, IonCardTitle, IonGrid, IonRow, IonCol, IonButton, IonIcon, IonList, IonItem, IonLabel } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { addIcons } from 'ionicons';
import { refresh, backspace } from 'ionicons/icons';

@Component({
  selector: 'app-tab2',
  templateUrl: 'tab2.page.html',
  styleUrls: ['tab2.page.scss'],
  imports: [CommonModule, IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardContent, IonCardHeader, IonCardTitle, IonGrid, IonRow, IonCol, IonButton, IonIcon, IonList, IonItem, IonLabel]
})
export class Tab2Page {
  display: string = '0';
  previousNumber: string = '';
  operation: string = '';
  waitingForNewNumber: boolean = false;
  history: string[] = [];

  constructor() {
    addIcons({ refresh, backspace });
  }

  inputNumber(num: string) {
    if (this.waitingForNewNumber) {
      this.display = num;
      this.waitingForNewNumber = false;
    } else {
      this.display = this.display === '0' ? num : this.display + num;
    }
  }

  inputDecimal() {
    if (this.waitingForNewNumber) {
      this.display = '0.';
      this.waitingForNewNumber = false;
    } else if (this.display.indexOf('.') === -1) {
      this.display += '.';
    }
  }

  clear() {
    this.display = '0';
    this.previousNumber = '';
    this.operation = '';
    this.waitingForNewNumber = false;
  }

  backspace() {
    if (this.display.length > 1) {
      this.display = this.display.slice(0, -1);
    } else {
      this.display = '0';
    }
  }

  operate(op: string) {
    if (this.previousNumber && this.operation && !this.waitingForNewNumber) {
      this.calculate();
    }
    
    this.previousNumber = this.display;
    this.operation = op;
    this.waitingForNewNumber = true;
  }

  calculate() {
    if (!this.previousNumber || !this.operation) {
      return;
    }

    const prev = parseFloat(this.previousNumber);
    const current = parseFloat(this.display);
    let result: number;

    switch (this.operation) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '*':
        result = prev * current;
        break;
      case '/':
        if (current === 0) {
          this.display = 'Error';
          return;
        }
        result = prev / current;
        break;
      default:
        return;
    }

    // Add to history
    const operation = this.operation === '*' ? '×' : this.operation === '/' ? '÷' : this.operation;
    this.history.push(`${prev} ${operation} ${current} = ${result}`);

    this.display = result.toString();
    this.previousNumber = '';
    this.operation = '';
    this.waitingForNewNumber = true;
  }

  clearHistory() {
    this.history = [];
  }
}
