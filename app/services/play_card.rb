class PlayCard
  attr_reader :round, :card, :errors

  def initialize(round, player, card)
    @round = round
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
    if players_turn? && card_not_already_played? && player_owns_card?
      true
    else
      add_error("you can't play this card right now")
      false
    end
  end

  def players_turn?
    # if it's trick 1, then the winning bidder starts

    # if it's trick 2.. then the winner of the last trick starts
    true
  end

  def card_not_already_played?
    @card.trick.blank?
  end

  def player_owns_card?
    @card.player == @player
  end

  def play_card
    trick = @round.tricks.last

    if trick.cards.count > 3
      trick = trick.round.tricks.create!
    end

    @card.trick = trick

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
