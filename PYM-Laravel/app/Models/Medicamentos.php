<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Medicamentos extends Model
{
    use HasFactory;
    
    protected $table = 'medicamento';
    protected $primaryKey = 'idmedicamento';
    protected $fillable = ['medicamento'];
    
    public function consultas()
    {
        return $this->belongsToMany(Consulta::class, 'receta', 'idmedicamento', 'idconsulta')
                    ->withPivot('cantidad')
                    ->withPivot('medica')
                    ->withPivot('instrucciones')
                    ->withTimestamps();
    }
}