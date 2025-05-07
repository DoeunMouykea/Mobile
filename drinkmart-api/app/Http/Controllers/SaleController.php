<?php

namespace App\Http\Controllers;


use App\Models\OrderItem;
use Illuminate\Http\Request;

class SaleController extends Controller
{
    public function index()
    {
        $order_items = OrderItem::all();
        return view('sale', compact('order_items'));

    }
}
