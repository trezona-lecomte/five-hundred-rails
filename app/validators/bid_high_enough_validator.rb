class BidHighEnoughValidator < SimpleDelegator
  include ActiveModel::Validations

  validate :bid_is_high_enough

  private

  def bid_is_high_enough
    unless pass? || first_in_round? || above_previous_bid?
      errors.add(:base, "your bid isn't high enough")
    end
  end

  def pass?
    number_of_tricks == Bid::PASS_TRICKS
  end

  def first_in_round?
    round.bids.none?
  end

  def above_previous_bid?
    number_of_tricks > highest_bid.number_of_tricks ||
      number_of_tricks == highest_bid.number_of_tricks && Bid.suits[suit] > Bid.suits[highest_bid.suit]
  end
end
