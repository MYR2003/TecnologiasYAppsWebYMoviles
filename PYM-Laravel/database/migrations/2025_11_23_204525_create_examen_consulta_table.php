<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('examen_consulta', function (Blueprint $table) {
            $table->primary(['id_examen', 'id_consulta']);
            
            $table->unsignedBigInteger('id_examen');
            $table->unsignedBigInteger('id_consulta');

            $table->foreign('id_examen')
                ->references('id_examen')
                ->on('examenes')
                ->onDelete('cascade');
                  
            $table->foreign('id_consulta')
                ->references('id_consulta')
                ->on('consulta')
                ->onDelete('cascade');
            
            $table->text('resultados_examen')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('examen_consulta');
    }
};
