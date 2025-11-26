<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardsController extends Controller
{
    public function index() {
        $consultas = DB::table('consulta')
            ->select(
                'consulta.idconsulta',
                'consulta.fecha',
                'fichamedica.peso',
                'fichamedica.altura',
                'especialidad.especialidad'
            )
            ->join('medico', 'consulta.idmedico', '=', 'medico.idmedico')
            ->join('especialidad', 'medico.idespecialidad', '=', 'especialidad.idespecialidad')
            ->leftJoin('fichamedica', 'consulta.idfichamedica', '=', 'fichamedica.idfichamedica')
            ->get();
        
        $consultasPorEspecialidad = DB::table('consulta')
            ->join('medico', 'consulta.idmedico', '=', 'medico.idmedico')
            ->join('especialidad', 'medico.idespecialidad', '=', 'especialidad.idespecialidad')
            ->select('especialidad.especialidad', DB::raw('COUNT(*) as count'))
            ->groupBy('especialidad.especialidad')
            ->get();
        
        $chartData = [
            'labels' => $consultasPorEspecialidad->pluck('especialidad')->toArray(),
            'values' => $consultasPorEspecialidad->pluck('count')->toArray()
        ];
        
        return view('dashboard', compact('consultas', 'chartData'));
    }
}
