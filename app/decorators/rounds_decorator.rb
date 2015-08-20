# TODO Possibly create decorators for each stage that round can be in, otherwise split them onto AR classes.
# TODO RoundsDecorator is a meaningless name - need to describe the context in which it'll be used in the name.

class RoundsDecorator < SimpleDelegator
  def kitty
    cards.includes(:player).where(player: nil)
  end

  def unplayed_cards(player)
    cards.where(player: player).where(trick: nil)
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
