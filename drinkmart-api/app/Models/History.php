<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class History extends Model
{
    protected $fillable = [
        'name', 'image', 'status', 'date', 'totalItems', 'totalPrice',
    ];

    public function items()
    {
        return $this->hasMany(HistoryItem::class);
    }
}
