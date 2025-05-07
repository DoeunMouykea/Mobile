<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::create('social_media_links', function (Blueprint $table) {
            $table->id();
            $table->string('facebook')->nullable();
            $table->string('youtube')->nullable();
            $table->string('twitter')->nullable();
            $table->string('telegram')->nullable();
            $table->string('pinterest')->nullable();
            $table->string('instagram')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('social_media_links');
    }
};
