<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('consulta_diagnostico', function (Blueprint $table) {
            $table->primary(['idconsulta', 'iddiagnostico']);

            $table->unsignedBigInteger('idconsulta');
            $table->unsignedBigInteger('iddiagnostico');

            $table->foreign('idconsulta')
                ->references('idconsulta')
                ->on('consulta')
                ->onDelete('cascade');
            
            $table->foreign('iddiagnostico')
                ->references('iddiagnostico')
                ->on('diagnostico')
                ->onDelete('cascade');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('consulta_diagnostico');
    }
};
