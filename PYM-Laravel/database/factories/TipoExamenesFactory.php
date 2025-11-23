<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class TipoExamenFactory extends Factory
{
    public function definition(): array
    {
        $tipos = [
            'Hematología', 'Bioquímica', 'Microbiología', 'Inmunología',
            'Radiología', 'Tomografía', 'Resonancia Magnética', 'Ecografía'
        ];
        
        return [
            'tipo_examen' => $this->faker->unique()->randomElement($tipos),
        ];
    }
}