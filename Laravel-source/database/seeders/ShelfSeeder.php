<?php

namespace Database\Seeders;

use App\Models\Shelf;
use App\Models\Zone;
use Illuminate\Database\Seeder;

class ShelfSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $zones = Zone::all();
        $shelve = '';
        $line = 0;
        $part = array('A', 'B', 'C');
        for ($i = 1; $i <= $zones->count(); $i++) {
            for ($j = $zones[$i - 1]->line_start; $j <= $zones[$i - 1]->line_finish; $j++) {
                for ($k = 1; $k <= count($part); $k++) {
                    for ($l = 1; $l <= $zones[$i - 1]->row_max_part; $l++){
                        for ($m = 1; $m <= $zones[$i - 1]->column_max_part; $m++){
                            $shelve = $zones[$i - 1]->title . '-'.$j. '-' . $part[$k-1].'-'.$l.'-'.$m;
                            dump($shelve);
                            Shelf::factory()->create([
                                'title' => $shelve,
                                'line_number' => $j,
                                'zone_id' => $i
                            ]);
                        }
                    }
                }
            }
        }
    }
}
