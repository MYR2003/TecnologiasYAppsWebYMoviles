<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Consulta extends Model
{
    use HasFactory;

    protected $table = 'consulta';
    protected $primaryKey = 'idconsulta';
    
    protected $fillable = ['idpersona', 'idmedico', 'idfichamedica', 'fecha'];

    public function persona() {
        return $this->belongsTo(Personas::class, 'idpersona');
    }
    
    public function medico() {
        return $this->belongsTo(Medicos::class, 'idmedico');
    }
    
    public function fichaMedica() {
        return $this->belongsTo(FichaMedica::class, 'idfichamedica');
    }
    
    public function examenes()
    {
        return $this->belongsToMany(Examenes::class, 'examen_consulta', 'idconsulta', 'id_examen')
                    ->withPivot('resultados_examen')
                    ->withTimestamps();
    }
    
    public function medicamentos()
    {
        return $this->belongsToMany(Medicamentos::class, 'receta', 'idconsulta', 'id_medicamento')
                    ->withPivot('cantidad')
                    ->withPivot('medida')
                    ->withPivot('instrucciones')
                    ->withTimestamps();
    }

    public function sintomas() {
        return $this->belongsToMany(
                Sintoma::class, 
                'consulta_sintoma',
                'idconsulta',
                'idsintoma'
            )->withTimestamps();
    }

    public function diagnosticos() {
        return $this->belongsToMany(
            Diagnostico::class,
            'consulta_diagnostico',
            'idconsulta',
            'iddiagnostico'
        )->withTimestamps();
    }

    public function tratamientos() {
        return $this->belongsToMany(
            Tratamiento::class,
            'consulta_tratamiento',
            'idconsulta',
            'idtratamiento'
        )->withTimestamps();
    }
}
