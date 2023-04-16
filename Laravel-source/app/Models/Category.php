<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class category extends Model
{
    use HasFactory;

    public function categories()
    {
        $this->hasMany(category::class);
    }

    public function product()
    {
       $this->hasMany(Product::class);
    }
}
