user1 = User.create!(email: "user1@example.com", username: "user1", password: "password")
user2 = User.create!(email: "user2@example.com", username: "user2", password: "password")
user3 = User.create!(email: "user3@example.com", username: "user3", password: "password")
user4 = User.create!(email: "user4@example.com", username: "user4", password: "password")

# game 1:
game1 = Game.create!

 JoinGame.new(game: game1, user: user1).call
JoinGame.new(game: game1, user: user2).call
JoinGame.new(game: game1, user: user3).call
JoinGame.new(game: game1, user: user4).call

start_round = StartRound.new(game: game1)
start_round.call

# game 2:
game2 = Game.create!

jg = JoinGame.new(game: game2, user: user1)
jg.call
p1 = jg.player
jg = JoinGame.new(game: game2, user: user2)
jg.call
p2 = jg.player
jg = JoinGame.new(game: game2, user: user3)
jg.call
p3 = jg.player
jg = JoinGame.new(game: game2, user: user4)
jg.call
p4 = jg.player

start_round = StartRound.new(game: game2)
start_round.call
round = start_round.round

# bidding:
bid = Bid.new(round: round, player: p1, number_of_tricks: 6, suit: Suits::SPADES)
bid.save!
round.reload
bid = Bid.new(round: round, player: p2, number_of_tricks: 6, suit: Suits::CLUBS)
bid.save!
round.reload
bid = Bid.new(round: round, player: p3, number_of_tricks: 7, suit: Suits::SPADES)
bid.save!
round.reload
bid = Bid.new(round: round, player: p4, number_of_tricks: 7, suit: Suits::CLUBS)
bid.save!
round.reload
bid = Bid.new(round: round, player: p1, pass: true)
bid.save!
round.reload
bid = Bid.new(round: round, player: p2, pass: true)
bid.save!
round.reload
bid = Bid.new(round: round, player: p3, pass: true)
bid.save!
round.reload

pc4 = PlayCard.new(round: round, player: p4, card: p4.cards.sample)
pc1 = PlayCard.new(round: round, player: p1, card: p1.cards.sample)
pc2 = PlayCard.new(round: round, player: p2, card: p2.cards.sample)
pc3 = PlayCard.new(round: round, player: p3, card: p3.cards.sample)

# playing:
pc4.call
pc1.call
pc2.call
pc3.call

# Finished round:
game3 = Game.create!

JoinGame.new(game: game3, user: user1).call
p1 = game3.players.last
JoinGame.new(game: game3, user: user2).call
p2 = game3.players.last
JoinGame.new(game: game3, user: user3).call
p3 = game3.players.last
JoinGame.new(game: game3, user: user4).call
p4 = game3.players.last

start_round = StartRound.new(game: game3)
start_round.call
round = start_round.round

# bidding:
bid = Bid.new(round: round, player: p1, number_of_tricks: 6, suit: Suits::CLUBS)
bid.save!
round.reload
bid = Bid.new(round: round, player: p2, pass: true)
bid.save!
round.reload
bid = Bid.new(round: round, player: p3, pass: true)
bid.save!
round.reload
bid = Bid.new(round: round, player: p4, pass: true)
bid.save!
round.reload

# until decorated_round.finished?
#   trick = decorated_round.current_trick

#   #playing:
#   pc1 = PlayCard.new(trick: trick, player: p1, card: p1.cards.where(trick: nil).sample)
#   pc2 = PlayCard.new(trick: trick, player: p2, card: p2.cards.where(trick: nil).sample)
#   pc3 = PlayCard.new(trick: trick, player: p3, card: p3.cards.where(trick: nil).sample)
#   pc4 = PlayCard.new(trick: trick, player: p4, card: p4.cards.where(trick: nil).sample)

#   pc1.call
#   pc2.call
#   pc3.call
#   pc4.call
# end

score_round = ScoreRound.new(round)
score_round.call

start_round = StartRound.new(game: game3)
start_round.call


# Almost finished round:
game4 = Game.create!

JoinGame.new(game: game4, user: user1).call
p1 = game4.players.last
JoinGame.new(game: game4, user: user2).call
p2 = game4.players.last
JoinGame.new(game: game4, user: user3).call
p3 = game4.players.last
JoinGame.new(game: game4, user: user4).call
p4 = game4.players.last

start_round = StartRound.new(game: game4)
start_round.call
round = start_round.round

# bidding:
bid = Bid.new(round: round, player: p1, number_of_tricks: 6, suit: Suits::CLUBS)
bid.save!
round.reload
bid = Bid.new(round: round, player: p2, pass: true)
bid.save!
round.reload
bid = Bid.new(round: round, player: p3, pass: true)
bid.save!
round.reload
bid = Bid.new(round: round, player: p4, pass: true)
bid.save!
round.reload
r
# until round.cards.where(trick: nil).count == 3

#   #playing:
#   pc1 = PlayCard.new(round: round, player: p1, card: p1.cards.where(trick: nil).sample)
#   pc2 = PlayCard.new(round: round, player: p2, card: p2.cards.where(trick: nil).sample)
#   pc3 = PlayCard.new(round: round, player: p3, card: p3.cards.where(trick: nil).sample)
#   pc4 = PlayCard.new(round: round, player: p4, card: p4.cards.where(trick: nil).sample)

#   if pc1.card
#     pc1.call unless round.current_trick.order_in_round == 9 && round.current_trick.cards.count == 3
#   end

#   round.reload

#   if pc2.card
#     pc2.call unless round.current_trick.order_in_round == 9 && round.current_trick.cards.count == 3
#   end

#   round.reload

#   if pc3.card
#     pc3.call unless round.current_trick.order_in_round == 9 && round.current_trick.cards.count == 3
#   end

#   round.reload

#   if pc4.card
#     pc4.call unless round.current_trick.order_in_round == 9 && round.current_trick.cards.count == 3
#   end

#   round.reload
# end
