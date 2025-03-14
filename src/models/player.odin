package models

PlayerType :: enum { Player, Ai }


PlayerState :: struct {
    player_type: PlayerType,
    hand: Hand,
}

make_player_state :: proc(type: PlayerType) -> PlayerState {
    return {
        player_type = type,
        hand = make_hand()
    }
}

free_player_state :: proc(state: PlayerState) {
    free_hand(state.hand)
}


PlayerSum :: struct {
    player_type: PlayerType,
    sum: i32,
}

make_player_sum :: proc(type: PlayerType, hand: Hand) -> PlayerSum {
    sum := i32(0)
    for card in hand {
        sum += card_value(card)
    }

    return {
        type,
        sum
    }
}
