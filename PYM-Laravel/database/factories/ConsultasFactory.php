<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ConsultasFactory extends Factory
{
    public function definition(): array
    {
        return [
            'id_persona' => \App\Models\Persona::factory(),
            'id_medico' => \App\Models\Medico::factory(),
            'id_ficha_medica' => \App\Models\FichaMedica::factory(),
            'fecha' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}