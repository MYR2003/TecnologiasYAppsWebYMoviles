<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Consulta extends Model
{
    use HasFactory;

    protected $table = 'consultas';
    protected $primaryKey = 'id_consulta';
    
    protected $fillable = ['id_persona', 'id_medico', 'id_ficha_medica', 'fecha'];

    public function persona() {
        return $this->belongsTo(Personas::class, 'id_persona');
    }
    
    public function medico() {
        return $this->belongsTo(Medicos::class, 'id_medico');
    }
    
    public function fichaMedica() {
        return $this->belongsTo(FichaMedica::class, 'id_ficha_medica');
    }
    
    public function examenes()
    {
        return $this->belongsToMany(Examenes::class, 'examen_consulta', 'id_consulta', 'id_examen')
                    ->withPivot('resultados_examen')
                    ->withTimestamps();
    }
    
    public function medicamentos()
    {
        return $this->belongsToMany(Medicamentos::class, 'receta', 'id_consulta', 'id_medicamento')
                    ->withPivot('cantidad')
                    ->withTimestamps();
    }
}