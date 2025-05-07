<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HistoryItem extends Model
{
    protected $fillable = [
        'history_id', 'name', 'image', 'price', 'quantity',
    ];

    public function history()
    {
        return $this->belongsTo(History::class);
    }
}

