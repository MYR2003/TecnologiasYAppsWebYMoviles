<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('alergia_persona', function (Blueprint $table) {
            $table->primary(['idalergia', 'idpersona']);
            
            $table->unsignedBigInteger('idalergia');
            $table->unsignedBigInteger('idpersona');

            $table->foreign('idalergia')
                ->references('idalergia')
                ->on('alergia')
                ->onDelete('cascade');
                  
            $table->foreign('idpersona')
                ->references('idpersona')
                ->on('persona')
                ->onDelete('cascade');
            
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('alergia_persona');
    }
};