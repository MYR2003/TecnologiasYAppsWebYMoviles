<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TipoTratamiento extends Model
{
    use HasFactory;

    protected $table = 'tipo_tratamiento';
    protected $primaryKey = 'idtipotratamiento';
    protected $fillable = ['tipotratamiento'];

    public function tratamiento() {
        return $this->hasMany(Tratamiento::class, 'idtipotratamiento');
    }
}
