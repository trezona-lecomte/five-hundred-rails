class BidHighEnoughValidator < ActiveModel::Validator
  def validate(submit_bid)
    unless first_in_round?(submit_bid.round)  ||
           above_previous_bid?(submit_bid.round.highest_bid, submit_bid.number_of_tricks, submit_bid.suit)

      submit_bid.errors.add(:base, "your bid isn't high enough")
    end
  end

  private

  # def pass?(submit_bid)
  #   submit_bid.pass
  # end

  def first_in_round?(round)
    round.bids.none?
  end

  def above_previous_bid?(highest_bid, number_of_tricks, suit)
    highest_bid.nil? ||
      number_of_tricks > highest_bid.number_of_tricks ||
      number_of_tricks == highest_bid.number_of_tricks && Bid.suits[suit] > Bid.suits[highest_bid.suit]
  end
end
