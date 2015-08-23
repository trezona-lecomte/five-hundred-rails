class FindAvailableBidParams
  attr_reader :round, :available_bid_params, :errors

  def initialize(round)
    @round = round
    @available_bid_params = []
    @errors = []
  end

  def call
    round.with_lock do
      validate_round_can_be_bid_on

      if errors.none?
        generate_available_bid_params
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

  def generate_available_bid_params
    if any_bids?
      @available_bid_params = bid_params_above_highest_bid << Bid.params_for_pass_bid
    else
      @available_bid_params = all_bid_params
    end
  end

  def any_bids?
    round.bids.non_passes.any?
  end

  def all_bid_params
    bid_params_for_non_pass_bids << Bid.params_for_pass_bid
  end

  def bid_params_for_non_pass_bids
    (Bid::MIN_TRICKS..Bid::MAX_TRICKS).to_a.product(Bid.suits.keys).map do |tricks, suit|
      { number_of_tricks: tricks, suit: suit }
    end
  end

  def bid_params_above_highest_bid
    highest_bid    = round.highest_bid
    highest_tricks = highest_bid.number_of_tricks
    highest_suit   = highest_bid.suit

    bid_params_for_non_pass_bids.select do |params|
      (params[:number_of_tricks] > highest_tricks) ||
      (params[:number_of_tricks] == highest_tricks && Bid.suits[params[:suit]] > Bid.suits[highest_suit])
    end
  end

  def add_error(message)
    @errors << message
  end
end
