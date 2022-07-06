function deal() {
    CARDS=$(draw 2 | jq -j '.cards | map(.code) | join(",")')
    curl -s https://www.deckofcardsapi.com/api/deck/$(deck_id)/pile/player/add/?cards=$CARDS
    echo $CARDS > /tmp/blackjack_hand
}

function hit() {
    CARD=$(draw 1 | jq .cards[0].code)
    curl -s https://www.deckofcardsapi.com/api/deck/$(deck_id)/pile/player/add/?cards=$CARD
    echo $CARD >> /tmp/blackjack_hand
}

function draw() {
    curl -s https://www.deckofcardsapi.com/api/deck/$(deck_id)/draw/?count=$1 
}

function reset() {
    rm /tmp/blackjack_hand
    curl -s https://www.deckofcardsapi.com/api/deck/$(deck_id)/pile/player/return/
}

# function score() {

# }

# function stay() {

# }

# function split() {

# }

function shuffle() {    
    curl -s https://www.deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1 \
        | jq -r .deck_id \
        > /tmp/blackjack_deck_id
}

function deck_id() {
    cat /tmp/blackjack_deck_id
}

# function hand() {

# }