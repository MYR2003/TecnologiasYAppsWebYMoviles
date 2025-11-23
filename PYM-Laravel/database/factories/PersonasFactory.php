<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class PersonasFactory extends Factory
{
    public function definition(): array
    {
        $nombres = ['Martin', 'Antonio', 'Francisco', 'Ignacio',
            'Benjamín', 'Tomás', 'Joaquín', 'Vicente', 'Lucas', 'Felipe'
        ];
        $apellidos = ['Mendez', 'Solano', 'Yunge', 'Sanchez', 'Polo', 'Pavez', 
            'Rodriguez', 'Rivas',
        ];
        return [
            'nombre' => $this->faker->randomElement($nombres),
            'apellido' => $this->faker->randomElement($apellidos),
            'fecha_nacimiento' => $this->faker->dateTimeBetween('-100 year', 'now')
        ];
    }
}
