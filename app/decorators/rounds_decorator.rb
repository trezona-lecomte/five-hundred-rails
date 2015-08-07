class RoundsDecorator < SimpleDelegator
  def hands
    cards.includes(:player).where("player_id is not null").group_by { |card| card.player }
  end

  def kitty
    cards.includes(:player).where("player_id is null")
  end

  def passes
    bids.includes(:player).where(number_of_tricks: 0)
  end

  def winning_bid
    bids.includes(:player).order(number_of_tricks: :desc, suit: :desc).first
  end

  def bidding?
    # TODO: need to deal with the situation where everyone passes
    passes.group_by { |pass| pass.player }.count < (game.players.count - 1)
  end

  def playing?
    !bidding? && tricks.count < 10 && tricks.last.cards.count < 4
  end

  def available_bids
    if winning_bid
      pass_bid + bids_above_highest_bid(non_pass_bids, winning_bid)
    else
      pass_bid + non_pass_bids
    end
  end

  private

  def bids_above_highest_bid(non_pass_bids, highest_bid)
    highest_tricks = highest_bid.number_of_tricks
    highest_suit = highest_bid.suit

    non_pass_bids.select do |number_of_tricks, suit|
       number_of_tricks  > highest_tricks ||
      (number_of_tricks == highest_tricks && Bid.suits[suit] > Bid.suits[highest_suit])
    end
  end

  def non_pass_bids
    (6..10).to_a.product(Bid.suits.keys)
  end

  def pass_bid
    [[0, "no_suit"]]
  end
end
