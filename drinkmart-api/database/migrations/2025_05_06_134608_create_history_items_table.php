<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateHistoryItemsTable extends Migration
{
    public function up()
    {
        Schema::create('history_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('history_id')->constrained()->onDelete('cascade');
            $table->string('name');
            $table->string('image');
            $table->decimal('price', 10, 2);
            $table->integer('quantity');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('history_items');
    }
}
