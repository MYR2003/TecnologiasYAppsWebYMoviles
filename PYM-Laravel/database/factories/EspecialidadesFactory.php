<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class EspecialidadFactory extends Factory
{
    public function definition(): array
    {
        $especialidades = [
            'Cardiología', 'Pediatría', 'Dermatología', 'Neurología', 
            'Ortopedia', 'Ginecología', 'Oftalmología', 'Psiquiatría'
        ];
        
        return [
            'especialidad' => $this->faker->unique()->randomElement($especialidades),
        ];
    }
}