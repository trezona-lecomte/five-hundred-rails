# TODO: These methods belong closer to the active record layer.
# Possibly create decorators for each stage that round can be in, otherwise split them onto AR classes.
# RoundsDecorator is a meaningless name - need to describe the context in which it'll be used in the name.

class RoundsDecorator < SimpleDelegator
  # TODO this could be moved out to a service (i.e., find_available_bids(round))
  def available_bids
    if in_bidding_stage?
      # TODO if any bids, rather than if winning_bid.
      if winning_bid
        pass_bid + bids_above_highest_bid(non_pass_bids, winning_bid)
      else
        pass_bid + non_pass_bids
      end
    else
      []
    end
  end

  # TODO probably rename to highest_bid, this is misleading.
  def winning_bid
    bids.in_ranked_order.first
  end

  def kitty
    cards.includes(:player).where("player_id is null")
  end

  def unplayed_cards(player)
    cards.where(player: player).where("trick_id": nil)
  end

  private

  # TODO why pass non_pass_bids??? craziness..
  # TODO this could take pass bid as a default (could take current highest bid) - try to generalize down to map
  def bids_above_highest_bid(non_pass_bids, highest_bid)
    highest_tricks = highest_bid.number_of_tricks
    highest_suit = highest_bid.suit

    non_pass_bids.select do |number_of_tricks, suit|
       number_of_tricks  > highest_tricks ||
      (number_of_tricks == highest_tricks && Bid.suits[suit] > Bid.suits[highest_suit])
    end
  end

  # TODO rename to bids_that_are_not_passes
  def non_pass_bids
    (6..10).to_a.product(Bid.suits.keys)
  end

  # TODO move this to be a constant on Bid.
  # TODO implement a method on bid for passing & another to compare bids.
  def pass_bid
    [[0, "no_suit"]]
  end
end
