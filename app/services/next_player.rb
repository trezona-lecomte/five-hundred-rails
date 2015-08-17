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

    errors.none?
  end

  private

  def set_next_player
    # TODO move methods from tricks decorator to be scopes on card
    current_trick = round.active_trick
    if current_trick.cards.present?
      @next_player = next_player_based_on_cards_played(current_trick)
    elsif first_trick?(current_trick)
      set_player_for_first_trick
    else
      set_player_for_subsequent_trick
    end
  end

  def first_trick?(trick)
    trick.number_in_round == 1
  end

  def set_player_for_first_trick
    @next_player = round.winning_bid.player
  end

  def set_player_for_subsequent_trick
    @next_player = round.previous_trick_winner
  end

  def next_player_based_on_cards_played(current_trick)
    last_player_number = current_trick.cards.last_played.player.number_in_game

    next_player_number = last_player_number < 4 ? last_player_number + 1 : 1

    @players.find_by(number_in_game: next_player_number)
  end

  def add_error(message)
    @errors << message
  end
end
