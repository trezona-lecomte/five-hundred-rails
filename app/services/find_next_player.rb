class FindNextPlayer
  attr_reader :round, :errors, :next_player, :current_trick

  def initialize(round)
    @round = round
    @cards = @round.cards
    @errors = []
    @players = @round.game.players
    @next_player = nil
    @current_trick = @round.current_trick
  end

  def call
    @round.with_lock do
      set_next_player
    end

    unless @next_player
      add_error("cards can't currently be played in this round")
    end

    errors.none?
  end

  private

  def set_next_player
    if current_trick.cards.present?
      set_player_based_on_cards_played
    elsif first_trick?
      set_player_for_first_trick
    else
      set_player_for_subsequent_trick
    end
  end

  def first_trick?
    current_trick.order_in_round.zero?
  end

  def set_player_for_first_trick
    @next_player = round.highest_bid.player
  end

  def set_player_for_subsequent_trick
    @next_player = round.previous_trick.winning_player
  end

  def set_player_based_on_cards_played
    last_player_number = current_trick.cards.last_played.player.order_in_game

    # Either increment from the last player, or wrap to player 1 if it was player 4:
    next_player_number = last_player_number < @players.length - 1 ? last_player_number + 1 : 0

    @next_player = @players.find_by(order_in_game: next_player_number)
  end

  def add_error(message)
    @errors << message
  end
end
