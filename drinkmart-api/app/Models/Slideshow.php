<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Slideshow extends Model
{
    use HasFactory;

    protected $fillable = ['title', 'image', 'description', 'link'];

    public function getImageAttribute($value)
    {
        return asset('storage/' . $value); // Returns full URL
    }
}
