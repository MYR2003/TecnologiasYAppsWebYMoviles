<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('receta', function (Blueprint $table) {
            $table->primary(['idmedicamento', 'idconsulta']);
            
            $table->unsignedBigInteger('idmedicamento');
            $table->unsignedBigInteger('idconsulta');

            $table->foreign('idmedicamento')
                ->references('idmedicamento')
                ->on('medicamento')
                ->onDelete('cascade');
                  
            $table->foreign('idconsulta')
                ->references('idconsulta')
                ->on('consulta')
                ->onDelete('cascade');
            
            $table->integer('cantidad');
            $table->string('medidas', 10);
            $table->string('instrucciones', 255)->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('receta');
    }
};
