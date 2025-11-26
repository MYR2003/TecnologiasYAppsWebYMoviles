<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('persona', function (Blueprint $table) {
            $table->id('idpersona');

            $table->string('nombre', 255);
            $table->string('apellido', 255);
            $table->dateTime('fechanacimiento');
            $table->string('rut',12)->unique();
            $table->string('sistemadesalud', 255)->nullable();
            $table->string('domicilio', 255)->nullable();
            $table->string('telefono', 20)->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('persona');
    }
};
