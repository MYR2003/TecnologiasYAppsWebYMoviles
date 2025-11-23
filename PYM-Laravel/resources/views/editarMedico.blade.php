@extends('layouts.app')

@section('title', 'Editar Médico')

@section('body')
<div class="container mt-4">
    <h2>Editar Médico</h2>

    <form action="{{ route('medicos.update', $medico->id_medico) }}" method="POST">
        @csrf
        @method('PUT')

        <div class="mb-3">
            <label class="form-label">Especialidad</label>
            <select name="id_especialidad" class="form-select" required>
                @foreach($especialidades as $esp)
                    <option value="{{ $esp->id_especialidad }}"
                        {{ $esp->id_especialidad == $medico->id_especialidad ? 'selected' : '' }}>
                        {{ $esp->especialidad }}
                    </option>
                @endforeach
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Nombre</label>
            <input type="text" name="nombre" class="form-control"
                   value="{{ $medico->nombre }}" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Apellido</label>
            <input type="text" name="apellido" class="form-control"
                   value="{{ $medico->apellido }}" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Fecha nacimiento</label>
            <input type="date" name="fecha_nacimiento" class="form-control"
                   value="{{ $medico->fecha_nacimiento }}" required>
        </div>

        <button class="btn btn-success">Actualizar</button>
        <a href="{{ route('medicos.index') }}" class="btn btn-secondary">Volver</a>
    </form>
</div>
@endsection
