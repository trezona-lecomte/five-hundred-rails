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

PlayCard.new(round, p1, p1.cards.sample).call
PlayCard.new(round, p2, p2.cards.sample).call
PlayCard.new(round, p3, p3.cards.sample).call
PlayCard.new(round, p4, p4.cards.sample).call
