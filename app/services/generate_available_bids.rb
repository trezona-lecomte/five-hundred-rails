class GenerateAvailableBids
  include ActiveModel::Validations

  attr_reader :round, :available_bids

  validate :round_can_be_bid_on

  def initialize(round)
    @round = round
    @available_bids = []
  end

  def call
    round.with_lock do
      valid? && generate_available_bids
    end
  end

  private

  def round_can_be_bid_on
    errors.add(:base, "this round isn't in the bidding stage") if !round.in_bidding_stage?
  end

  def generate_available_bids
    if any_non_pass_bids_made_yet?
      @available_bids = [Bid.passes.new] + bids_above_current_highest_bid
    else
      @available_bids = all_possible_bids
    end
  end

  def any_non_pass_bids_made_yet?
    round.bids.non_passes.any?
  end

  def all_possible_bids
    [Bid.passes.new] + all_possible_non_pass_bids
  end

  def all_possible_non_pass_bids
    (Bid::MIN_TRICKS..Bid::MAX_TRICKS).to_a.product(Bid.suits.keys).map do |tricks, suit|
      Bid.new(number_of_tricks: tricks, suit: suit)
    end
  end

  def bids_above_current_highest_bid
    highest_bid    = round.highest_bid
    highest_tricks = highest_bid.number_of_tricks
    highest_suit   = highest_bid.suit

    all_possible_non_pass_bids.select do |bid|
      (bid.number_of_tricks > highest_tricks) ||
      (bid.number_of_tricks == highest_tricks && Bid.suits[bid.suit] > Bid.suits[highest_suit])
    end
  end
end
