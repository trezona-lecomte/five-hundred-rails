class Trick < ActiveRecord::Base
  # TODO has_many :cards, as: :playable
  belongs_to :round
  has_many :cards

  def won?
    cards.count == 4
  end

  def winning_card
    cards.max_by { |card| card.number }
  end

  def winning_player
    winning_card.card_collection.player
  end
end
