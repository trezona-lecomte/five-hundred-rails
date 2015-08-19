class Bid < ActiveRecord::Base
  enum suit: %w(spades clubs diamonds hearts no_suit)

  belongs_to :round
  belongs_to :player

  validates :round, :player, :number_of_tricks, :suit, presence: true

  scope :passes,          -> { where(number_of_tricks: 0) }
  scope :in_ranked_order, -> { order(number_of_tricks: :desc, suit: :desc) }

  # def self.pass_bid
  #   self.new(suit: Suits::NO_SUIT, )
  # end
end
