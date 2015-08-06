class SubmitBid
  attr_reader :bid, :errors

  def initialize(round, player, number_of_tricks, suit)
    @round = round
    @player = player
    @number_of_tricks = number_of_tricks
    @suit = suit
    @bid = nil
    @errors = []
  end

  def call
    @round.with_lock do
      validate_bid_can_be_placed

      submit_bid unless errors.present?
    end
  end

  private

  def validate_bid_can_be_placed
    # TODO: need to handle when bidding has finished
    unless players_turn?
      add_error("it's not your turn to bid")
    end

    if bidding_has_finished?
      add_error("bidding for this round has finished")
    end
  end

  def players_turn?
    find_next_bidder = NextBidder.new(@round)
    find_next_bidder.call

    @player == find_next_bidder.next_bidder
  end

  def bidding_has_finished?
    !@player
  end

  def submit_bid
    bid = @round.bids.new(player: @player, number_of_tricks: @number_of_tricks, suit: @suit)

    bid.save
  end

  def add_error(message)
    @errors << message
  end
end