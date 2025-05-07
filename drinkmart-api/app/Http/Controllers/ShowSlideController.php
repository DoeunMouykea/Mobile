<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ShowSlideController extends Controller
{
    public function index()
    {
        return view('showslide');
    }
}
