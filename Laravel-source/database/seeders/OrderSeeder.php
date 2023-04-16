<?php

namespace Database\Seeders;

use App\Models\order;
use App\Models\OrderDetail;
use Illuminate\Database\Seeder;

class OrderSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
         order::factory(300)->create()->each(function (order $order) {
            OrderDetail::factory(random_int(1,5))->create([
                'order_id' => $order->id
            ]);
         });
    }
}
