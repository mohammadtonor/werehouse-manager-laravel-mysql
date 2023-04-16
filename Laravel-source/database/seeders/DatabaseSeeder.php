<?php

namespace Database\Seeders;

use App\Models\category;
use App\Models\order;
use App\Models\OrderDetail;
use App\Models\Product;
use App\Models\ProductShelfe;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public int $i=0;
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
         //User::factory(10)->create();
        //category::factory(5)->create();
        //Product::factory(1000)->create();
        //order::factory(200)->create();
        //ProductShelfe::factory(1000)->create();

        OrderDetail::all()->each(function (OrderDetail $orderDetail) {
            ProductShelfe::factory(1)->create([
                'product_id' => $orderDetail->product_id
            ])->dump();
        });
        //$this->call(ShelfSeeder::class);

    }
}
