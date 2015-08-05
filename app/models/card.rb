class Card < ActiveRecord::Base
  include HasSuit

  belongs_to :player
  belongs_to :round
  belongs_to :trick

  enum rank: %w(0 1 2 3 4 5 6 7 8 9 10 jack queen king ace joker)
  #enum suit: %w(spades clubs diamonds hearts no_suit)

  validates :round, presence: true
end
