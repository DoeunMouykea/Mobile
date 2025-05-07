<?php

namespace App\Http\Controllers;

use App\Models\History;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class HistoryController extends Controller
{
    // Method to show all history records
    public function index()
    {
        try {
            // Fetch all history records from the database
            $histories = History::with('items')->orderBy('date', 'desc')->get();

            // Return the histories with a response
            return response()->json([
                'message' => 'History records fetched successfully.',
                'data' => $histories
            ], 200);
        } catch (\Exception $e) {
            Log::error('Error fetching history records: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to fetch history records',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string',
                'image' => 'required|string',
                'status' => 'required|string',
                'date' => 'required|date',
                'totalItems' => 'required|integer',
                'totalPrice' => 'required|numeric',
                'cartItems' => 'required|array',
                'cartItems.*.name' => 'required|string',
                'cartItems.*.image' => 'required|string',
                'cartItems.*.price' => 'required|numeric',
                'cartItems.*.quantity' => 'required|integer',
            ]);

            // Create history record
            $history = History::create([
                'name' => $validated['name'],
                'image' => $validated['image'],
                'status' => $validated['status'],
                'date' => $validated['date'],
                'totalItems' => $validated['totalItems'],
                'totalPrice' => $validated['totalPrice'],
            ]);

            // Save each cart item
            foreach ($validated['cartItems'] as $item) {
                $history->items()->create([
                    'name' => $item['name'],
                    'image' => $item['image'],
                    'price' => $item['price'],
                    'quantity' => $item['quantity'],
                ]);
            }

            return response()->json(['message' => 'History saved successfully.']);
        } catch (\Exception $e) {
            Log::error('Error saving history: ' . $e->getMessage());
            return response()->json([
                'message' => 'Failed to save history',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
