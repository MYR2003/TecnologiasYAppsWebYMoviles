<!-- resources/views/welcome.blade.php -->
@extends('layouts.app')
@section('title', 'Dashboard')

@section('body')
<div class="text-center mt-5">
    <h1><strong>PYM Investigaciones</strong></h1>
    <h3>Bienvenido Investigador {{ Auth::user()->name ?? 'Invitado' }}</h3>

    <div class="mt-5">
        <h5>Tiempo de uso de la aplicación durante la semana</h5>
        <canvas id="usageChart" width="400" height="150" style="margin-left: 300px; margin-right: 300px"></canvas>
    </div>
</div>

<script>
const ctx = document.getElementById('usageChart');
new Chart(ctx, {
    type: 'line',
    data: {
        labels: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'],
        datasets: [{
            label: 'Tiempo de uso',
            data: [4, 3, 2, 5, 1],
            borderColor: 'rgba(0, 255, 255, 0.8)',
            backgroundColor: 'rgba(0, 255, 255, 0.3)',
            fill: true,
            tension: 0.4,
            pointStyle: 'circle',
            pointRadius: 5,
        }]
    },
});
</script>
@endsection
