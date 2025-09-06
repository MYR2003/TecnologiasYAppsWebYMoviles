# Mi App Ionic - Calculadora y Tareas

Una aplicación demo de Ionic Framework que demuestra las funcionalidades básicas de desarrollo móvil con Angular.

## 🚀 Características

### 📱 Estructura de la App
- **Navegación por pestañas (tabs)** con 3 secciones principales
- **Navegación entre páginas** con rutas dinámicas
- **Diseño responsive** que se adapta a diferentes dispositivos

### 🏠 Tab 1 - Inicio
- Dashboard de bienvenida con información de la app
- Estadísticas de las funcionalidades disponibles
- Navegación rápida a otras secciones

### 🧮 Tab 2 - Calculadora
- Calculadora completa con operaciones básicas (+, -, ×, ÷)
- Pantalla de visualización clara
- Historial de operaciones realizadas
- Funciones de limpieza y corrección (backspace)

### ✅ Tab 3 - Lista de Tareas
- Crear, editar y eliminar tareas
- Marcar tareas como completadas
- Filtros por estado (todas, pendientes, completadas)
- Estadísticas de progreso
- Persistencia en localStorage
- Tareas de ejemplo incluidas

### ➕ Página Adicional - Suma Simple
- Calculadora básica para sumar dos números
- Interfaz intuitiva con validaciones
- Navegación entre páginas

## 🛠️ Tecnologías Utilizadas

- **Ionic Framework 8.0** - Framework de desarrollo móvil
- **Angular 20.0** - Framework web de TypeScript
- **TypeScript** - Lenguaje de programación
- **Capacitor 7.4** - Runtime nativo para apps híbridas
- **SCSS** - Preprocesador CSS
- **Ionicons** - Librería de iconos

## 📦 Instalación y Ejecución

### Prerrequisitos
- Node.js (versión 18 o superior)
- npm o yarn
- Ionic CLI

### Instalación
```bash
# Instalar dependencias
npm install

# Instalar Ionic CLI globalmente (si no está instalado)
npm install -g @ionic/cli
```

### Ejecutar en desarrollo
```bash
# Servidor de desarrollo
ionic serve
# o
npm start
```

### Compilar para producción
```bash
# Build de producción
ionic build
# o
npm run build
```

### Ejecutar en dispositivos móviles
```bash
# Agregar plataforma iOS
ionic capacitor add ios

# Agregar plataforma Android
ionic capacitor add android

# Sincronizar cambios
ionic capacitor sync

# Abrir en Xcode (iOS)
ionic capacitor open ios

# Abrir en Android Studio
ionic capacitor open android
```

## 📁 Estructura del Proyecto

```
src/
├── app/
│   ├── tab1/                 # Página de inicio
│   ├── tab2/                 # Calculadora
│   ├── tab3/                 # Lista de tareas
│   ├── nombre-pagina/        # Suma simple
│   ├── tabs/                 # Navegación de tabs
│   ├── explore-container/    # Componente auxiliar
│   ├── app.component.*       # Componente raíz
│   └── app.routes.ts         # Configuración de rutas
├── assets/                   # Recursos estáticos
├── environments/             # Configuraciones de entorno
├── theme/                    # Variables de tema
├── global.scss               # Estilos globales
└── index.html               # Página principal
```

## 🎨 Funcionalidades Destacadas

### Calculadora Avanzada
- Operaciones matemáticas básicas
- Validación de divisiones por cero
- Historial de las últimas 5 operaciones
- Interfaz intuitiva tipo calculadora de móvil

### Lista de Tareas Inteligente
- Persistencia de datos en localStorage
- Filtros dinámicos por estado
- Estadísticas en tiempo real
- Gestión completa CRUD (Create, Read, Update, Delete)

### Navegación Fluida
- Rutas configuradas con lazy loading
- Navegación programática con Router
- Botones de navegación intuitivos
- Back button nativo

## 🎯 Propósito Educativo

Esta aplicación está diseñada para:
- Demostrar conceptos básicos de Ionic Framework
- Mostrar la integración entre Ionic y Angular
- Ejemplificar el manejo de estado en componentes
- Enseñar navegación entre páginas
- Demostrar el uso de localStorage
- Mostrar mejores prácticas de UI/UX móvil

## 🤝 Contribución

Este proyecto es perfecto para:
- Estudiantes aprendiendo Ionic/Angular
- Desarrolladores explorando desarrollo móvil híbrido
- Como base para proyectos más complejos

## 📄 Licencia

Proyecto de ejemplo con fines educativos.

---

**Desarrollado con ❤️ usando Ionic Framework**
