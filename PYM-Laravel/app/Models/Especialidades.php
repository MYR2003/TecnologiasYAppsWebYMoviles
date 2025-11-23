<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Especialidades extends Model
{
    use HasFactory;
    
    protected $table = 'especialidades';
    protected $primaryKey = 'id_especialidad';
    protected $fillable = ['especialidad'];
    
    public function medicos()
    {
        return $this->hasMany(Medico::class, 'id_especialidad');
    }
}