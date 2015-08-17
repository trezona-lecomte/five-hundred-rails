user1 = User.create!(email: "user1@example.com", username: "user1", password: "password")
user2 = User.create!(email: "user2@example.com", username: "user2", password: "password")
user3 = User.create!(email: "user3@example.com", username: "user3", password: "password")
user4 = User.create!(email: "user4@example.com", username: "user4", password: "password")

# game 1:
game1 = Game.create!

JoinGame.new(game1, user1).call
JoinGame.new(game1, user2).call
JoinGame.new(game1, user3).call
JoinGame.new(game1, user4).call

start_round = StartRound.new(game1)
if start_round.call
  round = start_round.round
end

deck = BuildDeck.new.call

DealCards.new(game1, round, deck).call


# game 2:
game2 = Game.create!

JoinGame.new(game2, user1).call
p1 = game2.players.last
JoinGame.new(game2, user2).call
p2 = game2.players.last
JoinGame.new(game2, user3).call
p3 = game2.players.last
JoinGame.new(game2, user4).call
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

trick = RoundsDecorator.new(round).active_trick

pc4 = PlayCard.new(trick, p4, p4.cards.sample)
pc1 = PlayCard.new(trick, p1, p1.cards.sample)
pc2 = PlayCard.new(trick, p2, p2.cards.sample)
pc3 = PlayCard.new(trick, p3, p3.cards.sample)

# playing:
pc4.call
pc1.call
pc2.call
pc3.call


# Finished game:
game3 = Game.create!

JoinGame.new(game3, user1).call
p1 = game3.players.last
JoinGame.new(game3, user2).call
p2 = game3.players.last
JoinGame.new(game3, user3).call
p3 = game3.players.last
JoinGame.new(game3, user4).call
p4 = game3.players.last

start_round = StartRound.new(game3)
start_round.call
round = start_round.round

deck = BuildDeck.new.call

DealCards.new(game3, round, deck).call

# bidding:
SubmitBid.new(round, p1, 6, 0).call # p1 bids 7 hearts
SubmitBid.new(round, p2, 0, 0).call # p2 passes
SubmitBid.new(round, p3, 0, 0).call # p3 passes
SubmitBid.new(round, p4, 0, 0).call # p4 passes so player 1 wins the bidding


10.times do |_|
  trick = RoundsDecorator.new(round).active_trick

  #playing:
  pc1 = PlayCard.new(trick, p1, p1.cards.where(trick: nil).sample)
  pc2 = PlayCard.new(trick, p2, p2.cards.where(trick: nil).sample)
  pc3 = PlayCard.new(trick, p3, p3.cards.where(trick: nil).sample)
  pc4 = PlayCard.new(trick, p4, p4.cards.where(trick: nil).sample)

  pc1.call
  pc2.call
  pc3.call
  pc4.call

#  binding.pry if pc1.errors.present? || pc2.errors.present? || pc3.errors.present? || pc4.errors.present?
end
