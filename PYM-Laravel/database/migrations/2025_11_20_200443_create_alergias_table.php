<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('alergias', function (Blueprint $table) {
            $table->id('id_alergia');
            $table->string('alergia', 255);

            $table->timestamps();
            $table->unique('alergia');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('alergias');
    }
};
