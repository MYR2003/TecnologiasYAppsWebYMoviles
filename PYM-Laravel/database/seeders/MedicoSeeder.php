<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MedicoSeeder extends Seeder
{
    public function run(): void
    {
        $nombres = ['Francisco', 'Antonio', 'Martin', 'Tomás', 'Joaquín', 'Ignacio', 'Juan', 'Benjamín'];
        $apellidos = ['Mendoza', 'Yunge', 'Polo', 'Rivas', 'Rodriguez', 'Mendez', 'Solano', 'Sanchez'];

        $especialidades = DB::table('especialidad')->pluck('idespecialidad');

        for ($i = 0; $i < 15; $i++) {
            DB::table('medico')->insert([
                'idespecialidad' => $especialidades->random(),
                'nombre' => $nombres[array_rand($nombres)],
                'apellido' => $apellidos[array_rand($apellidos)],
                'fechanacimiento' => now()->subYears(rand(30, 65))->subMonths(rand(0, 11))->subDays(rand(0, 30)),
                'rut' => (string) rand(7000000, 26999999),
                'telefono' => (string) rand(900000000, 999999999),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}