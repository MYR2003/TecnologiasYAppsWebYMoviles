<!-- resources/views/welcome.blade.php -->
@extends('layouts.app')
@section('title', 'Dashboard')

@section('body')
<div class="text-center mt-5">
    <h1><strong>PYM Investigaciones</strong></h1>
    <h3>Bienvenido Investigador {{ Auth::user()->name ?? 'Invitado' }}</h3>
</div>
@endsection
