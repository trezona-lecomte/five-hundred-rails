class PlayCard
  attr_reader :round, :card, :errors, :trick

  def initialize(trick, player, card)
    @trick = trick
    @round = RoundsDecorator.new(trick.round)
    @player = player
    @card = card
    @errors = []
  end

  def call
    @round.with_lock do
      if valid_input?
        validate_card_can_be_played

        play_card if @errors.none?
      else
        add_error("couldn't play this card")
      end

      if round.finished?
        score_round = ScoreRound.new(round)
        unless score_round.call
          errors << score_round.errors
        end
      end
    end

    errors.none?
  end

  private

  def valid_input?
    @trick && @round && @player && @card
  end

  def validate_card_can_be_played
    if !player_owns_card?
      add_error("you don't have this card in your hand")
    elsif !round_in_playing_stage?
      add_error("bidding hasn't yet finished for this round")
    elsif card_already_played?
      add_error("you have already played this card")
    elsif !trick_active?
      add_error("this trick is not active")
    elsif !players_turn?
      add_error("it's not your turn to play")
    end
  end

  def trick_active?
    @trick == @round.active_trick && @trick.cards.count < 4
  end

  def round_in_playing_stage?
    @round.playing?
  end

  def players_turn?
    find_next_player = NextPlayer.new(@round)
    find_next_player.call

    @player == find_next_player.next_player
  end

  def card_already_played?
    @card.trick.present?
  end

  def player_owns_card?
    @card.player == @player
  end

  def play_card
    @card.trick = @trick
    @card.number_in_trick = @trick.cards.count

    unless @card.save
      add_error("you can't play this card right now")
    end
  end

  def add_error(message)
    @errors << message
  end
end
