<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ContactoEmergencia extends Model
{
    use HasFactory;

    protected $table = 'contacto_emergencia';
    protected $primaryKey = 'idcontacto';

    protected $fillable = [
        'nombre', 'apellido', 'rut', 'fechanacimiento', 'telefono',
    ];

    public function personas() {
        return $this->belongsToMany(
            Personas::class,
            'persona_contacto',
            'idpersona',
            'idcontacto'
        )->withTimestamps();
    }
}
