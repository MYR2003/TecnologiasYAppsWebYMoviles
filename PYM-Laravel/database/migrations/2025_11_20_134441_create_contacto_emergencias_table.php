<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('contactoemergencia', function (Blueprint $table) {
            $table->id('idcontacto');
            
            $table->string('nombre', 255);
            $table->string('apellido', 255);
            $table->string('rut', 12);
            $table->dateTime('fechanacimiento');
            $table->string('telefono', 10);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('contactoemergencia');
    }
};
