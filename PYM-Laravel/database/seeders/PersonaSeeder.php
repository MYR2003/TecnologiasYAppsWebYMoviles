<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PersonaSeeder extends Seeder
{
    public function run(): void
    {
        $nombres = ['Juan', 'María', 'Carlos', 'Ana', 'Luis', 'Laura', 'Pedro', 'Sofía', 'Miguel', 'Elena'];
        $apellidos = ['Gómez', 'Rodríguez', 'López', 'Martínez', 'García', 'Hernández', 'Pérez', 'Sánchez', 'Ramírez', 'Torres'];

        for ($i = 0; $i < 50; $i++) {
            DB::table('persona')->insert([
                'nombre' => $nombres[array_rand($nombres)],
                'apellido' => $apellidos[array_rand($apellidos)],
                'fecha_nacimiento' => now()->subYears(rand(18, 80))->subMonths(rand(0, 11))->subDays(rand(0, 30)),
                'rut' => $this->faker->unique()->numerify('##.###.###-#'),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}