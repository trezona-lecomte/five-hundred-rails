class Bid < ActiveRecord::Base
  enum suit: Suits::ALL_SUITS

  MIN_TRICKS = 6
  MAX_TRICKS = 10
  ALLOWED_TRICKS = (MIN_TRICKS..MAX_TRICKS).to_a

  belongs_to :round,  inverse_of: :bids, touch: true
  belongs_to :player, inverse_of: :bids

  validates :round, :player,          presence: true
  validates :number_of_tricks, :suit, presence: true, unless: :pass
  validates :number_of_tricks, :suit, absence:  true, if: :pass
  validates :pass,                    inclusion: { in: [true, false] }
  validates :number_of_tricks,        inclusion: { in: ALLOWED_TRICKS, allow_nil: true }

  validate :bidding_is_open,                   if: :round
  validates_with BidIsHighEnoughValidator,     if: :round, unless: :pass
  validates_with BidderIsNextInOrderValidator, if: [:round, :player]

  def self.passes
     select(&:pass?)
  end

  def self.non_passes
    select(&:non_pass?)
  end

  def non_pass?
    !pass
  end

  def self.highest
    non_passes.sort_by { |bid| [bid.number_of_tricks, bid.suit] }.first
  end

  private

  def bidding_is_open
    unless round.in_bidding_stage?
      errors.add(:base, "bidding for this round has finished")
    end
  end
end
