<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('diagnostico', function (Blueprint $table) {
            $table->id('iddiagnostico');

            $table->unsignedBigInteger('idtipodiagnostico');
            $table->string('diagnostico');
            $table->timestamps();

            $table->foreign('idtipodiagnostico')
                ->references('idtipodiagnostico')
                ->on('tipo_diagnostico')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('diagnostico');
    }
};
