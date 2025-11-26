<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('medico', function (Blueprint $table) {
            $table->id('idmedico');
            
            $table->unsignedBigInteger('idespecialidad');
            
            $table->string('nombre', 50);
            $table->string('apellido', 50);
            $table->dateTime('fechanacimiento');
            $table->string('rut',12)->unique();
            $table->string('telefono', 20)->nullable();
            $table->timestamps();

            $table->foreign('idespecialidad')
                  ->references('idespecialidad')
                  ->on('especialidad')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('medico');
    }
};