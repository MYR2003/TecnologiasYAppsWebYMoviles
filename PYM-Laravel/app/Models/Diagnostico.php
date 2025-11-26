<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Diagnostico extends Model
{
    use HasFactory;

    protected $table = 'diagnostico';
    protected $primaryKey = 'iddiagnostico';
    protected $fillable = [
        'idtipodiagnostico',
        'diagnostico'
    ];

    public function tipodiagnostico() {
        return $this->belongsTo(TipoDiagnostico::class, 'idtipodiagnostico');
    }

    public function consultas() {
        return $this->belongsToMany(Consulta::class, 'consulta_diagnostico', 'idconsulta', 'iddiagnostico')
                    ->withTimestamps();
    }
}
