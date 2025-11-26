<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TipoExamenes extends Model
{
    use HasFactory;
    
    protected $table = 'tipo_examenes';
    protected $primaryKey = 'idtipoexamen';
    protected $fillable = ['tipoexamen'];
    
    public function examenes()
    {
        return $this->hasMany(Examen::class, 'idtipoexamen');
    }
}