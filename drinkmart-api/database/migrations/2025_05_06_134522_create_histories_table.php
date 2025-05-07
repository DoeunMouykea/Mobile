<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateHistoriesTable extends Migration
{
    public function up()
    {
        Schema::create('histories', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('image');
            $table->string('status');
            $table->timestamp('date');
            $table->integer('totalItems');
            $table->decimal('totalPrice', 10, 2);
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('histories');
    }
}
