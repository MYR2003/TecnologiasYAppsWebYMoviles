<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class AlergiaPersonaFactory extends Factory
{
    public function definition(): array
    {
        return [
            'id_alergia' => Alergia::factory(),
            'id_persona' => Personas::factory(),
        ];
    }
}
