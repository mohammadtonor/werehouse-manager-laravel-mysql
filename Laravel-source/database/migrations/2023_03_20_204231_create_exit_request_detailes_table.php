<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateExitRequestDetailesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('exit_request_detailes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_id')->constrained();
            $table->bigInteger('request_count')->nullable();
            $table->bigInteger('exited_count')->nullable();
            $table->foreignId('exit_request_id')->constrained();
            $table->foreignId('basket_id')->nullable()->constrained();
            $table->foreignId('shelve_id')->nullable()->constrained();
            $table->foreignId('current_user_id')->constrained('users');
            $table->integer('not_exited_count')->nullable()->default(0);
            $table->integer('is_sorted')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('exit_request_detailes');
    }
}
