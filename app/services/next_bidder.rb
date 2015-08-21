class NextBidder
  attr_reader :next_bidder, :messages

  def initialize(round)
    @round = round
    @messages = []
    @players = @round.game.players
    @next_bidder = nil
  end

  def call
    @round.with_lock do
      set_next_bidder
    end

    unless @next_bidder
      add_message("bidding for this round is finished")
    end
  end

  private

  def set_next_bidder
    if @round.bids.none?
      set_bidder_for_first_bid
    else
      set_bidder_for_subsequent_bid
    end
  end

  def set_bidder_for_first_bid
    next_bidder_number = @round.number_in_game % @players.length

    if next_bidder_number == 0
      next_bidder_number = @players.length
    end

    @next_bidder = @players.detect do |player|
      player.number_in_game == next_bidder_number
    end
  end

  def set_bidder_for_subsequent_bid
    passed_players_offset = 0

    until @next_bidder || passed_players_offset > 3
      incremented_index = next_bidder_index(passed_players_offset)

      @next_bidder = fetch_next_bidder(incremented_index)

      if bidder_has_already_passed?
        @next_bidder = nil
      end

      passed_players_offset += 1
    end
  end

  def bidder_has_already_passed?
    @round.bids.passes.any? { |pass| pass.player == @next_bidder }
  end

  def next_bidder_index(offset)
    (@round.bids.count % @players.count) + offset
  end

  def fetch_next_bidder(index)
    index < @players.length ? @players[index] : @players[0]
  end

  def add_message(message)
    @messages << message
  end
end
