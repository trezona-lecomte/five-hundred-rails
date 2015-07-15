require_dependency 'decks'

class BuildDeck
  attr_reader :deck_type, :cards

  def initialize(deck_type)
    @deck_type = "#{deck_type.downcase}_deck"
  end

  def call
    @cards = Decks.send(deck_type).collect do |card|
      Card.where(number: card[:number], suit: card[:suit]).first
    end
  end
end
