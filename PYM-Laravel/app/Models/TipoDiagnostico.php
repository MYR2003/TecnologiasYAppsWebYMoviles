<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TipoDiagnostico extends Model
{
    use HasFactory;

    protected $table = 'tipo_diagnostico';
    protected $primaryKey = 'idtipodiagnostico';
    protected $fillable = ['tipodiagnostico'];

    public function diagnosticos() {
        return $this->hasMany(Diagnostico::class, 'idtipodiagnostico');
    }
}
