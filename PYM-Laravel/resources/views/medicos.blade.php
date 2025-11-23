@extends('layouts.app')

@section('title', 'Médicos')

@section('body')
<div class="container mt-4">

    <h1 class="mb-4">Listado de Médicos</h1>

    <a href="{{ route('medicos.create') }}" class="btn btn-primary mb-3">
        Crear Médico
    </a>

    @if (session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @endif

    @if($medicos->count() > 0)
    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nombre completo</th>
                <th>Especialidad</th>
                <th>Acciones</th>
            </tr>
        </thead>

        <tbody>
            @foreach($medicos as $medico)
            <tr>
                <td>{{ $medico->id_medico }}</td>

                <td>{{ $medico->nombre }} {{ $medico->apellido }}</td>

                {{-- Mostrar especialidad correcta --}}
                <td>
                    {{ $medico->especialidad->especialidad ?? 'Sin especialidad' }}
                </td>

                <td>
                    <a href="{{ route('medicos.edit', $medico->id_medico) }}"
                       class="btn btn-warning btn-sm">
                        Editar
                    </a>

                    <form action="{{ route('medicos.destroy', $medico->id_medico) }}"
                          method="POST"
                          class="d-inline">
                        @csrf
                        @method('DELETE')

                        <button type="submit"
                                class="btn btn-danger btn-sm"
                                onclick="return confirm('¿Eliminar médico?')">
                            Eliminar
                        </button>
                    </form>
                </td>
            </tr>
            @endforeach
        </tbody>

    </table>

    @else
        <div class="alert alert-info">No hay médicos registrados.</div>
    @endif

</div>
@endsection
