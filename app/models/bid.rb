class Bid < ActiveRecord::Base
  include Suits
  enum suit: ALL_SUITS

  PASS_TRICKS = 0
  MIN_TRICKS  = 6
  MAX_TRICKS  = 10
  ALLOWED_TRICKS = [PASS_TRICKS] + (MIN_TRICKS..MAX_TRICKS).to_a

  belongs_to :round
  belongs_to :player

  validates :round, :player, :number_of_tricks, :suit, presence: true
  validates :number_of_tricks, inclusion: { in: ALLOWED_TRICKS }

  scope :passes,          -> { where(number_of_tricks: 0) }
  scope :in_ranked_order, -> { order(number_of_tricks: :desc, suit: :desc) }

  # def self.pass_bid
  #   self.new(suit: Suits::NO_SUIT, )
  # end
end
