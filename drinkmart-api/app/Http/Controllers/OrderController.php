<?php
namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class OrderController extends Controller
{
    public function index()
    {
        $orders = Order::with('items')->latest()->get();
        return response()->json($orders);
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'first_name' => 'required',
                'last_name' => 'required',
                'address' => 'required',
                'country' => 'required',
                'city' => 'required',
                'zip' => 'required',
                'phone' => 'required',
                'payment_method' => 'required',
                'items' => 'required|array',
                'subtotal' => 'required|numeric',
                'shipping' => 'required|numeric',
                'total' => 'required|numeric',
            ]);

            $order = Order::create($validated);

            foreach ($validated['items'] as $item) {
                $order->items()->create([
                    'product_id' => $item['product_id'],
                    'name' => $item['name'],
                    'price' => $item['price'],
                    'quantity' => $item['quantity'],
                ]);
            }

            return response()->json([
                'message' => 'Order placed successfully',
                'order_id' => $order->id,
            ]);
        } catch (\Exception $e) {
            \Log::error('Order submission error: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to place order',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function show($id)
    {
        $order = Order::with('items')->find($id);

        if (!$order) {
            return response()->json(['message' => 'Order not found'], 404);
        }

        return response()->json($order);
    }
}
