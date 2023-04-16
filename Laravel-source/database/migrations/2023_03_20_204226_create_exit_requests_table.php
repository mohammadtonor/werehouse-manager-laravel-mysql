<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateExitRequestsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('exit_requests', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->bigInteger('total_exit_count');
            $table->bigInteger('total_exited_count');
            $table->foreignId('status_id')->constrained('exit_request_statuses');
            $table->integer('periority')->default(1);
            $table->foreignId('current_user_id')->constrained('users');
            $table->foreignId('zone_id')->constrained('zones');
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
        Schema::dropIfExists('exit_requests');
    }
}
