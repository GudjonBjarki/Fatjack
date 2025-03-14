package rendering

import "vendor:raylib"

// Rendering helper functions.

draw_text :: proc(text: cstring, pos: [2]f32, font_size: f32, spacing: f32 = 1, color: raylib.Color = raylib.BLACK) {
    raylib.DrawTextEx(
        raylib.GetFontDefault(),
        text,
        pos,
        font_size,
        spacing,
        color
    )
}

draw_text_centered :: proc(text: cstring, pos: [2]f32, font_size: f32, spacing: f32 = 1, color: raylib.Color = raylib.BLACK) {
    text_size := raylib.MeasureTextEx(
        raylib.GetFontDefault(),
        text,
        font_size,
        spacing
    )

    draw_pos := pos - (text_size / 2)

    raylib.DrawTextEx(
        raylib.GetFontDefault(),
        text,
        draw_pos,
        font_size,
        spacing,
        color
    )
}

draw_texture :: proc(texture: raylib.Texture2D, pos: [2]f32, size: [2]f32, tint: raylib.Color = raylib.WHITE) {
    src_rect := raylib.Rectangle{
        0, 0, f32(texture.width), f32(texture.height)
    }

    half_size := size / 2
    dest_rect := raylib.Rectangle {
        pos.x - half_size.x,
        pos.y - half_size.y,
        size.x,
        size.y
    }

    raylib.DrawTexturePro(
        texture,
        src_rect,
        dest_rect,
        {0, 0},
        0,
        tint
    )
}