<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Examenes extends Model
{
    use HasFactory;
    
    protected $table = 'examenes';
    protected $primaryKey = 'id_examen';
    protected $fillable = ['id_tipo_examen', 'examen'];
    
    public function tipoExamen()
    {
        return $this->belongsTo(TipoExamen::class, 'id_tipo_examen');
    }
    
    public function consultas()
    {
        return $this->belongsToMany(Consulta::class, 'examen_consulta', 'id_examen', 'id_consulta')
                    ->withPivot('resultados_examen')
                    ->withTimestamps();
    }
}