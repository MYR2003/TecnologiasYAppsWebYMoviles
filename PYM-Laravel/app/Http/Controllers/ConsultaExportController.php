<?php

namespace App\Http\Controllers;

use App\Exports\ConsultasExport;
use Maatwebsite\Excel\Facades\Excel;

class ConsultaExportController extends Controller
{
    public function export()
    {
        return Excel::download(new ConsultasExport, 'consultas.xlsx');
    }
}
