class SubmitBid
  include ActiveModel::BidSubmissionValidator

  attr_reader :bid, :round

  validates_with BidSubmissionValidator
  #validate :this_players_turn
  #validate :bidding_is_open

  def initialize(round, player, number_of_tricks, suit)
    @round = round
    @player = player
    @number_of_tricks = number_of_tricks
    @suit = suit
    @bid = nil
  end

  def call
    @round.with_lock do
      valid? && submit_bid
    end
  end

  private

  def submit_bid
    begin
      @round.bids.create!(suit: @suit,
                          player: @player,
                          number_of_tricks: @number_of_tricks,
                          order_in_round: @round.bids.count)

    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.messages.each do |msg|
        errors.add(:base, msg)
      end
    rescue ArgumentError => e
      errors.add(:base, e.message)
    end
  end
end
