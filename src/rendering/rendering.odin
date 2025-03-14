package rendering

import "core:fmt"
import "vendor:raylib"

import "../models"
import "../assets"

draw_setup :: proc(state: models.SetupState) {
    screen_size := [2]f32 {f32(raylib.GetScreenWidth()), f32(raylib.GetScreenHeight())}

    // Draw title 
    draw_text_centered("FATJACK!", {screen_size.x / 2, 100 }, 64)

    // Draw controls
    draw_text_centered("Press P to add a human player!", {screen_size.x / 2, 200}, 48)
    draw_text_centered("Press A to add an AI player!", {screen_size.x / 2, 250}, 48)
    draw_text_centered("Press Backspace to remove a player!", {screen_size.x / 2, 300}, 48)

    if len(state.players) >= 2 {
        draw_text_centered("Press Enter to start game!", {screen_size.x / 2, 370}, 60)
    }

    // Draw player list
    player_draw_pos := [2]f32{screen_size.x / 2, 450}
    for player, index in state.players {

        player_string: cstring
        defer delete(player_string)
        if player == .Ai {
            player_string = fmt.caprintf("Player %d - (AI)", index + 1)
        }
        else {
            player_string = fmt.caprintf("Player %d - (Human)", index + 1)
        }

        draw_text_centered(player_string, player_draw_pos, 48) 
        player_draw_pos.y += 40
    }
}

draw_playing :: proc(state: models.PlayingState) {
    screen_size := [2]f32 {f32(raylib.GetScreenWidth()), f32(raylib.GetScreenHeight())}

    draw_pos := [2]f32{screen_size.x / 2, 50}

    for player, index in state.players {
        is_active := u32(index) == state.current_player_index

        // Draw the card and calculate hand sum
        card_sum := i32(0)
        card_pos := [2]f32{200, draw_pos.y + 60}
        for card in player.hand {
            draw_card(card_pos, card)
            card_pos.x += 100
            card_sum += models.card_value(card)
        }

        // Draw the hand sum value
        if card_sum <= 30 {
            sum_string := fmt.caprintf("Sum: %d", card_sum)
            defer delete(sum_string)
            draw_text(sum_string, {10, draw_pos.y + 20}, 50)
        }
        else {
            draw_text("BUST", {10, draw_pos.y + 20}, 50, color = raylib.RED)
        }

        // Draw the player & controls for players.
        player_string: cstring
        defer delete(player_string)
        if player.player_type == .Ai {
            player_string = fmt.caprintf("Player %d - (AI)", index + 1)
        }
        else {
            if is_active {
                player_string = fmt.caprintf("Player %d - (Human) - Space to hit, enter to hold", index + 1)
            }
            else {
                player_string = fmt.caprintf("Player %d - (Human)", index + 1)
            }
        }
        draw_text_centered(player_string, draw_pos, 40)
        draw_pos.y += 120
    }
}

draw_over :: proc(state: models.OverState) {
    screen_size := [2]f32 {f32(raylib.GetScreenWidth()), f32(raylib.GetScreenHeight())}

    // Game over text.
    draw_text_centered("Game Over!", {screen_size.x / 2, 100 }, 64)

    // Draw the winners info
    if len(state.winners) == 0 {
        draw_text_centered("Everyone bust! Nobody wins!", {screen_size.x / 2, 300 }, 64)
    }
    else {
        if len(state.winners) == 1 {
            draw_text_centered("Winner!", {screen_size.x / 2, 300 }, 64)
        }
        else {
            draw_text_centered("Winners!", {screen_size.x / 2, 300 }, 64)
        }

        draw_pos := [2]f32{screen_size.x / 2, 350}
        for winner_index in state.winners {
            winner := state.players[winner_index]

            player_string: cstring
            defer delete(player_string)
            if winner.player_type == .Ai {
                player_string = fmt.caprintf("Player %d - (AI)", winner_index + 1)
            }
            else {
                player_string = fmt.caprintf("Player %d - (Human)", winner_index + 1)
            }

            draw_text_centered(player_string, draw_pos, 60)
            draw_pos.y += 70

            sum_string := fmt.caprintf("Sum: %d", winner.sum)
            defer delete(sum_string)
            draw_text_centered(sum_string, draw_pos, 60)
            draw_pos.y += 70
        }
    }

    draw_text_centered("Press enter to play again", {screen_size.x / 2, screen_size.y - 180}, 64)
    draw_text_centered("Press escape to close game", {screen_size.x / 2, screen_size.y - 100}, 64)
}

draw_card :: proc(pos: [2]f32, card: models.Card) -> [2]f32 {
    CARD_SIZE :: [2]f32 { 50, 50 }

    suit_texture: raylib.Texture2D
    switch card.suit {
        case .Diamond: suit_texture = assets.diamond_texture
        case .Heart: suit_texture = assets.heart_texture
        case .Club: suit_texture = assets.club_texture
        case .Spade: suit_texture = assets.spade_texture
    }

    rank_string: cstring
    switch card.rank {
        case 0:  rank_string = "A"
        case 1:  rank_string = "2"
        case 2:  rank_string = "3"
        case 3:  rank_string = "4"
        case 4:  rank_string = "5"
        case 5:  rank_string = "6"
        case 6:  rank_string = "7"
        case 7:  rank_string = "8"
        case 8:  rank_string = "9"
        case 9:  rank_string = "10"
        case 10: rank_string = "J"
        case 11: rank_string = "Q"
        case 12: rank_string = "K"
    }

    draw_texture(suit_texture, pos - {CARD_SIZE.x / 3, 0}, CARD_SIZE / 2)
    draw_text_centered(rank_string, pos + {CARD_SIZE.x / 3, 0}, 60)

    return CARD_SIZE
}