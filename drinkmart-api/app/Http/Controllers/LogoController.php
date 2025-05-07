<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Logo;
use Illuminate\Support\Facades\Storage;

class LogoController extends Controller
{
    // Show the current logo (latest)
    public function index()
    {
        $logo = Logo::latest()->first();
        if ($logo && $logo->image) {
            $logo->image = asset('storage/' . $logo->image);
        }

        return response()->json($logo, 200);
    }

    // Create new logo (replace if one already exists)
    public function store(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpg,jpeg,png,gif|max:2048',
        ]);

        // Delete the old one (if exists)
        $oldLogo = Logo::latest()->first();
        if ($oldLogo && $oldLogo->image) {
            Storage::disk('public')->delete($oldLogo->image);
            $oldLogo->delete();
        }

        // Upload new logo
        $path = $request->file('image')->store('logos', 'public');
        $logo = Logo::create(['image' => $path]);
        $logo->image = asset('storage/' . $path);

        return response()->json($logo, 201);
    }

    // Update logo by ID
    public function update(Request $request, $id)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpg,jpeg,png,gif|max:2048',
        ]);

        $logo = Logo::findOrFail($id);

        // Delete old image
        if ($logo->image) {
            Storage::disk('public')->delete($logo->image);
        }

        // Save new image
        $path = $request->file('image')->store('logos', 'public');
        $logo->update(['image' => $path]);
        $logo->image = asset('storage/' . $path);

        return response()->json($logo, 200);
    }

    // Delete logo
    public function destroy($id)
    {
        $logo = Logo::findOrFail($id);
        if ($logo->image) {
            Storage::disk('public')->delete($logo->image);
        }
        $logo->delete();

        return response()->json(['message' => 'Logo deleted successfully.'], 200);
    }
}
