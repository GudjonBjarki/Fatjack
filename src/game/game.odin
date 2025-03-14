package game

import "core:fmt"
import "core:math/rand"
import "vendor:raylib"

import "../models"
import "../rendering"

run_game :: proc() {
    game_state: models.GameState = models.make_setup_state()
    defer models.free_state(game_state)

    for game_state != nil && !raylib.WindowShouldClose() {
        // Start drawing
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.WHITE)

        game_state = game_tick(game_state)

        raylib.EndDrawing()
    }
}

game_tick :: proc(game_state: models.GameState) -> models.GameState {
    switch state in game_state {
        case models.SetupState:
            return setup_tick(state)

        case models.PlayingState:
            return playing_tick(state)
        
        case models.OverState:
            return over_tick(state)
    }

    return game_state
}

setup_tick :: proc(setup_state: models.SetupState) -> models.GameState {
    // Clone the state so we can reference it.
    state := setup_state


    // Read player input

        // Press P to add a human player.
        if raylib.IsKeyPressed(.P) {
            models.add_setup_player(&state, .Player)
        }

        // Press A to add a AI player.
        if raylib.IsKeyPressed(.A) {
            models.add_setup_player(&state, .Ai)
        }

        // Press backspace to remove player
        if raylib.IsKeyPressed(.BACKSPACE) {
            models.remove_setup_player(&state)
        }

        // Press enter to accept current players.
        // Only valid if there's at least 2 players
        if raylib.IsKeyPressed(.ENTER) && len(state.players) >= 2 {
            // Construct the new playing state
            playing_state := models.make_playing_state(state.players[:])

            // Free the setup state
            models.free_setup_state(state)

            return playing_state
        }

    // Draw the game
        rendering.draw_setup(state)

    return state
}

playing_tick :: proc(playing_state: models.PlayingState) -> models.GameState {
    // Clone the state so we can reference it 
    state := playing_state

    // Let the current player play their turn
    playing_player := &state.players[state.current_player_index]
    if player_play_turn(playing_player, &state.deck) {
        state.current_player_index += 1
    }

    // If all players are done. move to the game over state.
    if state.current_player_index >= u32(len(state.players)) {
        over_state := models.make_over_state(state.players[:])

        models.free_playing_state(state)

        return over_state
    }

    // render the state
    rendering.draw_playing(state)

    return state
}

over_tick :: proc(over_state: models.OverState) -> models.GameState {
    state := over_state

    // Enter to restart game
    if raylib.IsKeyPressed(.ENTER) {
        models.free_over_state(state)
        return models.make_setup_state()
    }

    // render the state
    rendering.draw_over(state)

    return state
}


player_play_turn :: proc(player: ^models.PlayerState, deck: ^models.Deck) -> bool {
    if player.player_type == .Ai {
        return ai_play_turn(player, deck)
    }
    else {
        return human_play_turn(player, deck)
    }
}

human_play_turn :: proc(player: ^models.PlayerState, deck: ^models.Deck) -> bool {
    hand_sum := i32(0)
    for card in player.hand {
        hand_sum += models.card_value(card)
    }

    // Automatically hold if player is bust
    if hand_sum > 30 {
        return true
    }


    // Space to Hit
    if raylib.IsKeyPressed(.SPACE) {
        models.add_card_to_hand(&player.hand, models.draw_from_deck(deck))
    }

    // Enter to Hold
    if raylib.IsKeyPressed(.ENTER) {
        return true
    }


    return false
}

ai_play_turn :: proc(player: ^models.PlayerState, deck: ^models.Deck) -> bool {
    // Add random delay so ai players don't play instantly.
    // Not how you should do it but shit works.
    // Also only sleep if hand is not empty. Avoids freeze when swapping from setup scene if first player is ai
    if len(player.hand) > 0 {
        raylib.WaitTime(rand.float64_range(0.3, 0.8))
    }

    hand_sum := i32(0)
    for card in player.hand {
        hand_sum += models.card_value(card)
    }

    if hand_sum < 24{
        // AI always hits when under 24
        models.add_card_to_hand(&player.hand, models.draw_from_deck(deck))
        return false
    }
    else {
        // Ai always holds on 24 or greater
        return true
    }
}