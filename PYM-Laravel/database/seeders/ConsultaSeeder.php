<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ConsultaSeeder extends Seeder
{
    public function run(): void
    {
        $personas = DB::table('persona')->pluck('idpersona');
        $medicos = DB::table('medico')->pluck('idmedico');
        $fichas = DB::table('fichamedica')->pluck('idfichamedica');

        for ($i = 0; $i < 40; $i++) {
            DB::table('consulta')->insert([
                'idpersona' => $personas->random(),
                'idmedico' => $medicos->random(),
                'idfichamedica' => $fichas->random(),
                'fecha' => now()->subMonths(rand(0, 12))->subDays(rand(0, 30))->subHours(rand(0, 23)),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
