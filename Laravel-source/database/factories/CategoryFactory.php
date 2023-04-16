<?php

namespace Database\Factories;

use App\Models\category;
use Illuminate\Database\Eloquent\Factories\Factory;

class CategoryFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        if (category::all()->count() <1){
            $category = 1;
        }else{
            $category = category::all()->first;
        }

        return [
            'title' => $this->faker->randomLetter,
            'category_id' => 1
        ];
    }
}
