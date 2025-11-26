<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Sintoma extends Model
{
    use HasFactory;

    protected $table = 'sintoma';
    protected $pimaryKey = 'idsintoma';

    protected $fillable = [
        'idsintoma', 'sintoma'
    ];

    public function consultas() {
        return $this->belongsToMany(
            Consultas::class,
            'consulta_sintoma',
            'idconsulta',
            'idsintoma'
        )->withTimestamps();
    }
}
