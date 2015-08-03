game = Game.create!

JoinGame.new(game, Faker::Internet.user_name).call
p1 = game.players.last
JoinGame.new(game, Faker::Internet.user_name).call
p2 = game.players.last
JoinGame.new(game, Faker::Internet.user_name).call
p3 = game.players.last
JoinGame.new(game, Faker::Internet.user_name).call
p4 = game.players.last

start_round = StartRound.new(game)
if start_round.call
  round = start_round.round
end

deck = BuildDeck.new.call

DealCards.new(game, round, deck).call

PlayCard.new(round, p1, p1.cards.sample).call
PlayCard.new(round, p2, p2.cards.sample).call
PlayCard.new(round, p3, p3.cards.sample).call
PlayCard.new(round, p4, p4.cards.sample).call
