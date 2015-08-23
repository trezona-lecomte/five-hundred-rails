class Bid < ActiveRecord::Base
  include Suits
  enum suit: ALL_SUITS

  PASS_TRICKS = 0
  MIN_TRICKS  = 6
  MAX_TRICKS  = 10
  ALLOWED_TRICKS = [PASS_TRICKS] + (MIN_TRICKS..MAX_TRICKS).to_a

  belongs_to :round, touch: true
  belongs_to :player

  validates :round, :player, :number_of_tricks, :suit, presence: true
  validates :number_of_tricks, inclusion: { in: ALLOWED_TRICKS }

  scope :passes,          -> { where(number_of_tricks: PASS_TRICKS) }
  scope :non_passes,      -> { where.not(number_of_tricks: PASS_TRICKS)}
  scope :in_ranked_order, -> { order(number_of_tricks: :desc, suit: :desc) }

  def self.params_for_pass_bid
    { number_of_tricks: PASS_TRICKS, suit: NO_SUIT }
  end
end
