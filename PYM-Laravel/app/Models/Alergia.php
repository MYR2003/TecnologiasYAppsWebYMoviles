<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Alergia extends Model
{
    use HasFactory;

    protected $table = 'alergias';

    protected $primaryKey = 'id_alergia';

    protected $fillable = ['alergia'];

    public function personas(){
        return $this->belongsToMany(
            Personas::class,
            'alergia_persona',
            'id_alergia',
            'id_persona'
        )->withTimestamps();
    }
}
