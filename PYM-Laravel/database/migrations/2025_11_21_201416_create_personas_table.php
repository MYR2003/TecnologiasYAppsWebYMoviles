<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('persona', function (Blueprint $table) {
            $table->id('id_persona');

            $table->string('nombre', 255);
            $table->string('apellido', 255);
            $table->dateTime('fecha_nacimiento');
            $table->string('rut',12)->unique();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('persona');
    }
};
