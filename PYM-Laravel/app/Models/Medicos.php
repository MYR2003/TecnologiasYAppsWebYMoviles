<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Medicos extends Model
{
    use HasFactory;
    
    protected $table = 'medico';
    protected $primaryKey = 'idmedico';
    protected $fillable = [
        'idespecialidad', 'nombre', 'apellido', 'fechanacimiento', 'rut', 'telefono'
    ];
    
    public function especialidad()
    {
        return $this->belongsTo(Especialidades::class, 'idespecialidad');
    }
    
    public function consultas()
    {
        return $this->hasMany(Consulta::class, 'idmedico');
    }
}