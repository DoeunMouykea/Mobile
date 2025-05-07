<?php

namespace App\Http\Controllers;


use App\Models\Blog;
use Illuminate\Http\Request;

class ShowBlogController extends Controller
{
    public function index()
    {

        $blogData = Blog::all();

        return view('showblog', compact('blogData'));

    }
}
