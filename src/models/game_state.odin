package models

SetupState :: struct {
    players: [dynamic]PlayerType
}

make_setup_state :: proc() -> SetupState {
    return {
        players = make([dynamic]PlayerType)
    }
}

free_setup_state :: proc(state: SetupState) {
    delete(state.players)
}

add_setup_player :: proc(state: ^SetupState, player_type: PlayerType) {
    append(&state.players, player_type)
}

remove_setup_player :: proc(state: ^SetupState) {
    if len(state.players) == 0 {
        return
    }

    pop(&state.players)
}


PlayingState :: struct {
    current_player_index: u32,
    players: [dynamic]PlayerState,
    deck: Deck
}

make_playing_state :: proc(players: []PlayerType) -> PlayingState {
    player_states := make([dynamic]PlayerState)
    for player_type in players {
        append(&player_states, make_player_state(player_type))
    }

    deck := make_deck()  
    shuffle_deck(&deck)

    state := PlayingState {
        current_player_index = 0,
        players = player_states,
        deck = deck
    }

    return state
}

free_playing_state :: proc(state: PlayingState) {
    for player in state.players {
        free_player_state(player)
    }

    delete(state.players)

    free_deck(state.deck)
}


OverState :: struct {
    players: [dynamic]PlayerSum,
    winners: [dynamic]i32
}

make_over_state :: proc(players: []PlayerState) -> OverState {
    sums := make([dynamic]PlayerSum, len(players))
    winners := make([dynamic]i32)

    // Start with one so we don't count busted players as winners.
    best_sum := i32(1)

    for player, i in players {
        sum := make_player_sum(player.player_type, player.hand)
        sums[i] = sum

        if sum.sum <= 30 && sum.sum > best_sum {
            best_sum = sum.sum
            clear(&winners)
        }
        if sum.sum == best_sum {
            append(&winners, i32(i))
        }
    }

    return OverState {
        sums,
        winners
    }
}

free_over_state :: proc(state: OverState) {
    delete(state.players)
    delete(state.winners)
}

GameState :: union { SetupState, PlayingState, OverState }

free_state :: proc(game_state: GameState) {
    switch state in game_state {
        case SetupState: free_setup_state(state)
        case PlayingState: free_playing_state(state)
        case OverState: free_over_state(state)
    }
}
