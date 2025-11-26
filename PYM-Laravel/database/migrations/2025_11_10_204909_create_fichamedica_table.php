<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fichamedica', function (Blueprint $table) {
            $table->id('idfichamedica');
            $table->decimal('altura', 5, 2); 
            $table->decimal('peso', 5, 1);   
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fichamedica');
    }
};