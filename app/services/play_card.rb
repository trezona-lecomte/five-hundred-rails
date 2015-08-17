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

      # TODO move to controller
      if @round.finished?
        score_round = ScoreRound.new(round)
        unless score_round.call
          @errors << score_round.errors
        end
      end
    end

    @errors.none?
  end

  private

  def valid_input?
    @trick && @round && @player && @card
  end

  def validate_card_can_be_played
    if !card_in_hand?
      add_error("you don't have this card in your hand")
    elsif !round.playing?
      add_error("cards can't be played on this round")
    elsif !trick_active?
      add_error("this trick is not active")
    elsif !players_turn?
      add_error("it's not your turn to play")
    end
  end

  def card_in_hand?
    (card.player == @player) && card.trick.blank?
  end

  def trick_active?
    @trick == round.active_trick && @trick.cards.count < 4
  end

  def players_turn?
    find_next_player = NextPlayer.new(round)
    find_next_player.call

    @player == find_next_player.next_player
  end

  def play_card
    @card.trick = @trick
    @card.number_in_trick = @trick.cards.count

    unless card.save
      add_error("you can't play this card right now")
    end
  end

  def add_error(message)
    @errors << message
  end
end
