<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TipoExamenSeeder extends Seeder
{
    public function run(): void
    {
        $tipos = [
            'Hematología',
            'Bioquímica',
            'Microbiología', 
            'Inmunología',
            'Radiología',
            'Tomografía',
            'Resonancia Magnética',
            'Ecografía',
            'Ultrasonido',
            'Electrocardiograma'
        ];

        foreach ($tipos as $tipo) {
            DB::table('tipo_examenes')->insert([
                'tipo_examen' => $tipo,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}