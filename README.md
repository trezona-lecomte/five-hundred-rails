# README
## Five Hundred [card game](https://en.wikipedia.org/wiki/500_(card_game))

## Features:

### The standard deck
  - contains 43 playing cards
  - a Joker is included
  - 2s, 3s and black 4s are removed

### For each game
 - players are on 'teams' of two
 - players on a team 'sit opposite' so won't play directly after one another
 - a team wins if they reach a score of 500 or more across all rounds
 - a team loses if they reach a score of -500 or less across all rounds

### For each 'round'
  - Dealing:
    * 10 cards are dealt to each of the four players
    * 3 cards are dealt into the 'kitty'
    * (first round) a random player deals
    * (subsequent rounds) the dealing responsibilty moves 'clockwise'
  - Bidding:
    * the player 'to the left' of the dealer bids first
    * bidding continues 'clockwise' until all but one player has passed
    * players can only bid higher than the current bid, based on:
      + bids consist of a number of tricks and a suit
      + the order of suits is no-trumps > hearts > diamonds > clubs > spades
    * the number of tricks can be between 6 and 10
    * players can elect to pass (make no bid)
    * players can't bid again after passing
    * players can only bid again if another player has made an intervening bid
    * if no player bids, the deck is reshuffled and redealt
  - Playing Tricks:
    * (on the first trick) the player who won the bidding leads
    * (on subsequent tricks) the winner of the last trick leads
    * playing proceeds 'clockwise'
    * players each must place a card on their turn
    * players must follow suit if they can (including LB)
    * once all players have played a card, the highest card wins
    * the trick is added to the teams total number of tricks
    * once all 10 tricks are played, the round is over
  - Scoring a round:
    * rounds are scored according to the score table (below)
    * if a team mets the bid tricks, add the bid score to their total
    * if a team fails to meet the bid tricks, subtract the bid score from total

### For determining card equality
 - in non-trump suits the order of cards is A -> 4
 - in trump suits the order is JK -> RB -> LB -> A -> 4
 - a trump card always beats a non-trump card
 - if no trumps are played then the highest card of the led suit wins

### Scoring Table

Tricks    | Spades | Clubs | Diamonds | Hearts | No Trump |
----------|--------|-------|----------|--------|----------|
6 tricks  | 40     | 60    | 80       | 100    | 120      |
7 tricks  | 140    | 160   | 180      | 200    | 220      |
8 tricks  | 240    | 260   | 280      | 300    | 320      |
9 tricks  | 340    | 360   | 380      | 400    | 420      |
10 tricks | 440    | 460   | 480      | 500    | 520      |


