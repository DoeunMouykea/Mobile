<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\About;
use Illuminate\Support\Facades\Storage;

class AboutController extends Controller
{
    // Get the first About entry
    public function index()
    {
        return response()->json(About::first(), 200);
    }

    // Create a new About entry
    public function store(Request $request)
    {
        $request->validate([
            'title'   => 'required|string|max:255',
            'content' => 'required|string',
            'image'   => 'nullable|image|mimes:jpg,jpeg,png,gif|max:2048',
        ]);

        $data = $request->only(['title', 'content']);

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('about', 'public');
        }

        $about = About::create($data);

        return response()->json($about, 201);
    }

    // Update the first About entry
    public function update(Request $request)
    {
        $about = About::first();

        if (!$about) {
            return response()->json(['message' => 'About not found'], 404);
        }

        $request->validate([
            'title'   => 'sometimes|required|string|max:255',
            'content' => 'sometimes|required|string',
            'image'   => 'nullable|image|mimes:jpg,jpeg,png,gif|max:2048',
        ]);

        if ($request->hasFile('image')) {
            // Delete old image if exists
            if ($about->image) {
                Storage::disk('public')->delete($about->image);
            }

            $about->image = $request->file('image')->store('about', 'public');
        }

        $about->update($request->except('image'));

        return response()->json($about, 200);
    }

    // Delete the first About entry
    public function destroy()
    {
        $about = About::first();

        if (!$about) {
            return response()->json(['message' => 'About not found'], 404);
        }

        if ($about->image) {
            Storage::disk('public')->delete($about->image);
        }

        $about->delete();

        return response()->json(['message' => 'About deleted'], 200);
    }
}
