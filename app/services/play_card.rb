class PlayCard
  attr_reader :round, :card

  def initialize(trick, player, card)
    @trick = trick
    @player = player
    @card = card
  end

  def call
    @card.with_lock do
      play_card if card_can_be_played
    end

    success?
  end

  private

  def card_can_be_played
    if @card.trick.blank? && @card.player == @player
      true
    else
      @card.errors.add(:trick, "can't have this card played by this player")

      false
    end
  end

  def play_card
    @card.trick = @trick

    unless @card.save
      @card.errors.add(:trick, "can't have this card played")
    end
  end

  def success?
    @card.errors.empty?
  end
end
