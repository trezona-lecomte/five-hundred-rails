p1 = Player.create(name: "kieran")
p2 = Player.create(name: "pragya")
p3 = Player.create(name: "mitch")
p4 = Player.create(name: "mikee")

# Start a new game - controller action
game = Game.create

# Create the 2 teams
team1 = game.teams.create
team2 = game.teams.create

# Add players to the teams
team1.players = [p1, p2]   # assign_players
team2.players = [p3, p4]   # assign_players

# Start a new round- controller action
round = game.rounds.create

load './app/services/build_deck.rb'

# Start a new round
round.kitty = CardCollection.new                        # start_round
game.teams.each do |team|
  team.players.each do |player|
    round.hands.create(player: player)
  end
end

# Build a new deck
deck = BuildDeck.new.call                               # build_deck

# Deal the hands
deck.shuffle!                                           # deal_cards
round.kitty.cards = deck.pop(3)                         # deal_cards
round.hands.each { |hand| hand.cards = deck.pop(10) }   # deal_cards

h1, h2, h3, h4 = round.hands # not needed

# Start a new trick - controller action
t1 = round.tricks.create # not needed

# Each player: Play a card from hand to trick - service
t1.cards << h1.cards.smaple
t1.cards << h2.cards.sample
t1.cards << h3.cards.sample
t1.cards << h4.cards.sample

# # Once won, see who won the trick - service?
# winning_player = trick.winning_player

# # Now it's the prior trick's winning player that starts: - service?
# t2 = round.tricks.create
# t2.cards << t1.winning_card.hand.sample.play

