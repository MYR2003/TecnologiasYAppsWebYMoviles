<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DashboardsController extends Controller
{
    public function getData()
    {
        $data = Http::get('http://localhost:3101');
        return response()->json($data);
    }
}
