<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Examenes extends Model
{
    use HasFactory;
    
    protected $table = 'examen';
    protected $primaryKey = 'idexamen';
    protected $fillable = ['idtipoexamen', 'examen'];
    
    public function tipoExamen()
    {
        return $this->belongsTo(TipoExamen::class, 'idtipoexamen');
    }
    
    public function consultas()
    {
        return $this->belongsToMany(Consulta::class, 'examen_consulta', 'idexamen', 'idconsulta')
                    ->withPivot('resultadosexamen')
                    ->withTimestamps();
    }
}