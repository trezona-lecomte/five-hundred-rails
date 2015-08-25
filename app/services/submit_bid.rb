class SubmitBid
  include ActiveModel::Validations

  attr_reader :round, :player, :number_of_tricks, :suit

  validates_with BidSubmissionValidator

  def initialize(round:, player:, number_of_tricks:, suit:)
    @round = round
    @player = player
    @number_of_tricks = number_of_tricks
    @suit = suit
  end

  def call
    @round.with_lock do
      valid? && submit_bid!
    end
  end

  private

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
