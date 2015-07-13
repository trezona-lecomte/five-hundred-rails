class DealRound
  def call(game, deck, playing_order)
    deck.shuffle!

    round = game.rounds.create!(playing_order: playing_order)

    round.kitty = CardCollection.create!
    round.kitty.cards = deck.pop(3)

    game.players.each do |player|
      hand = round.hands.create!(player: player)
      hand.cards = deck.pop(10)
    end
  end
end

