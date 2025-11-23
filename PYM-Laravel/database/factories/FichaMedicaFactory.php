<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class FichaMedicaFactory extends Factory
{
    public function definition(): array
    {
        return [
            'peso' => $this->faker->randomFloat(2, 40, 120),
            'altura' => $this->faker->randomFloat(2, 1.50, 2.00),
        ];
    }
}