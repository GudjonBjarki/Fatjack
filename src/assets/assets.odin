package assets

import "vendor:raylib"

EMBED_ASSETS :: true

club_texture: raylib.Texture2D
heart_texture: raylib.Texture2D
diamond_texture: raylib.Texture2D
spade_texture: raylib.Texture2D


load_embeded_texture :: proc(content: []u8, file_type: cstring) -> raylib.Texture2D {
    image := raylib.LoadImageFromMemory(file_type, raw_data(content), i32(len(content)))
    defer raylib.UnloadImage(image)

    texture := raylib.LoadTextureFromImage(image)
    return texture
}


load :: proc() {
    when EMBED_ASSETS {
        club_texture = load_embeded_texture(#load("../../assets/club.png"), ".png")
        heart_texture = load_embeded_texture(#load("../../assets/heart.png"), ".png")
        diamond_texture = load_embeded_texture(#load("../../assets/diamond.png"), ".png")
        spade_texture = load_embeded_texture(#load("../../assets/spade.png"), ".png")
    }
    else {
        club_texture = raylib.LoadTexture("assets/club.png")
        heart_texture = raylib.LoadTexture("assets/heart.png")
        diamond_texture = raylib.LoadTexture("assets/diamond.png")
        spade_texture = raylib.LoadTexture("assets/spade.png")
    }
}

free :: proc() {
    raylib.UnloadTexture(club_texture)
    raylib.UnloadTexture(heart_texture)
    raylib.UnloadTexture(diamond_texture)
    raylib.UnloadTexture(spade_texture)
}