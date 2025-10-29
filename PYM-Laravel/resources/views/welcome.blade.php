<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pagina Principal</title>
    <link rel="stylesheet" href="https://unpkg.com/tachyons@4.10.0/css/tachyons.min.css"/>
<style>
    canvas {
        border-radius: 12px;
    }
</style>
</head>
<body>
    <div class="mw6 center pa3 sans-serif">
        <h1 class="mb4">Pagina Principal</h1>

        @auth
            <p>Logged in as {{ auth()->user()->name }} — <a href="{{ route('home') }}">Home</a></p>
            <form method="POST" action="{{ route('logout') }}">
                @csrf
                <button type="submit" class="f6 link dim br2 ph3 pv2 mb2 dib white bg-red">Logout</button>
            </form>
        @else
            <p><a href="{{ route('login') }}">Login</a> • <a href="{{ route('register') }}">Register</a></p>
        @endauth

        <div class="bg-white pa3 br3 shadow-1 mb4">
            <h5 style="text-align:center;">Grafico cantidad de consultas por especialidad medica</h5>
            <canvas id="especialidadesChart" height="150"></canvas>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('especialidadesChart');

        const labels = [
            'Medicina General',
            'Broncopulmonar',
            'Cardiovascular',
            'Odontología',
            'Pediatría'
        ];

        const data = [60, 45, 38, 52, 78]; // Tus valores

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Pacientes por especialidad',
                    data: data,
                    backgroundColor: 'rgba(72, 232, 239, 0.8)',
                    borderColor: 'rgba(72, 232, 239, 1)',
                    borderWidth: 1,
                    borderRadius: 10,
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 20
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    </script>
</body>
</html>
