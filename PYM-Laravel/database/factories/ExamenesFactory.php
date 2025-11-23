<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ExamenFactory extends Factory
{
    public function definition(): array
    {
        $examenes = [
            'Hemograma completo', 'Glucosa en sangre', 'Perfil lipídico',
            'Radiografía de tórax', 'Ecografía abdominal', 'Tomografía craneal',
            'Cultivo de orina', 'Prueba de embarazo', 'Electrocardiograma'
        ];
        
        return [
            'id_tipo_examen' => \App\Models\TipoExamen::factory(),
            'examen' => $this->faker->unique()->randomElement($examenes),
        ];
    }
}