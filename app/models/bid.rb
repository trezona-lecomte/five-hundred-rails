class Bid < ActiveRecord::Base
  enum suit: Suits::ALL_SUITS

  MIN_TRICKS = 6
  MAX_TRICKS = 10
  ALLOWED_TRICKS = (MIN_TRICKS..MAX_TRICKS).to_a

  belongs_to :round, touch: true
  belongs_to :player

  validates :round, :player,          presence: true
  validates :number_of_tricks, :suit, presence: true, unless: :pass
  validates :number_of_tricks, :suit, absence:  true, if: :pass
  validates :pass,                    inclusion: { in: [true, false] }
  validates :number_of_tricks,        inclusion: { in: ALLOWED_TRICKS, allow_nil: true }

  validate :bidding_is_open,                   if: :round
  validates_with BidIsHighEnoughValidator,     if: :round, unless: :pass
  validates_with BidderIsNextInOrderValidator, if: [:round, :player]

  scope :passes,           -> { where(pass: true) }
  scope :non_passes,       -> { where(pass: false) }
  scope :in_ranked_order,  -> { order(number_of_tricks: :desc, suit: :desc) }

  private

  def bidding_is_open
    unless round.in_bidding_stage?
      errors.add(:base, "bidding for this round has finished")
    end
  end
end
