<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('examen_consulta', function (Blueprint $table) {
            $table->primary(['idexamen', 'idconsulta']);
            
            $table->unsignedBigInteger('idexamen');
            $table->unsignedBigInteger('idconsulta');

            $table->foreign('idexamen')
                ->references('idexamen')
                ->on('examen')
                ->onDelete('cascade');
                  
            $table->foreign('idconsulta')
                ->references('idconsulta')
                ->on('consulta')
                ->onDelete('cascade');
            
            $table->text('resultadosexamen')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('examen_consulta');
    }
};
