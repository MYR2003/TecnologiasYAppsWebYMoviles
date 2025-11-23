<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Personas extends Model
{
    use HasFactory;

    protected $table = 'personas';

    protected $primaryKey = 'id_persona';

    protected $fillabel = ['nombre', 'apellido', 'fecha_nacimiento'];

    public function alergias() {
        return $this->belongsToMany(
            Alergia::class,
            'alergia_persona',
            'id_persona',
            'id_alergia'
        )->withTimestamps();
    }
}
