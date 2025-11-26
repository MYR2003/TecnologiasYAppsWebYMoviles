<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('consulta_tratamiento', function (Blueprint $table) {
            $table->primary(['idconsulta', 'idtratamiento']);

            $table->unsignedBigInteger('idconsulta');
            $table->unsignedBigInteger('idtratamiento');

            $table->foreign('idconsulta')
                ->references('idconsulta')
                ->on('consulta')
                ->onDelete('cascade');
            
            $table->foreign('idtratamiento')
                ->references('idtratamiento')
                ->on('tratamiento')
                ->onDelete('cascade');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('consulta_tratamiento');
    }
};
