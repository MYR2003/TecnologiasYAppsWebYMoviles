<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Alergia extends Model
{
    use HasFactory;

    protected $table = 'alergia';

    protected $primaryKey = 'idalergia';

    protected $fillable = ['alergia'];

    public function personas(){
        return $this->belongsToMany(
            Personas::class,
            'alergia_persona',
            'idalergia',
            'idpersona'
        )->withTimestamps();
    }
}
