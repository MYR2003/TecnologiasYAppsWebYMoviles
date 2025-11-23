<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MedicoSeeder extends Seeder
{
    public function run(): void
    {
        $nombres = ['Dr. Alejandro', 'Dra. Beatriz', 'Dr. Cristian', 'Dra. Daniela', 'Dr. Eduardo', 'Dra. Fernanda'];
        $apellidos = ['Mendoza', 'Silva', 'Rojas', 'Vargas', 'Castro', 'Ortega'];

        $especialidades = DB::table('especialidades')->pluck('id_especialidad');

        for ($i = 0; $i < 15; $i++) {
            DB::table('medicos')->insert([
                'id_especialidad' => $especialidades->random(),
                'nombre' => $nombres[array_rand($nombres)],
                'apellido' => $apellidos[array_rand($apellidos)],
                'fecha_nacimiento' => now()->subYears(rand(30, 65))->subMonths(rand(0, 11))->subDays(rand(0, 30)),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}