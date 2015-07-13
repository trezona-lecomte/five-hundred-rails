class Trick < ActiveRecord::Base
  MAX_CARDS = 4
  belongs_to :round
  has_many :cards

  validates :cards, length: { maximum: MAX_CARDS }

  def winning_card
    cards.max_by(&:number)
  end

  def won?
    cards.count == MAX_CARDS
  end
end
