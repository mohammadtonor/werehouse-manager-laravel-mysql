<?php

namespace Database\Factories;

use http\Client\Curl\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class OrderFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        $user = \App\Models\User::inRandomOrder()->first();
        return [
            'totalAmount' => $this->faker->numberBetween(100000,1000000),
            'totalCount' => $this->faker->numberBetween(1,10),
            'user_id' => $user->id,
            'status_id' => 1,
            'created_at' => $this->faker->dateTimeBetween('2023-03-12 08:05:03',now())

        ];
    }
}
