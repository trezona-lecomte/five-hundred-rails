class BidHighEnoughValidator < ActiveModel::Validator
  def validate(submit_bid)
    unless pass?(submit_bid.number_of_tricks) ||
           first_in_round?(submit_bid.round)  ||
           above_previous_bid?(submit_bid.round.highest_bid, submit_bid.number_of_tricks, submit_bid.suit)
      submit_bid.errors.add(:base, "your bid isn't high enough")
    end
  end

  private

  def pass?(number_of_tricks)
    number_of_tricks == Bid::PASS_TRICKS
  end

  def first_in_round?(round)
    round.bids.none?
  end

  def above_previous_bid?(highest_bid, number_of_tricks, suit)
    number_of_tricks > highest_bid.number_of_tricks ||
    number_of_tricks == highest_bid.number_of_tricks && Bid.suits[suit] > Bid.suits[highest_bid.suit]
  end
end
