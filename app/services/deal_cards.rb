class DealCards
  def call(round:, deck:)
    round.kitty = CardCollection.new

    # 3 cards to kitty
    round.kitty.cards = deck.pop(3)

    # 10 cards to each hand
    round.hands.each { |hand| hand.cards = deck.pop(10) }
  end
end
