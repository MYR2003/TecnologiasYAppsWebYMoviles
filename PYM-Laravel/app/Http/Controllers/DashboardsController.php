<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardsController extends Controller
{
    public function index() {
        $consultas = DB::table('consulta')
            ->select(
                'consulta.id_consulta',
                'consulta.fecha',
                'ficha_medica.peso',
                'ficha_medica.altura',
                'especialidades.especialidad'
            )
            ->join('medico', 'consulta.id_medico', '=', 'medico.id_medico')
            ->join('especialidades', 'medico.id_especialidad', '=', 'especialidades.id_especialidad')
            ->leftJoin('ficha_medica', 'consulta.id_ficha_medica', '=', 'ficha_medica.id_ficha_medica')
            ->get();
        
        $consultasPorEspecialidad = DB::table('consulta')
            ->join('medico', 'consulta.id_medico', '=', 'medico.id_medico')
            ->join('especialidades', 'medico.id_especialidad', '=', 'especialidades.id_especialidad')
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
