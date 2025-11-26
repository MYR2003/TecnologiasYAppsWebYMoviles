<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FichaMedica extends Model
{
    use HasFactory;
    
    protected $table = 'fichamedica';
    protected $primaryKey = 'idfichamedica';
    public $incrementing = true;
    
    protected $fillable = [
        'peso',
        'altura'
    ];
    
    public function consulta()
    {
        return $this->hasOne(Consulta::class, 'idfichamedica');
    }
}