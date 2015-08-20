class PlayCard
  attr_reader :round, :card, :errors, :trick

  def initialize(trick, player, card)
    @trick = trick
    @round = trick.round
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
    elsif !round.in_playing_stage?
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
    @trick == round.current_trick
  end

  def players_turn?
    find_next_player = NextPlayer.new(round)
    find_next_player.call

    @player == find_next_player.next_player
  end

  def play_card
    @trick.cards << @card
    @trick.reload
    @card.number_in_trick = @trick.cards_count

    binding.pry if @trick.cards_count == 0

    unless @card.save
      add_error("you can't play this card right now: #{@card.errors.full_messages}, #{@trick.errors.full_messages}")
    end
  end

  def add_error(message)
    @errors << message
  end
end
