<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Route;

Route::get('/health-check', fn (Request $request) => Response::noContent())->name('health-check');
Route::get('/static', fn (Request $request) => Response::json(['status' => true]))->name('static');
Route::get('/random', function (Request $request) {
    $data = [];
    for ($i = 0; $i < 1000; $i++) {
        $data[] = [
            'id' => $i,
            'name' => 'Name'.$i,
            'email' => 'user'.$i.'@example.com',
            'timestamp' => now()->timestamp,
        ];
    }

    return Response::json($data);
})->name('random');
Route::get('/http-request', fn (Request $request) => Http::get('https://dummyjson.com/products'))->name('http-request');
