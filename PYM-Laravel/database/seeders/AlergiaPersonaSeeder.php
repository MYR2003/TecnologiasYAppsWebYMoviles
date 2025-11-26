<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class AlergiaPersonaSeeder extends Seeder
{
    public function run(): void
    {
        $personas = DB::table('persona')->pluck('idpersona');
        $alergias = DB::table('alergia')->pluck('idalergia');

        $data = [];

        foreach ($personas as $personaId) {
            if (rand(1, 100) <= 30) {
                $alergiasAleatorias = $alergias->random(rand(1, 3));
                
                foreach ($alergiasAleatorias as $alergiaId) {
                    $data[] = [
                        'idpersona' => $personaId,
                        'idalergia' => $alergiaId,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ];
                }
            }
        }

        DB::table('alergia_persona')->insert($data);
    }
}