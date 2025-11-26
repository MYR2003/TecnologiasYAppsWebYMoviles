<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class AlergiaSeeder extends Seeder
{
    public function run(): void
    {
        $alergias = [
            'Polen', 'Mariscos', 'Penicilina', 'Cianuro', 'Fentanilo', 'Caspa de gatos'
        ];

        foreach ($alergias as $alergia) {
            DB::table('alergia')->insert([
                'alergia' => $alergia,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}