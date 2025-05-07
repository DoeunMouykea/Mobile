<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;

class OrderPageController extends Controller
{
    public function index()
    {
        $orders = Order::all(); // or add with('orderItems') if needed

        return view('order', compact('orders'));
    }
}
