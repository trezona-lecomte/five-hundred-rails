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
    @card.with_lock do
      unless @trick && @trick.cards.count < 4
        @trick = @round.tricks.create!
      end

      validate_card_can_be_played

      play_card unless @errors.present?
    end

    success?
  end

  private

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
