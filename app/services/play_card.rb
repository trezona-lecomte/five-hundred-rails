class PlayCard
  attr_reader :round, :card, :errors

  def initialize(trick, player, card)
    @trick = trick
    @player = player
    @card = card
    @errors = []
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
      add_error("you can't play this card right now")

      false
    end
  end

  def play_card
    if @trick.cards.count > 3
      @trick = @trick.round.tricks.create!
    end

    @card.trick = @trick

    unless @card.save
      add_error("you can't play this card right now")
    end
  end

  def success?
    @errors.empty?
  end

  def add_error(message)
    @errors << message
  end
end
