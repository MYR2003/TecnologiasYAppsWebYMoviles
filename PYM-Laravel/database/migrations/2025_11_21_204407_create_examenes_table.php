<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('examen', function (Blueprint $table) {
            $table->id('idexamen');

            $table->unsignedBigInteger('idtipoexamen');

            $table->string('examen', 100);
            $table->timestamps();

            $table->foreign('idtipoexamen')
                ->references('idtipoexamen')
                ->on('tipoexamen')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('examen');
    }
};