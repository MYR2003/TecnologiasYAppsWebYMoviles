@extends('layouts.app')
@section('title', 'Dashboards')

@section('body')
<div class="container-flex" style="display: flex; min-height: calc(100vh - 60px);">
    <div class="content flex-grow-1 p-4" style="background-color: #f8f9fa;">
        <h2 class="text-center mb-4">Dashboards</h2>

        <div class="d-flex justify-content-center align-items-center mt-4">
            <div style="width: 600px;">
                <canvas id="barChart"></canvas>
            </div>
        </div>
        
        <div class="container mt-4">
            <h1>Lista de Consultas</h1>    
                <a href="{{ route('consultas.export') }}" class="btn btn-success mb-3">
                    Descargar Excel
                </a>
            
            @if($consultas->count() > 0)
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID Consulta</th>
                            <th>Especialidad</th>
                            <th>Fecha</th>
                            <th>Peso</th>
                            <th>Altura</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($consultas as $consulta)
                        <tr>
                            <td>{{ $consulta->id_consulta }}</td>
                            <td>
                                @if($consulta->especialidad)
                                    {{ $consulta->especialidad }}
                                @else
                                    N/A
                                @endif
                            </td>
                            <td>{{ date('d/m/Y H:i', strtotime($consulta->fecha)) }}</td>
                            <td>
                                @if($consulta->peso)
                                    {{ $consulta->peso }} kg
                                @else
                                    N/A
                                @endif
                            </td>
                            <td>
                                @if($consulta->altura)
                                    {{ $consulta->altura }} m
                                @else
                                    N/A
                                @endif
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            @else
                <div class="alert alert-info">
                    No hay consultas registradas.
                </div>
            @endif
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const ctx = document.getElementById('barChart');
    
    const labels = @json($chartData['labels']);
    const values = @json($chartData['values']);

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Cantidad de consultas por especialidad',
                data: values,
                backgroundColor: 'rgba(72, 232, 241, 0.8)',
                borderColor: 'rgba(72, 232, 241, 1)',
                borderWidth: 1,
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
});
</script>

@endsection