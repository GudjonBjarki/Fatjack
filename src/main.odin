package main

import "core:mem"
import "core:fmt"
import "vendor:raylib"

import "game"
import "assets"

WINDOW_SIZE :: [2]i32{ 1000, 1000 }

main :: proc() {

    // use a custom memory allocator to check for memory leaks
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)

    defer {
        if len(track.allocation_map) > 0 {
            fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
            for _, entry in track.allocation_map {
                fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
            }
        }
        mem.tracking_allocator_destroy(&track)
    }

    raylib.InitWindow(WINDOW_SIZE.x, WINDOW_SIZE.y, "Fatjack")
    defer raylib.CloseWindow()

    // Load assets
    assets.load()
    defer assets.free()

    // play the game.
    game.run_game()
}
