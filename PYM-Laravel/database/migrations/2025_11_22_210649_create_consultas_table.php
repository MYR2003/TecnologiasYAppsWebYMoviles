<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('consultas', function (Blueprint $table) {
            $table->id('id_consulta');
            
            $table->unsignedBigInteger('id_persona');
            $table->unsignedBigInteger('id_medico');
            $table->unsignedBigInteger('id_ficha_medica');
            
            $table->dateTime('fecha');
            $table->timestamps();

            $table->foreign('id_persona')
                ->references('id_persona')
                ->on('personas')
                ->onDelete('cascade');
                
            $table->foreign('id_medico')
                ->references('id_medico')
                ->on('medicos')
                ->onDelete('cascade');
                
            $table->foreign('id_ficha_medica')
                ->references('id_ficha_medica')
                ->on('ficha_medica')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('consultas');
    }
};