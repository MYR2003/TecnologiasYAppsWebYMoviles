<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Personas extends Model
{
    use HasFactory;

    protected $table = 'persona';

    protected $primaryKey = 'idpersona';

    protected $fillabel = [
        'nombre', 'apellido', 'fechanacimiento', 'rut', 'sistemadesalud', 'domicilio', 'telefono',
    ];

    public function alergias() {
        return $this->belongsToMany(
            Alergia::class,
            'alergia_persona',
            'idpersona',
            'idalergia'
        )->withTimestamps();
    }
}
