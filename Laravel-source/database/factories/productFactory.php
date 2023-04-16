<?php

namespace Database\Factories;

use App\Models\category;
use Illuminate\Database\Eloquent\Factories\Factory;

class productFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        $categoryId = category::inRandomOrder()->first();
        return [
            'title' => $this->faker->text(30),
            'barcode' => 'barcode'.'-'.$this->faker->randomLetter.'-'.$this->faker->numberBetween(0,1000),
            'description' => $this->faker->text(200),
            'price' => $this->faker->numberBetween(10000,1000000),
            'count'=> $this->faker->numberBetween(1,20),
            'discount' => $this->faker->numberBetween(1,50),
            'category_id' => $categoryId->category_id

        ];
    }
}
