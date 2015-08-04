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
      validate_card_can_be_played

      play_card unless errors.present?
    end

    success?
  end

  private

  def validate_card_can_be_played
    unless players_turn?
      add_error("it's not your turn to play")
    end

    if card_already_played?
      add_error("you have already played this card")
    end

    unless player_owns_card?
      add_error("you don't have this card in your hand")
    end
  end

  def players_turn?
    # if it's trick 1, then the winning bidder starts
    # TODO: for now we assume that player 2 won the bidding:
    if round.tricks.count == 1 && round.tricks.last.cards.empty?
      @player == @round.game.players.first(2).last
    else
      # if it's trick 2.. then the winner of the last trick starts
      trick = TricksDecorator.new(round.tricks.last)

      @player == trick.winning_card.player
    end
  end

  def card_already_played?
    @card.trick.present?
  end

  def player_owns_card?
    @card.player == @player
  end

  def play_card
    trick = @round.tricks.last

    unless trick && trick.cards.count < 4
      trick = trick.round.tricks.create!
    end

    @card.trick = trick

    unless @card.save
      add_error("you can't play this card right now")
    end
  end

  def add_error(message)
    @errors << message
  end

  def success?
    @errors.empty?
  end
end
