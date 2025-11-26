<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('consulta', function (Blueprint $table) {
            $table->id('idconsulta');
            
            $table->unsignedBigInteger('idpersona');
            $table->unsignedBigInteger('idmedico');
            $table->unsignedBigInteger('idfichamedica');
            
            $table->dateTime('fecha');
            $table->timestamps();

            $table->foreign('idpersona')
                ->references('idpersona')
                ->on('persona')
                ->onDelete('cascade');
                
            $table->foreign('idmedico')
                ->references('idmedico')
                ->on('medico')
                ->onDelete('cascade');
                
            $table->foreign('idfichamedica')
                ->references('idfichamedica')
                ->on('fichamedica')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('consulta');
    }
};
