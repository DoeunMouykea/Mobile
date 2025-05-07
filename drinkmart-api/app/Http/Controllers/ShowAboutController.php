<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\About;

class ShowAboutController extends Controller
{
    public function index()
    {
        $aboutData = About::all(); // Fetch all about records from the database

        return view('showabout', compact('aboutData'));
    }
}
