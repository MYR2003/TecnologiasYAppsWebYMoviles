<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('examenes', function (Blueprint $table) {
            $table->id('id_examen');

            $table->unsignedBigInteger('id_tipo_examen');

            $table->string('examen', 100);
            $table->timestamps();

            $table->foreign('id_tipo_examen')
                ->references('id_tipo_examen')
                ->on('tipo_examenes')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('examenes');
    }
};