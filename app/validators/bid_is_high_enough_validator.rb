class BidIsHighEnoughValidator < ActiveModel::Validator
  def validate(bid)
    unless bid.round.has_no_bids_yet? ||
           higher_than_current_highest_bid?(
             bid.suit,
             bid.number_of_tricks,
             bid.round.highest_bid
           )
      bid.errors.add(:base, "your bid isn't high enough")
    end
  end

  private

  def higher_than_current_highest_bid?(suit, number_of_tricks, highest_bid)
    highest_bid.nil? ||
      number_of_tricks > highest_bid.number_of_tricks ||
      number_of_tricks == highest_bid.number_of_tricks && Bid.suits[suit] > Bid.suits[highest_bid.suit]
  end
end
