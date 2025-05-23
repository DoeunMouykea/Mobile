<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('logos', function (Blueprint $table) {
            $table->id();
            $table->string('image'); // Path to the logo image
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('logos');
    }
};
