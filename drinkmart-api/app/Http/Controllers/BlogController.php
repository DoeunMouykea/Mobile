<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Blog;
use Illuminate\Support\Facades\Storage;

class BlogController extends Controller
{
    // List all blogs
    public function index()
    {
        $blogs = Blog::all()->map(function ($blog) {
            if ($blog->image) {
                $blog->image = asset('storage/' . $blog->image);
            }
            return $blog;
        });

        return response()->json($blogs, 200);
    }

    // Create a new blog
    public function store(Request $request)
    {
        $request->validate([
            'title'        => 'required|string|max:255',
            'content'      => 'required|string',
            'author'       => 'required|string|max:100',
            'published_at' => 'nullable|date',
            'image'        => 'nullable|image|mimes:jpg,jpeg,png,gif|max:2048',
        ]);

        $data = $request->only(['title', 'content', 'author', 'published_at']);

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('blogs', 'public');
        }

        $blog = Blog::create($data);
        $blog->image = $blog->image ? asset('storage/' . $blog->image) : null;

        return response()->json($blog, 201);
    }

    // Show a single blog
    public function show($id)
    {
        $blog = Blog::findOrFail($id);
        if ($blog->image) {
            $blog->image = asset('storage/' . $blog->image);
        }
        return response()->json($blog, 200);
    }

    // Update a blog
    public function update(Request $request, $id)
    {
        $blog = Blog::findOrFail($id);

        $request->validate([
            'title'        => 'sometimes|required|string|max:255',
            'content'      => 'sometimes|required|string',
            'author'       => 'sometimes|required|string|max:100',
            'published_at' => 'nullable|date',
            'image'        => 'nullable|image|mimes:jpg,jpeg,png,gif|max:2048',
        ]);

        if ($request->hasFile('image')) {
            // Delete old image
            if ($blog->image) {
                Storage::disk('public')->delete($blog->image);
            }
            $blog->image = $request->file('image')->store('blogs', 'public');
        }

        $blog->update($request->except('image'));

        return response()->json($blog, 200);
    }

    // Delete a blog
    public function destroy($id)
    {
        $blog = Blog::findOrFail($id);

        if ($blog->image) {
            Storage::disk('public')->delete($blog->image);
        }

        $blog->delete();

        return response()->json(['message' => 'Blog deleted'], 200);
    }
}
