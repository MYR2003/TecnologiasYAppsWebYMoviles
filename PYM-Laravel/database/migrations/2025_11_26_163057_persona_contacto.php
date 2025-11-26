<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('persona_contacto', function (Blueprint $table) {
            $table->primary(['idpersona', 'idcontacto']);

            $table->unsignedBigInteger('idpersona');
            $table->unsignedBigInteger('idcontacto');

            $table->foreign('idpersona')
                ->references('idpersona')
                ->on('persona')
                ->onDelete('cascade');
            
            $table->foreign('idcontacto')
                ->references('idcontacto')
                ->on('contactoemergencia')
                ->onDelete('cascade');

            $table->text('relacion')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('persona_contacto');
    }
};
