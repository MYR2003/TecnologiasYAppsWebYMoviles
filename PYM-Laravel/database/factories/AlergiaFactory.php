<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class AlergiaFactory extends Factory
{
    public function definition(): array
    {
        $alergias = [
            'Polen', 'Ácaros del polvo', 'Mariscos', 
            'Maní', 'Lácteos', 'Huevos', 'Penicilina', 
            'Picadura de abejas', 'Latex', 'Mohos',
            'Frutos secos', 'Soja', 'Trigo', 'Pescado', 
            'Sésamo', 'Cianuro', 'Fentanilo', 
        ];
        return [
            'alergia' => $this->faker->randomElement($alergias)
        ];
    }
}
