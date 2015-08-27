class SubmitBidValidator < SimpleDelegator
  include ActiveModel::Validations

  # validate BiddingMustBeOpenForThisRound
  # validate PlayerMustBeTheNextBidder
  # validate BidMustBeHighEnough
  validate       :bidding_is_open
  validates_with BidderTurnValidator, fields: [:round, :player]
  validates_with BidHighEnoughValidator, fields: [:round, :number_of_tricks, :suit]

  private

  def bidding_is_open
    errors.add(:base, "bidding for this round has finished") unless round.in_bidding_stage?
  end
end
