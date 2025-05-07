<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('first_name');
            $table->string('last_name');
            $table->string('address');
            $table->string('country');
            $table->string('city');
            $table->string('zip');
            $table->string('phone');
            $table->string('payment_method');
            $table->decimal('subtotal', 8, 2);
            $table->decimal('shipping', 8, 2);
            $table->decimal('total', 8, 2);
            $table->timestamps();
        });
    }


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
