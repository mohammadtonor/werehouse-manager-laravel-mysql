<?php

namespace Database\Factories;

use App\Models\Product;
use App\Models\Shelf;
use Illuminate\Database\Eloquent\Factories\Factory;

class ProductShelfeFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        $product = Product::inRandomOrder()->first();
        $shelf = Shelf::inRandomOrder()->first();
        return [
            'shelve_id' => $shelf->id,
            'product_count' => $this->faker->numberBetween(1,2),
        ];
    }
}
