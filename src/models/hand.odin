package models

Hand :: [dynamic]Card

make_hand :: proc() -> Hand {
    return make(Hand)
}

free_hand :: proc(hand: Hand) {
    delete(hand)
}

add_card_to_hand :: proc(hand: ^Hand, card: Card) {
    append(hand, card)
}