class SubmitBid
  include ActiveModel::Validations

  attr_reader :round, :player, :number_of_tricks, :suit, :highest_bid

  validate :bidding_is_open
  validate :bid_is_high_enough
  validates_with BidderTurnValidator

  def initialize(round:, player:, number_of_tricks:, suit:)
    @round = round
    @player = player
    @number_of_tricks = number_of_tricks
    @suit = suit
    @highest_bid = round.bids.last
  end

  def call
    @round.with_lock do
      valid? && submit_bid!
    end
  end

  private

  def bidding_is_open
    errors.add(:base, "bidding for this round has finished") unless round.in_bidding_stage?
  end

  def bid_is_high_enough
    errors.add(:base, "your bid isn't high enough") unless bid_is_higher_than_previous_or_is_pass?
  end

  # TODO: how can I move this resp. onto bid..
  # TODO: instantiate a bid in submit_bid initializer, then use comparison of bids to do the below logic.
  def bid_is_higher_than_previous_or_is_pass?
    bid_is_a_pass? ||
    bid_is_first_in_round? ||
    bid_number_of_tricks_are_higher_than_previous? ||
    (bid_number_of_tricks_are_equal_to_previous? && bid_suit_is_higher_than_previous?)
  end

  def bid_is_first_in_round?
    !highest_bid
  end

  def bid_is_a_pass?
    number_of_tricks == Bid::PASS_TRICKS
  end

  def bid_number_of_tricks_are_higher_than_previous?
    number_of_tricks > highest_bid.number_of_tricks
  end

  def bid_number_of_tricks_are_equal_to_previous?
    number_of_tricks == highest_bid.number_of_tricks
  end

  def bid_suit_is_higher_than_previous?
    Bid.suits[suit] > Bid.suits[highest_bid.suit]
  end

  def submit_bid!
    begin
      @round.bids.create!(suit: @suit,
                          player: @player,
                          number_of_tricks: @number_of_tricks)

    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.messages.each do |msg|
        errors.add(:base, msg)
      end
    rescue ArgumentError => e
      errors.add(:base, e.message)
    end
  end
end
