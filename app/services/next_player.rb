class NextPlayer
  attr_reader :round, :errors, :next_player

  def initialize(round)
    @round = RoundsDecorator.new(round)
    @cards = @round.cards
    @errors = []
    @players = @round.game.players
    @next_player = nil
  end

  def call
    @round.with_lock do
      set_next_player
    end

    unless @next_player
      add_error("cards can't currently be played in this round")
    end

    success?
  end

  private

  def set_next_player
    current_trick = TricksDecorator.new(@round.active_trick)
    if first_trick?
      set_player_for_first_trick(current_trick)
    else
      set_player_for_subsequent_trick(current_trick)
    end
  end

  def first_trick?
    @cards.select { |card| card.trick }.length < 4
  end

  def set_player_for_first_trick(current_trick)
    if has_no_cards?(current_trick)
      @next_player = @round.winning_bid.player
    else
      @next_player = next_player_based_on_cards_played(current_trick)
    end
  end

  def set_player_for_subsequent_trick(current_trick)
    if has_no_cards?(current_trick)
      previous_trick_number = current_trick.number_in_round - 1
      previous_trick = TricksDecorator.new(@round.tricks.find_by(number_in_round: previous_trick_number))

      @next_player = previous_trick.winning_card.player
    else
      @next_player = next_player_based_on_cards_played(current_trick)
    end
  end

  def has_no_cards?(trick)
    @cards.where(trick: trick).none?
  end

  def next_player_based_on_cards_played(current_trick)
    last_player = current_trick.last_played_card.player
    next_player_index = @players.index(last_player) + 1

    if next_player_index < @players.length
      @players[next_player_index]
    else
      @players[0]
    end
  end

  def add_error(message)
    @errors << message
  end

  def success?
    errors.empty?
  end
end
