<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MedicamentoSeeder extends Seeder
{
    public function run(): void
    {
        $medicamentos = [
            'Paracetamol 500mg',
            'Ibuprofeno 400mg',
            'Amoxicilina 500mg',
            'Omeprazol 20mg',
            'Atorvastatina 10mg',
            'Metformina 850mg',
            'Losartán 50mg',
            'Salbutamol Inhalador',
            'Aspirina 100mg',
            'Diazepam 5mg'
        ];

        foreach ($medicamentos as $medicamento) {
            DB::table('medicamentos')->insert([
                'medicamento' => $medicamento,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}