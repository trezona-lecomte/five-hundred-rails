game = Game.create!

JoinGame.new(game, Faker::Internet.user_name).call
p1 = game.players.last
JoinGame.new(game, Faker::Internet.user_name).call
p2 = game.players.last
JoinGame.new(game, Faker::Internet.user_name).call
p3 = game.players.last
JoinGame.new(game, Faker::Internet.user_name).call
p4 = game.players.last

round = game.rounds.create!

round.tricks.create!

DealCards.new(game, round).call





# round = game.rounds.create!

# # Card.r
# anks.each do |rank|
#   Card.suits.each do |suit|
#     unless suit == "no_suit"
#       round.cards.create!(rank: rank[0], suit: suit[0])
#     end
#   end
# end

# 4.times do
#   round.players.create!
# end
