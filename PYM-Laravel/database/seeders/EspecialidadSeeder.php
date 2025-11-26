<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class EspecialidadSeeder extends Seeder
{
    public function run(): void
    {
        $especialidades = [
            'Cardiología',
            'Pediatría', 
            'Dermatología',
            'Neurología',
            'Ortopedia',
            'Ginecología',
            'Oftalmología',
            'Psiquiatría',
            'Medicina General',
            'Cirugía General'
        ];

        foreach ($especialidades as $especialidad) {
            DB::table('especialidad')->insert([
                'especialidad' => $especialidad,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}