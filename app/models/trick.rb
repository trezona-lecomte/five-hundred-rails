require 'card'

class Trick < ActiveRecord::Base
  # TODO has_many :cards, as: :playable
  belongs_to :round

  serialize :cards, Array

  def winning_card
    cards.max_by { |card| card.number }
  end

  def won?
    cards.count == 4
  end
end
