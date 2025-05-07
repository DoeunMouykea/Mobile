<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ShowSocialController extends Controller
{
    public function index()
    {
        return view('showsocial');
    }
}
