<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductShelvesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_shelves', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shelve_id')->constrained();
            $table->foreignId('product_id')->constrained();
            $table->integer('product_count');
            $table->timestamps();

            $table->unique(['shelve_id','product_id']);


        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_shelves');
    }
}
