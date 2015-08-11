class PlayCard
  attr_reader :round, :card, :errors

  def initialize(round, player, card)
    @round = RoundsDecorator.new(round)
    @player = player
    @card = card
    @trick = @round.tricks.last
    @errors = []
  end

  def call
    @round.with_lock do
      start_new_trick unless trick_already_in_progress

      validate_card_can_be_played

      play_card if @errors.none?
    end

    success?
  end

  private

  def trick_already_in_progress
    @trick && @trick.cards.count < 4
  end

  def start_new_trick
    @trick = @round.tricks.create!
  end

  def validate_card_can_be_played
    unless players_turn?
      add_error("it's not your turn to play")
    end

    unless bidding_finished?
      add_error("bidding hasn't yet finished for this round")
    end

    if card_already_played?
      add_error("you have already played this card")

    elsif !player_owns_card?
      add_error("you don't have this card in your hand")
    end
  end

  def bidding_finished?
    find_next_bidder = NextBidder.new(@round)
    find_next_bidder.call
    find_next_bidder.messages.include? "bidding for this round is finished"
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
    @card.position_in_trick = @trick.cards.length

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
