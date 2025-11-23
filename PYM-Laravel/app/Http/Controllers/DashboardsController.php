<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardsController extends Controller
{
    public function index() {
        $consultas = DB::table('consultas')
            ->select(
                'consultas.id_consulta',
                'consultas.fecha',
                'ficha_medica.peso',
                'ficha_medica.altura',
                'especialidades.especialidad'
            )
            ->join('medicos', 'consultas.id_medico', '=', 'medicos.id_medico')
            ->join('especialidades', 'medicos.id_especialidad', '=', 'especialidades.id_especialidad')
            ->leftJoin('ficha_medica', 'consultas.id_ficha_medica', '=', 'ficha_medica.id_ficha_medica')
            ->get();
        
        $consultasPorEspecialidad = DB::table('consultas')
            ->join('medicos', 'consultas.id_medico', '=', 'medicos.id_medico')
            ->join('especialidades', 'medicos.id_especialidad', '=', 'especialidades.id_especialidad')
            ->select('especialidades.especialidad', DB::raw('COUNT(*) as count'))
            ->groupBy('especialidades.especialidad')
            ->get();
        
        $chartData = [
            'labels' => $consultasPorEspecialidad->pluck('especialidad')->toArray(),
            'values' => $consultasPorEspecialidad->pluck('count')->toArray()
        ];
        
        return view('dashboard', compact('consultas', 'chartData'));
    }
}