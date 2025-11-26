<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FichaMedicaSeeder extends Seeder
{
    public function run(): void
    {
        for ($i = 0; $i < 60; $i++) {
            DB::table('fichamedica')->insert([
                'altura' => rand(150, 200) / 100,
                'peso' => rand(450, 1200) / 10,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}