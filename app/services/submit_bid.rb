class SubmitBid
  include ActiveModel::Validations

  attr_reader :round, :player, :number_of_tricks, :suit, :highest_bid

  validate       :bidding_is_open
  validates_with BidderTurnValidator
  validates_with BidHighEnoughValidator

  def initialize(round:, player:, number_of_tricks:, suit:)
    @round = round
    @player = player
    @number_of_tricks = number_of_tricks
    @suit = suit
    @highest_bid = round.bids.last
  end

  def call
    round.with_lock do
      valid? && submit_bid!
    end
  end

  private

  def bidding_is_open
    errors.add(:base, "bidding for this round has finished") unless round.in_bidding_stage?
  end

  def submit_bid!
    begin
      round.bids.create!(
        suit: suit,
        player: player,
        number_of_tricks: number_of_tricks
      )

    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.messages.each do |msg|
        errors.add(:base, msg)
      end
    rescue ArgumentError => e
      errors.add(:base, e.message)
    end
  end
end
