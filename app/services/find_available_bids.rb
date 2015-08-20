class FindAvailableBids
  attr_reader :round, :available_bids, :errors

  def initialize(round)
    @round = round
    @available_bids = []
    @errors = []
  end

  def call
    round.with_lock do
      validate_round_can_be_bid_on

      if errors.none?
        generate_available_bids
      end
    end

    errors.none?
  end

  private

  def validate_round_can_be_bid_on
    unless round.in_bidding_stage?
      add_error("this round isn't in the bidding stage")
    end
  end

  def generate_available_bids
    if any_bids?
      @available_bids = pass_bid + bids_above_current_highest_bid
    else
      @available_bids = pass_bid + bids_that_are_not_passes
    end
  end

  def any_bids?
    round.bids.any?
  end

  # TODO this could take pass bid as a default (could take current highest bid) - try to generalize down to map
  def bids_above_current_highest_bid
    highest_bid = round.highest_bid
    highest_tricks = highest_bid.number_of_tricks
    highest_suit   = highest_bid.suit

    bids_that_are_not_passes.select do |tricks, suit|
      tricks > highest_tricks || (tricks == highest_tricks && Bid.suits[suit] > Bid.suits[highest_suit])
    end
  end

  def bids_that_are_not_passes
    (6..10).to_a.product(Bid.suits.keys)
  end

  # TODO move this to be a constant on Bid.
  # TODO implement a method on bid for passing & another to compare bids.
  def pass_bid
    [[0, "no_suit"]]
  end

  def add_error(message)
    @errors << message
  end
end
