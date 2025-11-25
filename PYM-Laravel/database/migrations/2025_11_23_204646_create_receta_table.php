<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('receta', function (Blueprint $table) {
            $table->primary(['id_medicamento', 'id_consulta']);
            
            $table->unsignedBigInteger('id_medicamento');
            $table->unsignedBigInteger('id_consulta');

            $table->foreign('id_medicamento')
                ->references('id_medicamento')
                ->on('medicamentos')
                ->onDelete('cascade');
                  
            $table->foreign('id_consulta')
                ->references('id_consulta')
                ->on('consulta')
                ->onDelete('cascade');
            
            $table->integer('cantidad');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('receta');
    }
};
