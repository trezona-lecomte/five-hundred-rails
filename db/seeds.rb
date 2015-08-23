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

start_round = StartRound.new(game1)
start_round.call
round = start_round.round

# game 2:
game2 = Game.create!

JoinGame.new(game: game2, user: user1).call
p1 = game2.players.last
JoinGame.new(game: game2, user: user2).call
p2 = game2.players.last
JoinGame.new(game: game2, user: user3).call
p3 = game2.players.last
JoinGame.new(game: game2, user: user4).call
p4 = game2.players.last

start_round = StartRound.new(game2)
start_round.call
round = start_round.round

# bidding:
SubmitBid.new(round, p1, 6, 0).call # p1 bids 6 spades
SubmitBid.new(round, p2, 6, 1).call # p2 bids 6 clubs
SubmitBid.new(round, p3, 7, 0).call # p3 bids 7 clubs
SubmitBid.new(round, p4, 7, 1).call # p4 bids 7 spades
SubmitBid.new(round, p1, 0, 0).call # p1 passes
SubmitBid.new(round, p2, 0, 0).call # p2 passes
SubmitBid.new(round, p3, 0, 0).call # p3 passes
SubmitBid.new(round, p4, 0, 0).call # p4 passes & wins the bidding

trick = round.current_trick

pc4 = PlayCard.new(trick, p4, p4.cards.sample)
pc1 = PlayCard.new(trick, p1, p1.cards.sample)
pc2 = PlayCard.new(trick, p2, p2.cards.sample)
pc3 = PlayCard.new(trick, p3, p3.cards.sample)

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

start_round = StartRound.new(game3)
start_round.call
round = start_round.round

# bidding:
SubmitBid.new(round, p1, 6, 0).call # p1 bids 7 hearts
SubmitBid.new(round, p2, 0, 0).call # p2 passes
SubmitBid.new(round, p3, 0, 0).call # p3 passes
SubmitBid.new(round, p4, 0, 0).call # p4 passes so player 1 wins the bidding

decorated_round = round

until decorated_round.finished?
  trick = decorated_round.current_trick

  #playing:
  pc1 = PlayCard.new(trick, p1, p1.cards.where(trick: nil).sample)
  pc2 = PlayCard.new(trick, p2, p2.cards.where(trick: nil).sample)
  pc3 = PlayCard.new(trick, p3, p3.cards.where(trick: nil).sample)
  pc4 = PlayCard.new(trick, p4, p4.cards.where(trick: nil).sample)

  pc1.call
  pc2.call
  pc3.call
  pc4.call
end

score_round = ScoreRound.new(round)
score_round.call

start_round = StartRound.new(game3)
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

start_round = StartRound.new(game4)
start_round.call
round = start_round.round

# bidding:
SubmitBid.new(round, p1, 6, 0).call # p1 bids 7 hearts
SubmitBid.new(round, p2, 0, 0).call # p2 passes
SubmitBid.new(round, p3, 0, 0).call # p3 passes
SubmitBid.new(round, p4, 0, 0).call # p4 passes so player 1 wins the bidding

decorated_round = round

until decorated_round.cards.where(trick: nil).count == 4
  trick = decorated_round.current_trick

  #playing:
  pc1 = PlayCard.new(trick, p1, p1.cards.where(trick: nil).sample)
  pc2 = PlayCard.new(trick, p2, p2.cards.where(trick: nil).sample)
  pc3 = PlayCard.new(trick, p3, p3.cards.where(trick: nil).sample)
  pc4 = PlayCard.new(trick, p4, p4.cards.where(trick: nil).sample)

  pc1.call unless trick.order_in_round == 10 && trick.cards.count == 3
  pc2.call unless trick.order_in_round == 10 && trick.cards.count == 3
  pc3.call unless trick.order_in_round == 10 && trick.cards.count == 3
  pc4.call unless trick.order_in_round == 10 && trick.cards.count == 3
end
