user1 = User.create!(username: "kieran")
user2 = User.create!(username: "pragya")
user3 = User.create!(username: "mitch")
user4 = User.create!(username: "mikee")
user5 = User.create!(username: "invalid_guy")

game = CreateGame.new.call

JoinTeam.new.call(user1, game.teams.first)
JoinTeam.new.call(user2, game.teams.first)
JoinTeam.new.call(user3, game.teams.last)
JoinTeam.new.call(user4, game.teams.last)

deck = BuildDeck.new.call

DealRound.new.call(game, deck, [11, 21, 12, 22])

p1 = game.teams.first.players.first
p2 = game.teams.last.players.first
p3 = game.teams.first.players.last
p4 = game.teams.last.players.last
round = game.rounds.last

SubmitBid.call(round, p1, 6, Suits::DIAMONDS)
SubmitBid.call(round, p2, 6, Suits::HEARTS)
SubmitBid.call(round, p3, 7, Suits::SPADES)
SubmitBid.call(round, p4, 7, Suits::CLUBS)
SubmitBid.call(round, p1, 7, Suits::NO_TRUMPS)
SubmitBid.call(round, p2, 7, Suits::HEARTS) # should fail
SubmitBid.call(round, p2, 0, Suits::NO_TRUMPS)
SubmitBid.call(round, p3, 0, Suits::NO_TRUMPS)
SubmitBid.call(round, p4, 0, Suits::NO_TRUMPS)



PlayCard.call(round, p2, 4, "diamonds")

# Start a new trick - controller action / service?
t1 = round.tricks.create!

# Each player: Play a card from hand to trick - service
t1.update(cards: t1.cards << round.hands[0].cards.first)
t1.update(cards: t1.cards << round.hands[1].cards.first)
t1.update(cards: t1.cards << round.hands[2].cards.first)
t1.update(cards: t1.cards << round.hands[3].cards.first)

t1.save!

# who won?

# can a hand start the next trick?

# # Once won, see who won the trick - service?
# winning_player = trick.winning_player

# # Now it's the prior trick's winning player that starts: - service?
# t2 = round.tricks.create
# t2.cards << t1.winning_card.hand.sample.play

