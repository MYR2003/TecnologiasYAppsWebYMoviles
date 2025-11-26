<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sintoma', function (Blueprint $table) {
            $table->id('idsintoma');

            $table->string('sintoma');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sintoma');
    }
};
