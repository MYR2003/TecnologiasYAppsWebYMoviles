<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PersonaSeeder extends Seeder
{
    public function run(): void
    {
        $nombres = ['Francisco', 'Antonio', 'Martin', 'Tomás', 'Joaquín', 'Ignacio', 'Juan', 'Benjamín'];
        $apellidos = ['Mendoza', 'Yunge', 'Polo', 'Rivas', 'Rodriguez', 'Mendez', 'Solano', 'Sanchez'];
        $sistemas = ['Fonasa', 'Isapre'];

        for ($i = 0; $i < 50; $i++) { // 'nombre', 'apellido', 'fechanacimiento', 'rut', 'sistemadesalud', 'domicilio', 'telefono',
            DB::table('persona')->insert([
                'nombre' => $nombres[array_rand($nombres)],
                'apellido' => $apellidos[array_rand($apellidos)],
                'fechanacimiento' => now()->subYears(rand(18, 80))->subMonths(rand(0, 11))->subDays(rand(0, 30)),
                'rut' => (string) rand(7000000, 26999999),
                'sistemadesalud' => $sistemas[array_rand($sistemas)],
                'telefono' => (string) rand(900000000, 999999999),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}