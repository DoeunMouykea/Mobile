<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Cart;
use App\Models\Product;

class CartController extends Controller
{
    // GET /api/cart
    public function index()
    {
        $cartItems = Cart::all();
        return response()->json($cartItems);
    }

    // POST /api/cart
    public function store(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'quantity'   => 'required|integer|min:1',
        ]);

        $product = Product::findOrFail($request->product_id);

        $cartItem = Cart::updateOrCreate(
            ['product_id' => $product->id],
            [
                'name'     => $product->name,
                'price'    => $product->price,
                'image'    => $product->image,
                'quantity' => $request->quantity,
            ]
        );

        return response()->json([
            'message' => 'Product added to cart',
            'cart' => $cartItem
        ], 201);
    }

    // PUT or PATCH /api/cart/{id}
    public function update(Request $request, $id)
    {
        $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $cartItem = Cart::findOrFail($id);
        $cartItem->quantity = $request->quantity;
        $cartItem->save();

        return response()->json([
            'message' => 'Cart updated',
            'cart' => $cartItem
        ]);
    }

    // DELETE /api/cart/{id}
    public function destroy($id)
    {
        $cartItem = Cart::findOrFail($id);
        $cartItem->delete();

        return response()->json(['message' => 'Item removed from cart']);
    }

    // Optional: DELETE /api/cart/clear
    public function clear()
    {
        Cart::truncate();
        return response()->json(['message' => 'Cart cleared']);
    }
}
