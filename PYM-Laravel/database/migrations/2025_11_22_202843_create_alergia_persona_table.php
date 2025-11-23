<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('alergia_persona', function (Blueprint $table) {
            $table->primary(['id_alergia', 'id_persona']);
            
            $table->unsignedBigInteger('id_alergia');
            $table->unsignedBigInteger('id_persona');

            $table->foreign('id_alergia')
                ->references('id_alergia')
                ->on('alergias')
                ->onDelete('cascade');
                  
            $table->foreign('id_persona')
                ->references('id_persona')
                ->on('personas')
                ->onDelete('cascade');
            
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('alergia_persona');
    }
};