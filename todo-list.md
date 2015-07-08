# TODO List

### The standard deck
Feature                         | Status |
--------------------------------|--------|
contains 43 playing cards       |  TODO  |
a Joker is included             |  TODO  |
2s, 3s and black 4s are removed |  TODO  |

### For each game
Feature                                                                   | Status |
--------------------------------------------------------------------------|--------|
players are on 'teams' of two                                             |  TODO  |
players on a team 'sit opposite' so won't play directly after one another |  TODO  |
a team wins if they reach a score of 500 or more across all rounds        |  TODO  |
a team loses if they reach a score of -500 or less across all rounds      |  TODO  |

### For each 'round'
Dealing Features:                                                               | Status |
--------------------------------------------------------------------------------|--------|
10 cards are dealt to each of the four players                                  |  TODO  |
3 cards are dealt into the 'kitty'                                              |  TODO  |
(first round) a random player deals                                             |  TODO  |
(subsequent rounds) the dealing responsibilty moves 'clockwise'                 |  TODO  |

Bidding Features:                                                               | Status |
--------------------------------------------------------------------------------|--------|
the player 'to the left' of the dealer bids first                         |  TODO  |
bidding continues 'clockwise' until all but one player has passed         |  TODO  |
players can only bid higher than the current bid, based on:               |  TODO  |
bids consist of a number of tricks and a suit                             |  TODO  |
the order of suits is no-trumps > hearts > diamonds > clubs > spades      |  TODO  |
the number of tricks can be between 6 and 10                              |  TODO  |
players can elect to pass (make no bid)                                   |  TODO  |
players can't bid again after passing                                     |  TODO  |
players can only bid again if another player has made an intervening bid  |  TODO  |
if no player bids, the deck is reshuffled and redealt                     |  TODO  |

Playing Features:                                                               | Status |
--------------------------------------------------------------------------------|--------|
(on the first trick) the player who won the bidding leads                       |  TODO  |
(on subsequent tricks) the winner of the last trick leads                       |  TODO  |
playing proceeds 'clockwise'                                                    |  TODO  |
players each must place a card on their turn                                    |  TODO  |
players must follow suit if they can (including LB)                             |  TODO  |
once all players have played a card, the highest card wins                      |  TODO  |
the trick is added to the teams total number of tricks                          |  TODO  |
once all 10 tricks are played, the round is over                                |  TODO  |

Scoring Features:                                                               | Status |
--------------------------------------------------------------------------------|--------|
rounds are scored according to the score table (below)                          |  TODO  |
if a team mets the bid tricks, add the bid score to their total                 |  TODO  |
if a team fails to meet the bid tricks, subtract the bid score from total       |  TODO  |

### For determining card equality
Features:                                                             | Status |
----------------------------------------------------------------------|--------|
in non-trump suits the order of cards is A -> 4                       |  TODO  |
in trump suits the order is JK -> RB -> LB -> A -> 4                  |  TODO  |
a trump card always beats a non-trump card                            |  TODO  |
if no trumps are played then the highest card of the led suit wins    |  TODO  |

### Scoring Table

Tricks    | Spades | Clubs | Diamonds | Hearts | No Trump |
----------|--------|-------|----------|--------|----------|
6 tricks  | 40     | 60    | 80       | 100    | 120      |
7 tricks  | 140    | 160   | 180      | 200    | 220      |
8 tricks  | 240    | 260   | 280      | 300    | 320      |
9 tricks  | 340    | 360   | 380      | 400    | 420      |
10 tricks | 440    | 460   | 480      | 500    | 520      |
