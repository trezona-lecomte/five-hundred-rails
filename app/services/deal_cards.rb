class DealCards
  attr_reader :round, :game, :deck

  def initialize(round, deck)
    @round = round
    @game = round.game
    @deck = deck
  end

  def call
    deal_cards!
  end

  private

  def deal_cards!
    deal_hands!

    deal_kitty!
  end

  def deal_hands!
    game.players.each do |player|
      deck.pop(10).each do |card|
        card.round = round

        player.cards << card

        card.save!
      end
    end
  end

  def deal_kitty!
    deck.each do |card|
      card.round = round

      card.save!
    end
  end
end
