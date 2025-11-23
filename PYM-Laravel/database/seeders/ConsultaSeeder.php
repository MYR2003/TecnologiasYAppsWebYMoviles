<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ConsultaSeeder extends Seeder
{
    public function run(): void
    {
        $personas = DB::table('personas')->pluck('id_persona');
        $medicos = DB::table('medicos')->pluck('id_medico');
        $fichas = DB::table('ficha_medica')->pluck('id_ficha_medica');

        for ($i = 0; $i < 40; $i++) {
            DB::table('consultas')->insert([
                'id_persona' => $personas->random(),
                'id_medico' => $medicos->random(),
                'id_ficha_medica' => $fichas->random(),
                'fecha' => now()->subMonths(rand(0, 12))->subDays(rand(0, 30))->subHours(rand(0, 23)),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}