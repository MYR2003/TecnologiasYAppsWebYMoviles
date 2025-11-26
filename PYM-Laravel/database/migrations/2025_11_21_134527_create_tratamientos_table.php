<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tratamiento', function (Blueprint $table) {
            $table->id('idtratamiento');

            $table->string('tratamiento');
            $table->unsignedBigInteger('idtipotratamiento');
            $table->timestamps();

            $table->foreign('idtipotratamiento')
                ->references('idtipotratamiento')
                ->on('tipo_tratamiento')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tratamiento');
    }
};
