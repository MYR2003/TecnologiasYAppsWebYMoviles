@extends('layouts.app')
@section('title', 'Dashboards')

@section('body')
<div class="container-flex" style="display: flex; min-height: calc(100vh - 60px);">

    <div class="sidebar bg-light border-end p-3" style="width: 220px;">
        <h6><strong>Todas las enfermedades</strong></h6>
        <ul class="list-unstyled mt-3">
            <li class="mb-2"><a href="#" class="text-decoration-none text-dark">Enfermedades cardíacas</a></li>
            <li class="mb-2"><a href="#" class="text-decoration-none text-dark">Enfermedades pulmonares</a></li>
            <li><a href="#" class="text-decoration-none text-dark">Enfermedades comunes</a></li>
        </ul>
    </div>

    <div class="content flex-grow-1 p-4" style="background-color: #f8f9fa;">
        <h2 class="text-center mb-4">Dashboards</h2>

        <div class="d-flex justify-content-center align-items-center mt-4">
            <div style="width: 600px;">
                <canvas id="barChart"></canvas>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener('DOMContentLoaded', async function () {
    const ctx = document.getElementById('barChart');

    try {
        const response = await fetch('/api/consultasCount');
        //const response = await fetch('/dashboardsData');
        const data = await response.json();

        const labels = data.map(item => item.especialidad);
        const values = data.map(item => parseInt(item.count));

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Cantidad de pacientes',
                    data: values,
                    backgroundColor: 'rgba(72, 232, 241, 0.8)',
                    borderColor: 'rgba(72, 232, 241, 1)',
                    borderWidth: 1,
                    borderRadius: 8
                }]
            },
        });

    } catch (error) {
        console.error('Error al cargar los datos del microservicio:', error);
    }
});
</script>

@endsection
