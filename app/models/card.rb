class Card < ActiveRecord::Base
  belongs_to :player
  belongs_to :round
  belongs_to :trick

  enum rank: %w(4 5 6 7 8 9 10 jack queen king ace joker)
  enum suit: %i(spades clubs diamonds hearts no_suit)

  validates :round, presence: true
end
