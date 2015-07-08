p1 = Player.create(name: "kieran")
p2 = Player.create(name: "pragya")
p3 = Player.create(name: "mitch")
p4 = Player.create(name: "mikee")

# Start a new game - controller action
game = Game.create

# Add players to the game - controller action?
game.players << p1 << p2 << p3 << p4

# Start a new round- controller action
round = game.rounds.create

load './app/services/build_deck.rb'

# Shuffle the deck - service?
deck = BuildDeck.new.call
deck.shuffle!

# Deal the kitty - service?
round.kitty = CardCollection.new
round.kitty.cards = deck.pop(3)

# Deal the hands - service?
game.players.each { |p| round.hands.create(player: p) }
round.hands.each { |hand| hand.cards = deck.pop(10) }

round.save! # ?
round.hands.each { |h| h.save! } # ?
round.kitty.save!

h1, h2, h3, h4 = round.hands

# Start a new trick - controller action
t1 = round.tricks.create

# Each player: Play a card from hand to trick - service
# t1.cards << h1.cards.smaple.play
# t1.cards << h2.cards.sample.play
# t1.cards << h3.cards.sample.play
# t1.cards << h4.cards.sample.play

# # Once won, see who won the trick - service?
# winning_player = trick.winning_player

# # Now it's the prior trick's winning player that starts: - service?
# t2 = round.tricks.create
# t2.cards << t1.winning_card.hand.sample.play

