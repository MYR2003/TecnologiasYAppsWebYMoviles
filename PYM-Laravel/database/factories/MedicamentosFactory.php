<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class MedicamentoFactory extends Factory
{
    public function definition(): array
    {
        $medicamentos = [
            'Paracetamol', 'Ibuprofeno', 'Amoxicilina', 'Omeprazol',
            'Atorvastatina', 'Metformina', 'Losartán', 'Salbutamol',
            'Aspirina', 'Diazepam', 'Prednisona', 'Insulina'
        ];
        
        return [
            'medicamento' => $this->faker->unique()->randomElement($medicamentos),
        ];
    }
}