package models

import "core:math/rand"

Deck :: [dynamic]Card

make_deck :: proc() -> Deck {
    deck := make(Deck)
    
    for rank in 0..<13 {
        for suit in 0..<4 {
            card := Card {
                rank = Rank(rank),
                suit = Suits(suit),
            }

            append(&deck, card)
        }
    }

    return deck
}

free_deck :: proc(deck: Deck) {
    delete(deck)
}

shuffle_deck :: proc(deck: ^Deck) {
    rand.shuffle(deck[:])
}

draw_from_deck :: proc(deck: ^Deck) -> Card {
    return pop(deck)
}
