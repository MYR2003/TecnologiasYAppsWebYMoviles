<?php

namespace App\Exports;

use App\Models\Consulta;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;

class ConsultasExport implements FromCollection, WithHeadings, WithMapping
{
    public function collection()
    {
        return Consulta::with([
            'medico.especialidad',
            'fichaMedica'
        ])->get();
    }

    public function headings(): array
    {
        return [
            'ID Consulta',
            'Especialidad',
            'Fecha',
            'Peso',
            'Altura',
        ];
    }

    public function map($consulta): array
    {
        return [
            $consulta->id_consulta,

            $consulta->medico->especialidad->especialidad ?? 'N/A',

            date('d/m/Y H:i', strtotime($consulta->fecha)),

            $consulta->fichaMedica->peso ?? 'N/A',

            $consulta->fichaMedica->altura ?? 'N/A',
        ];
    }
}
