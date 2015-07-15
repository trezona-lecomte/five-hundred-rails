class Trick < ActiveRecord::Base
  MAX_CARDS = 4

  belongs_to :round
  has_many :playing_cards

  validates :playing_cards, length: { maximum: MAX_CARDS }

  def winning_card
    playing_cards.max_by { |playing_card| playing_card.card.number }
  end

  def won?
    playing_cards.count == MAX_CARDS
  end
end
