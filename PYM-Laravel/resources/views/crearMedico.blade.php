@extends('layouts.app')

@section('title', 'Crear Médico')

@section('body')
<div class="container mt-4">
    <h2>Crear Médico</h2>

    <form action="{{ route('medicos.store') }}" method="POST">
        @csrf

        <div class="mb-3">
            <label class="form-label">Especialidad</label>
            <select name="id_especialidad" class="form-select" required>
                <option value="">Seleccione...</option>
                @foreach($especialidades as $esp)
                    <option value="{{ $esp->id_especialidad }}">
                        {{ $esp->especialidad }}
                    </option>
                @endforeach
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Nombre</label>
            <input type="text" name="nombre" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Apellido</label>
            <input type="text" name="apellido" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Fecha de nacimiento</label>
            <input type="date" name="fecha_nacimiento" class="form-control" required>
        </div>

        <button class="btn btn-primary">Crear</button>
        <a href="{{ route('medicos.index') }}" class="btn btn-secondary">Volver</a>
    </form>
</div>
@endsection
