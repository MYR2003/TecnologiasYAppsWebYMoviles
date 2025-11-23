<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FichaMedica extends Model
{
    use HasFactory;
    
    protected $table = 'ficha_medica';
    protected $primaryKey = 'id_ficha_medica';
    public $incrementing = true;
    
    protected $fillable = [
        'peso',
        'altura'
    ];
    
    public function consulta()
    {
        return $this->hasOne(Consulta::class, 'id_ficha_medica');
    }
}