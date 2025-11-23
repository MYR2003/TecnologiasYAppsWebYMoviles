<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ExamenSeeder extends Seeder
{
    public function run(): void
    {
        $examenes = [
            'Hemograma completo', 'Glucosa en sangre', 'Perfil lipídico', 'Radiografía de tórax',
            'Ecografía abdominal', 'Tomografía craneal', 'Cultivo de orina', 'Prueba de embarazo',
            'Electrocardiograma', 'Presión arterial', 'Colesterol total', 'Triglicéridos',
            'Función hepática', 'Función renal', 'Tiroides TSH', 'Vitamina D',
            'Hierro sérico', 'Ácido úrico', 'Proteína C reactiva', 'Hemoglobina glicosilada'
        ];

        $tiposExamen = DB::table('tipo_examenes')->pluck('id_tipo_examen');

        foreach ($examenes as $examen) {
            DB::table('examenes')->insert([
                'id_tipo_examen' => $tiposExamen->random(),
                'examen' => $examen,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}