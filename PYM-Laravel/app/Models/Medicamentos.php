<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Medicamentos extends Model
{
    use HasFactory;
    
    protected $table = 'medicamentos';
    protected $primaryKey = 'id_medicamento';
    protected $fillable = ['medicamento'];
    
    public function consultas()
    {
        return $this->belongsToMany(Consulta::class, 'receta', 'id_medicamento', 'id_consulta')
                    ->withPivot('cantidad')
                    ->withTimestamps();
    }
}