<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    // Get all products
    public function index()
    {
        $products = Product::all();
        foreach ($products as $product) {
            $product->image = $product->image ? url($product->image) : null;
        }

        return response()->json($products, 200);
    }

    // Store a new product
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric',
            'material' => 'required|string|max:255',
            'category' => 'required|string|max:255',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'stock' => 'required|numeric',
            'volume' => 'required|string|max:255',
        ]);

        $imagePath = null;
        if ($request->hasFile('image')) {
            $filename = time() . '.' . $request->image->extension();
            $request->image->move(public_path('products'), $filename);
            $imagePath = ('products/' . $filename); // store full URL
        }

        $product = Product::create([
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'material' => $request->material,
            'category' => $request->category,
            'stock' => $request->stock,
            'volume' => $request->volume,
            'image' => $imagePath,
        ]);

        return response()->json($product, 201);
    }

    // Show a single product
    public function show($id)
    {
        $product = Product::findOrFail($id);
        $product->image = $product->image ? url($product->image) : null;

        return response()->json($product, 200);
    }

    // Update an existing product
    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'price' => 'sometimes|numeric',
            'description' => 'nullable|string',
            'material' => 'sometimes|string|max:255',
            'category' => 'sometimes|string|max:255',
            'stock' => 'sometimes|numeric',
            'image' => 'sometimes|image|mimes:jpeg,png,jpg,gif|max:2048',
            'volume' => 'required|string|max:255',
        ]);

        if ($request->hasFile('image')) {
            // Delete old image
            if ($product->image && file_exists(public_path(parse_url($product->image, PHP_URL_PATH)))) {
                unlink(public_path(parse_url($product->image, PHP_URL_PATH)));
            }

            // Save new image
            $filename = time() . '.' . $request->image->extension();
            $request->image->move(public_path('products'), $filename);
            $product->image = ('products/' . $filename); // store full URL
        }

        $product->update($request->except('image') + ['image' => $product->image]);

        return response()->json($product, 200);
    }

    // Delete a product
    public function destroy($id)
    {
        $product = Product::findOrFail($id);

        if ($product->image) {
            $imagePath = public_path(parse_url($product->image, PHP_URL_PATH));
            if (file_exists($imagePath)) {
                unlink($imagePath);
            }
        }

        $product->delete();

        return response()->json(['message' => 'Product deleted'], 204);
    }
}
