class NextPlayer
  attr_reader :round, :errors, :next_player

  def initialize(round)
    @round = round
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
#    binding.pry
    current_trick = @round.tricks.last

    if first_trick?
      set_player_for_first_trick(current_trick)
    else
      set_player_for_subsequent_trick(current_trick)
    end
  end

  def first_trick?
    @round.tricks.one?
  end

  def set_player_for_first_trick(current_trick)
    if current_trick.cards.none?
      @next_player = @round.winning_bid.player
    else
      @next_player = next_player_based_on_cards_played(current_trick)
    end
  end

  def set_player_for_subsequent_trick(current_trick)
    if current_trick.cards.none?
      tricks = @round.tricks
      previous_trick = TricksDecorator.new(tricks[tricks.index(current_trick) - 1])

      @next_player = previous_trick.winning_card.player
    else
      @next_player = next_player_based_on_cards_played(current_trick)
    end
  end

  def next_player_based_on_cards_played(current_trick)
    last_player = current_trick.cards.order(updated_at: :desc)[0].player
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
