# TODO: simplify this service to only check if a given player is next to bid
class FindNextBidder
  attr_reader :next_bidder, :messages

  def initialize(round)
    @round = round
    @messages = []
    @players = @round.game.players
    @next_bidder = nil
    @count_of_players_checked = 1
  end

  def call
    @round.with_lock do
      set_next_bidder
    end

    unless @next_bidder
      add_message("bidding for this round has finished")
    end

    @next_bidder.present?
  end

  private

  def set_next_bidder
    if round_is_awaiting_first_bid?
      set_bidder_for_first_bid
    else
      set_bidder_for_subsequent_bid
    end
  end

  def round_is_awaiting_first_bid?
    @round.bids.none?
  end

  def set_bidder_for_first_bid
    first_bidder_number = @round.order_in_game % @players.length

    first_bidder_number = @players.length if first_bidder_number == 0

    @next_bidder = @players.find_by(order_in_game: first_bidder_number)
  end

  def set_bidder_for_subsequent_bid
    until @next_bidder || all_players_have_been_checked?
      @next_bidder = next_bidder_in_order

      skip_bidder if bidder_has_already_passed?

      @count_of_players_checked += 1
    end
  end

  def all_players_have_been_checked?
    @count_of_players_checked == (@players.length - 1)
  end

  # TODO: try using mod to simplify this stuff..
  def next_bidder_in_order
    previous_player = @round.bids.in_playing_order.last.player

    incremented_order_in_game = previous_player.order_in_game + @count_of_players_checked
    incremented_order_in_game -= @players.length if incremented_order_in_game > @players.length

    @next_bidder = @players.detect { |player| player.order_in_game ==incremented_order_in_game }
  end

  def skip_bidder
    @next_bidder = nil
  end

  def bidder_has_already_passed?
    @round.bids.passes.any? { |pass| pass.player == @next_bidder }
  end

  def add_message(message)
    @messages << message
  end
end
