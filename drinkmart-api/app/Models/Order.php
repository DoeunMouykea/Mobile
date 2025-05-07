<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'first_name', 'last_name', 'address', 'country', 'city', 'zip', 'phone',
        'payment_method', 'subtotal', 'shipping', 'total'
    ];

    // Relationship with OrderItem
    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }
}
