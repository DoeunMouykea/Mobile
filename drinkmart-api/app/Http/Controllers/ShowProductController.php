<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class ShowProductController extends Controller
{
    public function index()
    {
            $products = Product::latest()->get();

            return view('showproduct', compact('products'));

    }
}
