<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Medicos extends Model
{
    use HasFactory;
    
    protected $table = 'medicos';
    protected $primaryKey = 'id_medico';
    protected $fillable = [
        'id_especialidad', 'nombre', 'apellido', 'fecha_nacimiento'
    ];
    
    public function especialidad()
    {
        return $this->belongsTo(Especialidades::class, 'id_especialidad');
    }
    
    public function consultas()
    {
        return $this->hasMany(Consulta::class, 'id_medico');
    }
}