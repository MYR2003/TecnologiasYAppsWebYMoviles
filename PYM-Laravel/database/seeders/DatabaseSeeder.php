<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            EspecialidadSeeder::class,
            TipoExamenSeeder::class,
            MedicamentoSeeder::class,
            AlergiaSeeder::class,
            PersonaSeeder::class,
            MedicoSeeder::class,
            ExamenSeeder::class,
            FichaMedicaSeeder::class,
            ConsultaSeeder::class,
            AlergiaPersonaSeeder::class,
        ]);
    }
}