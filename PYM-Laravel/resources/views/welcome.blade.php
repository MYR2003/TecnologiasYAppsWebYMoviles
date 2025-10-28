<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Users</title>
    <link rel="stylesheet" href="https://unpkg.com/tachyons@4.10.0/css/tachyons.min.css"/>
</head>
<body>
    <div class="mw6 center pa3 sans-serif">
        <h1 class="mb4">Users</h1>

        @auth
            <p>Logged in as {{ auth()->user()->name }} — <a href="{{ route('home') }}">Home</a></p>
            <form method="POST" action="{{ route('logout') }}">
                @csrf
                <button type="submit" class="f6 link dim br2 ph3 pv2 mb2 dib white bg-red">Logout</button>
            </form>
        @else
            <p><a href="{{ route('login') }}">Login</a> • <a href="{{ route('register') }}">Register</a></p>
        @endauth

        @foreach($users as $user)
            <div class="pa2 mb3 striped--near-white">
                <header class="b mb2">{{ $user->name }}</header>
                <div class="pl2">
                    <p class="mb2">id: {{ $user->id }}</p>
                </div>
            </div>
        @endforeach
    </div>
</body>
</html>
