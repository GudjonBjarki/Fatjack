package models

Suits :: enum { Spade, Heart, Club, Diamond }
Rank :: i32

Card :: struct {
    rank: Rank,
    suit: Suits
}


card_value :: proc(card: Card) -> i32 {
    // Jack, King, Queen = 10
    if card.rank == 10 || card.rank == 11 || card.rank == 12 {
        return 10
    }

    return card.rank + 1
}