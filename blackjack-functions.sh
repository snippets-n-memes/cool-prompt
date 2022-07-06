function deal() {
    CARDS=$(curl https://www.deckofcardsapi.com/api/deck/$(deck_id)/draw/?count=2 \
           | jq -j '.cards | map(.code) | join(",")')
    
    curl https://www.deckofcardsapi.com/api/deck/$(deck_id)/pile/player/add/?cards=$CARDS
}

function hit() {
    CARD=$(curl https://www.deckofcardsapi.com/api/deck/$(deck_id)/draw/?count=1 \
            | jq .cards[0].code)

    curl https://www.deckofcardsapi.com/api/deck/$(deck_id)/pile/player/add/?cards=$CARD
}

function stay() {

}

function split() {

}

function shuffle() {    
    curl https://www.deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1 \
        | jq .deck_id /tmp/blackjack_deck.json \
        > /tmp/blackjack_deck_id
}

function deck_id() {
    cat /tmp/blackjack_deck_id
}