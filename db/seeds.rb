# game 1:
game1 = Game.create!

JoinGame.new(game1, Faker::Internet.user_name).call
JoinGame.new(game1, Faker::Internet.user_name).call
JoinGame.new(game1, Faker::Internet.user_name).call
JoinGame.new(game1, Faker::Internet.user_name).call

start_round = StartRound.new(game1)
if start_round.call
  round = start_round.round
end

deck = BuildDeck.new.call

DealCards.new(game1, round, deck).call


# game 2:
game2 = Game.create!

JoinGame.new(game2, Faker::Internet.user_name).call
p1 = game2.players.last
JoinGame.new(game2, Faker::Internet.user_name).call
p2 = game2.players.last
JoinGame.new(game2, Faker::Internet.user_name).call
p3 = game2.players.last
JoinGame.new(game2, Faker::Internet.user_name).call
p4 = game2.players.last

start_round = StartRound.new(game2)
if start_round.call
  round = start_round.round
end

deck = BuildDeck.new.call

DealCards.new(game2, round, deck).call

# bidding:
SubmitBid.new(round, p1, 6, 0).call # p1 bids 6 spades
SubmitBid.new(round, p2, 6, 1).call # p2 bids 6 clubs
SubmitBid.new(round, p3, 7, 0).call # p3 bids 7 clubs
SubmitBid.new(round, p4, 7, 1).call # p4 bids 7 spades
SubmitBid.new(round, p1, 0, 0).call # p1 passes
SubmitBid.new(round, p2, 0, 0).call # p2 passes
SubmitBid.new(round, p3, 0, 0).call # p3 passes
SubmitBid.new(round, p4, 0, 0).call # p4 passes & wins the bidding

# playing:
#PlayCard.new(round, p1, p1.cards.sample).call
#PlayCard.new(round, p2, p2.cards.sample).call
#PlayCard.new(round, p3, p3.cards.sample).call
#PlayCard.new(round, p4, p4.cards.sample).call
