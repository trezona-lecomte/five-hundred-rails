class PlayCard
  include ActiveModel::Validations

  attr_reader :round, :trick, :player, :card

  validates_with PlayCardValidator

  def initialize(trick:, player:, card:)
    @trick = trick
    @round = trick.round
    @player = player
    @card = card
  end

  def call
    @round.with_lock do
      valid? && play_card
    end
  end

  private

  def play_card
    @trick.cards << @card
    @trick.reload
    @card.order_in_trick = @trick.cards_count

    # TODO follow pattern from other service for bubbling errors up
    unless @card.save
      errors.add(:base, "you can't play this card right now: #{@card.errors.full_messages}, #{@trick.errors.full_messages}")
    end
  end
end
