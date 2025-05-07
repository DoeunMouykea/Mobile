<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Slideshow;

class SlideshowController extends Controller
{
    // Get all slideshows

        public function index()
    {
        return response()->json(Slideshow::all(), 200);
    }


    // Store a new slideshow
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'description' => 'nullable|string',
            'link' => 'nullable|url',
        ]);

        // Save the image directly in public/slideshows
        $filename = time() . '.' . $request->image->extension();
        $request->image->move(public_path('slideshows'), $filename);
        $imagePath = 'slideshows/' . $filename;

        // Create the slideshow record
        $slideshow = Slideshow::create([
            'title' => $request->title,
            'image' => $imagePath,
            'description' => $request->description,
            'link' => $request->link,
        ]);

        return response()->json($slideshow, 201);
    }

    // Show a single slideshow
    public function show($id)
    {
        $slideshow = Slideshow::findOrFail($id);
        $slideshow->image_url = url($slideshow->image); // Return correct image URL
        return response()->json($slideshow, 200);
    }

    // Update an existing slideshow
    public function update(Request $request, $id)
    {
        $slideshow = Slideshow::findOrFail($id);

        $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'image' => 'sometimes|image|mimes:jpeg,png,jpg,gif|max:2048',
            'description' => 'nullable|string',
            'link' => 'nullable|url',
        ]);

        if ($request->hasFile('image')) {
            // Delete old image
            $oldPath = public_path($slideshow->image);
            if (file_exists($oldPath)) {
                unlink($oldPath);
            }

            // Save new image
            $filename = time() . '.' . $request->image->extension();
            $request->image->move(public_path('slideshows'), $filename);
            $slideshow->image = 'slideshows/' . $filename;
        }

        $slideshow->update($request->except('image') + ['image' => $slideshow->image]);

        return response()->json($slideshow, 200);
    }

    // Delete a slideshow
    public function destroy($id)
    {
        $slideshow = Slideshow::findOrFail($id);

        // Delete image file
        $filePath = public_path($slideshow->image);
        if (file_exists($filePath)) {
            unlink($filePath);
        }

        $slideshow->delete();

        return response()->json(['message' => 'Slideshow deleted'], 204);
    }
}
