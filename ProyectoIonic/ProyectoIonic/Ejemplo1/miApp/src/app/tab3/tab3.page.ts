import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonItem, IonLabel, IonInput, IonButton, IonIcon, IonGrid, IonRow, IonCol, IonSegment, IonSegmentButton, IonCheckbox } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { addIcons } from 'ionicons';
import { addCircle, add, trash, documentTextOutline } from 'ionicons/icons';

interface Task {
  id: number;
  text: string;
  completed: boolean;
  createdAt: Date;
}

@Component({
  selector: 'app-tab3',
  templateUrl: 'tab3.page.html',
  styleUrls: ['tab3.page.scss'],
  imports: [CommonModule, FormsModule, IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardTitle, IonCardContent, IonItem, IonLabel, IonInput, IonButton, IonIcon, IonGrid, IonRow, IonCol, IonSegment, IonSegmentButton, IonCheckbox],
})
export class Tab3Page {
  tasks: Task[] = [];
  newTaskText: string = '';
  filter: string = 'all';
  private taskIdCounter: number = 1;

  constructor() {
    addIcons({ addCircle, add, trash, documentTextOutline });
    
    // Load tasks from localStorage
    this.loadTasks();
    
    // Add some sample tasks if none exist
    if (this.tasks.length === 0) {
      this.addSampleTasks();
    }
  }

  addTask() {
    if (this.newTaskText.trim()) {
      const newTask: Task = {
        id: this.taskIdCounter++,
        text: this.newTaskText.trim(),
        completed: false,
        createdAt: new Date()
      };
      
      this.tasks.unshift(newTask); // Add to beginning of array
      this.newTaskText = '';
      this.saveTasks();
    }
  }

  toggleTask(task: Task) {
    task.completed = !task.completed;
    this.saveTasks();
  }

  deleteTask(taskId: number) {
    this.tasks = this.tasks.filter(task => task.id !== taskId);
    this.saveTasks();
  }

  clearCompleted() {
    this.tasks = this.tasks.filter(task => !task.completed);
    this.saveTasks();
  }

  getFilteredTasks(): Task[] {
    switch (this.filter) {
      case 'pending':
        return this.tasks.filter(task => !task.completed);
      case 'completed':
        return this.tasks.filter(task => task.completed);
      default:
        return this.tasks;
    }
  }

  getTotalTasks(): number {
    return this.tasks.length;
  }

  getCompletedTasks(): number {
    return this.tasks.filter(task => task.completed).length;
  }

  getPendingTasks(): number {
    return this.tasks.filter(task => !task.completed).length;
  }

  onFilterChange(event: any) {
    this.filter = event.detail.value;
  }

  trackByTaskId(index: number, task: Task): number {
    return task.id;
  }

  formatDate(date: Date): string {
    return new Date(date).toLocaleDateString('es-ES', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  private addSampleTasks() {
    const sampleTasks = [
      'Aprender Ionic Framework',
      'Completar el tutorial de Angular',
      'Practicar TypeScript',
      'Revisar la documentación de Capacitor'
    ];

    sampleTasks.forEach((taskText, index) => {
      const task: Task = {
        id: this.taskIdCounter++,
        text: taskText,
        completed: index === 0, // Mark first task as completed
        createdAt: new Date(Date.now() - (index * 60000)) // Stagger creation times
      };
      this.tasks.push(task);
    });

    this.saveTasks();
  }

  private saveTasks() {
    try {
      localStorage.setItem('ionic-tasks', JSON.stringify(this.tasks));
    } catch (error) {
      console.warn('Could not save tasks to localStorage');
    }
  }

  private loadTasks() {
    try {
      const saved = localStorage.getItem('ionic-tasks');
      if (saved) {
        this.tasks = JSON.parse(saved);
        // Find the highest ID to continue counting
        if (this.tasks.length > 0) {
          this.taskIdCounter = Math.max(...this.tasks.map(t => t.id)) + 1;
        }
      }
    } catch (error) {
      console.warn('Could not load tasks from localStorage');
      this.tasks = [];
    }
  }
}
