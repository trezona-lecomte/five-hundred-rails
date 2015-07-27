class PlayCard
  attr_reader :round, :card

  def initialize(round, card)
    @round = round
    @card = card
  end

  def call
    @round.with_lock do
      play_card if card_can_be_played
    end

    success?
  end

  private

  def card_can_be_played
    true
  end

  def play_card
    round.actions.new(player: @card.player, card: @card)

    round.save
  end

  def success?
    @round.errors.empty?
  end
end
