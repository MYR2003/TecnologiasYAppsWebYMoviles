<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TipoExamenes extends Model
{
    use HasFactory;
    
    protected $table = 'tipo_examenes';
    protected $primaryKey = 'id_tipo_examen';
    protected $fillable = ['tipo_examen'];
    
    public function examenes()
    {
        return $this->hasMany(Examen::class, 'id_tipo_examen');
    }
}