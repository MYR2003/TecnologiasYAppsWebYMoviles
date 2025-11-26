<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tratamiento extends Model
{
    use HasFactory;

    protected $table = 'tratamiento';
    protected $primaryKey = 'idtratamiento';
    protected $fillable = [
        'idtratamiento', 'idtipotratamiento', 'tratamiento'
    ];

    public function tipoTratamiento() {
        return $this->belongsTo(TipoTratamiento::class, 'idtipotratamiento');
    }

    public function consultas() {
        return $this->belongsToMany(Consulta::class, 'consulta_tratamiento', 'idconsulta', 'idtratamiento')
                    ->withTimestamps();
    }
}
