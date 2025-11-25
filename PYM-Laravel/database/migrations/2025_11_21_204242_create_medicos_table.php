<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('medico', function (Blueprint $table) {
            $table->id('id_medico');
            
            $table->unsignedBigInteger('id_especialidad');
            
            $table->string('nombre', 50);
            $table->string('apellido', 50);
            $table->date('fecha_nacimiento');
            $table->string('rut',12)->unique();
            $table->timestamps();

            $table->foreign('id_especialidad')
                  ->references('id_especialidad')
                  ->on('especialidades')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('medico');
    }
};