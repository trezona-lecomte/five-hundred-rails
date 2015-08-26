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
      deck.pop(Game::HAND_SIZE).each do |card|
        card.update!(round: round, player: player)
      end
    end
  end

  def deal_kitty!
    deck.each do |card|
      card.update!(round: round)
    end
  end
end
