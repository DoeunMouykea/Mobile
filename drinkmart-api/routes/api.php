<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\SlideshowController;
use App\Http\Controllers\AboutController;
use App\Http\Controllers\BlogController;
use App\Http\Controllers\ContactController;
use App\Http\Controllers\LogoController;
use App\Http\Controllers\SocialMediaLinkController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\HistoryController;

// User Routes
Route::group(['middleware' => 'api',    'prefix' => 'auth'], function ($router) {
    Route::post('/register', [AuthController::class, 'register'])->name('register');
    Route::middleware(['throttle:3,1'])->post('/login', [AuthController::class, 'login'])->name('login');
    Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:api')->name('logout');
    Route::post('/refresh', [AuthController::class, 'refresh'])->middleware('auth:api')->name('refresh');
    Route::get('/user', [AuthController::class, 'me'])->middleware('auth:api')->name('me');
});

// Product Routes
Route::group(['middleware' => 'api','prefix' => 'products'], function ($router) {
    Route::get('/', [ProductController::class, 'index']);
    Route::post('/product', [ProductController::class, 'store']);
    Route::get('/{id}', [ProductController::class, 'show']);
    Route::put('/{id}', [ProductController::class, 'update']);
    Route::delete('/{id}', [ProductController::class, 'destroy']);
});

// Slideshow Routes
Route::group(['middleware' => 'api','prefix' => 'slideshows'], function ($router) {
    Route::get('/', [SlideshowController::class, 'index']);
    Route::post('/slideshow', [SlideshowController::class, 'store']);
    Route::get('/{id}', [SlideshowController::class, 'show']);
    Route::put('/slideshow={id}', [SlideshowController::class, 'update']);
    Route::delete('/{id}', [SlideshowController::class, 'destroy']);
});

// Contact Routes
Route::group(['middleware' => 'api','prefix' => 'contacts'], function ($router) {
    Route::get('/', [ContactController::class, 'index']);
    Route::post('/contact', [ContactController::class, 'store']);
    Route::get('/{id}', [ContactController::class, 'show']);
    Route::put('/{id}', [ContactController::class, 'update']);
    Route::delete('/{id}', [ContactController::class, 'destroy']);
});

// Logo Routes
Route::group(['middleware' => 'api','prefix' => 'logos'], function ($router) {
Route::get('/', [LogoController::class, 'index']);
Route::post('/logo', [LogoController::class, 'store']);
Route::get('/{id}', [LogoController::class,'show']);
Route::put('/{id}', [LogoController::class, 'update']);
Route::delete('/{id}', [LogoController::class, 'destroy']);
});

// Social-link Routes
Route::group(['middleware' => 'api','prefix' => 'social-links'], function ($router) {
Route::get('/', [SocialMediaLinkController::class, 'index']);
Route::post('/social-link', [SocialMediaLinkController::class, 'store']);
Route::get('/{id}', [SocialMediaLinkController::class, 'show']);
Route::put('/{id}', [SocialMediaLinkController::class, 'update']);
Route::delete('/{id}', [SocialMediaLinkController::class, 'destroy']);
});

// Cart Routes
Route::group(['middleware' => 'api', 'prefix' => 'carts'], function () {
    Route::get('/', [CartController::class, 'index']);
    Route::post('/cart', [CartController::class, 'store']);
    Route::put('/{id}', [CartController::class, 'update']);
    Route::delete('/{id}', [CartController::class, 'destroy']);
    Route::delete('/clear', [CartController::class, 'clear']);
});

// Order Routes
Route::group(['middleware' => 'api','prefix' => 'orders'], function ($router) {Route::post('/history', [HistoryController::class, 'store']);
Route::post('/history', [HistoryController::class, 'store']);
Route::get('/histories', [HistoryController::class, 'index']);
Route::post('/order', [OrderController::class, 'store']);
Route::get('/', [OrderController::class, 'index']);     // Get all orders
Route::get('/{id}', [OrderController::class, 'show']); // Get one order
});

// About Routes
Route::group(['middleware' => 'api','prefix' => 'abouts'], function ($router) {
    Route::get('/', [AboutController::class, 'index']);
    Route::post('/about', [AboutController::class,'store']);
    Route::get('/{id}', [AboutController::class,'show']);
    Route::put('/{id}', [AboutController::class, 'update']);
    Route::delete('/{id}', [AboutController::class, 'destroy']);
});

// Blog Routes
Route::group(['middleware' => 'api','prefix' => 'blogs'], function ($router) {
    Route::get('/', [BlogController::class, 'index']);
    Route::post('/blog', [BlogController::class, 'store']);
    Route::get('/{id}', [BlogController::class, 'show']);
    Route::put('/{id}', [BlogController::class, 'update']);
    Route::delete('/{id}', [BlogController::class, 'destroy']);
});

// Contact Routes
Route::group(['middleware' => 'api','prefix' => 'contacts'], function ($router) {
    Route::get('/', [ContactController::class, 'index']);
    Route::post('/contact', [ContactController::class, 'store']);
    Route::get('/{id}', [ContactController::class, 'show']);
    Route::put('/{id}', [ContactController::class, 'update']);
    Route::delete('/{id}', [ContactController::class, 'destroy']);
});
