<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Medicos;
use App\Models\Especialidades;

class CRUDMedicosController extends Controller
{
    public function index()
    {
        $medicos = Medicos::with('especialidad')->get();
        return view('medicos', compact('medicos'));
    }

    public function create()
    {
        $especialidades = Especialidades::all();
        return view('crearMedico', compact('especialidades'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'idespecialidad' => 'required',
            'nombre' => 'required',
            'apellido' => 'required',
            'rut' => 'required',
            'fechanacimiento' => 'required|date',
        ]);

        Medicos::create($request->all());

        return redirect()->route('medicos.index')
                         ->with('success', 'Médico creado correctamente');
    }

    public function edit(Medicos $medico)
    {
        $especialidades = Especialidades::all();
        return view('editarMedico', compact('medico', 'especialidades'));
    }

    public function update(Request $request, Medicos $medico)
    {
        $request->validate([
            'idespecialidad' => 'required',
            'nombre' => 'required',
            'apellido' => 'required',
            'rut' => 'required',
            'fechanacimiento' => 'required|date',
        ]);

        $medico->update($request->all());

        return redirect()->route('medicos.index')
                         ->with('success', 'Médico actualizado correctamente');
    }

    public function destroy(Medicos $medico)
    {
        $medico->delete();

        return redirect()->route('medicos.index')
                         ->with('success', 'Médico eliminado correctamente');
    }
}
