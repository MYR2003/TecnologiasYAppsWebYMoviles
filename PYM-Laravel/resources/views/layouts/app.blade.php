<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title') - PYM Investigaciones</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-..." crossorigin="anonymous"></script>


    <style>
        body { background: #f8f9fa; font-family: Arial, sans-serif; }
        header {
            background: #000;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header a { color: white; margin-right: 1.5rem; text-decoration: none; }
        header a.active { font-weight: bold; }
        .sidebar {
            width: 250px;
            background: #fff;
            padding: 1rem;
            border-right: 1px solid #ccc;
            height: calc(100vh - 60px);
        }
        .content {
            padding: 2rem;
            flex: 1;
        }
        .container-flex {
            display: flex;
        }
    </style>
</head>
<body>
    <header>
        <div>
            <a href="{{ route('home') }}" class="{{ request()->routeIs('home') ? 'active' : '' }}">Home</a>
            <a href="{{ route('dashboard') }}" class="{{ request()->routeIs('dashboard') ? 'active' : '' }}">Dashboards</a>
        </div>
        <div>
            <span>{{ Auth::user()->name ?? 'Invitado' }}</span>
            @auth
                <form action="{{ route('logout') }}" method="POST" class="d-inline">
                    @csrf
                    <button type="submit" class="btn btn-sm btn-light">Salir</button>
                </form>
            @endauth
        </div>
    </header>

    <div class="container-flex">
    @include('components.sidebar')

    <div class="content">
        @yield('body')
    </div>
</div>

</body>
</html>
