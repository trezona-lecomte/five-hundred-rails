class Bid < ActiveRecord::Base
  include HasSuit

  belongs_to :round
  belongs_to :player

  #enum suit: %w(spades clubs diamonds hearts no_suit)

  validates :round, :player, :number_of_tricks, :suit, presence: true
end
